import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_nutrition/pages/admin/home_page.dart';
import 'package:smart_nutrition/provider/providers.dart';
import '../../models/filter_model.dart';
import '../../models/meal_model.dart';

class AddMealPage extends ConsumerStatefulWidget {
  final Meal? meal;
  final bool isEditing;

  const AddMealPage({this.meal, this.isEditing = false, super.key});

  @override
  ConsumerState<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends ConsumerState<AddMealPage> {
  late List<String> categoryKeys = [
    "national_dishes",
    "fast_food",
    "fruits",
    "international_dishes",
    "drinks",
    "bread_and_pastry_products",
    "salads",
    "sweets_and_desserts",
    "greens_and_vegetable_dishes",
    "for_athletes",
  ];
  List<String> selectedCtg = [];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.meal != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeFormWithMealData(widget.meal!);
      });
    }
  }

  @override
  void dispose() {
    // Form kontrollerlarini tozalash
    ref.read(titleControllerProvider).clear();
    ref.read(timeControllerProvider).clear();
    ref.read(ingredientsControllerProvider).clear();
    ref.read(stepsControllerProvider).clear();

    // Filterlarni tozalash
    final filterNotifier = ref.read(filterProvider.notifier);
    filterNotifier.resetFilters();

    // Image file ni tozalash
    ref.read(imagePickerProvider.notifier).clearImage();

    // Kategoriyalarni tozalash
    ref.read(selectedCategoriesProvider.notifier).clearCategory();

    super.dispose();
  }

  void _initializeFormWithMealData(Meal meal) {
    ref.read(titleControllerProvider).text = meal.title ?? '';
    ref.read(timeControllerProvider).text = meal.duration?.toString() ?? '';
    ref.read(ingredientsControllerProvider).text = meal.ingredients ?? '';
    ref.read(stepsControllerProvider).text = meal.steps ?? '';

    if (meal.category != null) {
      selectedCtg = List.from(meal.category!);
      ref.read(selectedCategoriesProvider.notifier).setAll(selectedCtg);
    }

    final filter = ref.read(filterProvider.notifier);
    filter.setAll(
      isVegetarian: meal.isVegetarian ?? false,
      isDiabetes: meal.isDiabetes ?? false,
      isCalorie: meal.isCalorie ?? false,
      isKids: meal.isKids ?? false,
      isProtein: meal.isProtein ?? false,
    );
  }

  void _showCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text("str_select_categories".tr()),
          content: Consumer(
            builder: (context, ref, child) {
              final selectedCategories = ref.watch(selectedCategoriesProvider);
              final selectedCategoriesNotifier = ref.read(
                selectedCategoriesProvider.notifier,
              );

              return SizedBox(
                width: 400,
                height: 400,

                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categoryKeys.length,
                  itemBuilder: (context, index) {
                    final categoryKey  = categoryKeys[index];
                    final isSelected = selectedCategories.contains(categoryKey);

                    return CheckboxListTile(
                      title: Text("str_$categoryKey".tr()),
                      value: isSelected,
                      activeColor:
                          Colors.primaries[index % Colors.primaries.length],
                      onChanged: (_) {
                        selectedCategoriesNotifier.toggleCategory(categoryKey);
                      },
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                ref.refresh(selectedCategoriesProvider);
                Navigator.pop(context);
              },
              child:  Text(  "str_cancel".tr()),
            ),
            ElevatedButton(
              onPressed: () {
                selectedCtg =
                    ref.read(selectedCategoriesProvider.notifier).selectedList;
                Navigator.pop(context);
              },
              child:  Text("str_select".tr()),
            ),
          ],
        );
      },
    );
  }

  void _handleSubmit(BuildContext context) async {
    if (!_validateForm()) return;

    ref.read(loadingProvider.notifier).startLoading();

    try {
      final imageUrl = await _handleImageUpload();
      if (imageUrl == null) {
        return;
      }

      final meal = _createMealObject(imageUrl);

      if (widget.isEditing) {
        await _updateMeal(meal);
      } else {
        await _addNewMeal(meal);
      }

      _showSuccessMessage();
      _resetAndNavigateBack();
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      _showErrorMessage(e);
    } finally {
      ref.read(loadingProvider.notifier).stopLoading();
    }
  }

  void _resetAndNavigateBack() {
    ref.read(titleControllerProvider).clear();
    ref.read(timeControllerProvider).clear();
    ref.read(ingredientsControllerProvider).clear();
    ref.read(stepsControllerProvider).clear();

    // Filterlarni tozalash
    final filterNotifier = ref.read(filterProvider.notifier);
    filterNotifier.resetFilters();

    // Image file ni tozalash
    ref.read(imagePickerProvider.notifier).clearImage();

    // Kategoriyalarni tozalash
    ref.read(selectedCategoriesProvider.notifier).clearCategory();
  }

  bool _validateForm() {
    final title = ref.read(titleControllerProvider).text;
    final time = ref.read(timeControllerProvider).text;
    final ingredient = ref.read(ingredientsControllerProvider).text;
    final steps = ref.read(stepsControllerProvider).text;

    if (title.isEmpty) {
      _showValidationError("str_please_enter_meal_title".tr());
      return false;
    }
    if (time.isEmpty || int.tryParse(time) == null) {
      _showValidationError("str_please_enter_valid_cooking_time".tr());
      return false;
    }
    if (ingredient.isEmpty) {
      _showValidationError("str_please_enter_ingredients".tr());
      return false;
    }
    if (steps.isEmpty) {
      _showValidationError("str_please_enter_cooking_steps".tr());
      return false;
    }
    if (selectedCtg.isEmpty) {
      _showValidationError("str_please_select_at_least_one_category".tr());
      return false;
    }
    return true;
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message.tr())));
  }

  Future<String?> _handleImageUpload() async {
    final storage = ref.read(authProvider.notifier);
    final imageFile = ref.read(imagePickerProvider);

    if (imageFile != null) {
      return await storage.uploadMealImage(imageFile);
    }
    return widget.meal?.imageUrl;
  }

  Meal _createMealObject(String imageUrl) {
    return Meal(
      id: widget.meal?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: ref.read(titleControllerProvider).text,
      imageUrl: imageUrl,
      duration: int.tryParse(ref.read(timeControllerProvider).text) ?? 0,
      ingredients: ref.read(ingredientsControllerProvider).text,
      steps: ref.read(stepsControllerProvider).text,
      category: selectedCtg,
      isVegetarian: ref.read(filterProvider).isVegetarian,
      isDiabetes: ref.read(filterProvider).isDiabetes,
      isCalorie: ref.read(filterProvider).isCalorie,
      isKids: ref.read(filterProvider).isKids,
      isProtein: ref.read(filterProvider).isProtein,
    );
  }

  Future<void> _updateMeal(Meal meal) async {
    final storage = ref.read(authProvider.notifier);
    await storage.updateMeal(meal);
  }

  Future<void> _addNewMeal(Meal meal) async {
    final storage = ref.read(authProvider.notifier);
    await storage.addMeal(meal);
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isEditing ? "str_meal_updated".tr() : "str_meal_added".tr(),
          style: TextStyle(color: Colors.white, letterSpacing: 3.0),
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showErrorMessage(dynamic error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("str_error".tr()),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    final imageFile = ref.watch(imagePickerProvider);
    final filterState = ref.watch(filterProvider);
    final filterNotifier = ref.read(filterProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.isEditing ? "str_edit_meal".tr() : "str_add_meal".tr()),
        leading: BackButton(
          onPressed: () {
            _resetAndNavigateBack();
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  // Image Section
                  _buildImageSection(imageFile),
                  const SizedBox(height: 20),

                  // Form Fields
                  _buildTextField(ref.watch(titleControllerProvider)),
                  const SizedBox(height: 10),
                  _buildTextField(ref.watch(timeControllerProvider)),
                  const SizedBox(height: 10),
                  _buildTextField(ref.watch(ingredientsControllerProvider)),
                  const SizedBox(height: 10),
                  _buildTextField(ref.watch(stepsControllerProvider)),
                  const SizedBox(height: 20),

                  // Categories Button
                  _buildCategoriesButton(context),
                  const SizedBox(height: 20),

                  // Filters Section
                   Text("str_filters".tr(), style: TextStyle(fontSize: 25)),
                  const SizedBox(height: 20),
                  _buildFilterSwitches(filterState, filterNotifier),
                  const SizedBox(height: 25),

                  // Submit Button
                  _buildSubmitButton(),
                  SizedBox(height: 30),
                ],
              ),
              if (isLoading) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(File? imageFile) {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap:
            () => ref
                .read(imagePickerProvider.notifier)
                .pickImage(ImageSource.gallery),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child:
              imageFile != null
                  ? Image.file(imageFile, fit: BoxFit.cover)
                  : (widget.meal?.imageUrl != null
                      ? Image.network(widget.meal!.imageUrl!, fit: BoxFit.cover)
                      : const Icon(Icons.add, size: 80)),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: _getHintText(controller).tr(),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  String _getHintText(TextEditingController controller) {
    if (controller == ref.read(titleControllerProvider)) return "str_title".tr();
    if (controller == ref.read(timeControllerProvider)) {
      return "str_cooking_time".tr();
    }
    if (controller == ref.read(ingredientsControllerProvider)) {
      return "str_ingredients".tr();
    }
    if (controller == ref.read(stepsControllerProvider)) return "str_steps".tr();
    return "";
  }

  Widget _buildCategoriesButton(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: MaterialButton(
          color: const Color(0xFF3E9FBD),
          onPressed: () => _showCategoryDialog(context),
          child:  Text("str_select_categories".tr()),
        ),
      ),
    );
  }

  Widget _buildFilterSwitches(FilterState state, FilterNotifier notifier) {
    return Column(
      children: [
        _buildSwitch(
          title: "str_vegetarian",
          value: state.isVegetarian,
          onChanged: (_) => notifier.toggleVegetarian(),
        ),
        _buildSwitch(
          title: "str_diabetes",
          value: state.isDiabetes,
          onChanged: (_) => notifier.toggleDiabetes(),
        ),
        _buildSwitch(
          title: "str_calorie",
          value: state.isCalorie,
          onChanged: (_) => notifier.toggleCalorie(),
        ),
        _buildSwitch(
          title: "str_kids",
          value: state.isKids,
          onChanged: (_) => notifier.toggleKids(),
        ),
        _buildSwitch(
          title: "str_protein",
          value: state.isProtein,
          onChanged: (_) => notifier.toggleProtein(),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: MaterialButton(
          color: const Color(0xFFBD883E),
          onPressed: () {
            final currentContext = context;
            _handleSubmit(currentContext);
          },
          child: Text(widget.isEditing ? "str_update_meal".tr() : "str_add_meal".tr()),
        ),
      ),
    );
  }

  Widget _buildSwitch({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title.tr(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          letterSpacing: 3,
        ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
