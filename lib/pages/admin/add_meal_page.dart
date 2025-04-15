import 'dart:io';

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
  List<String> categoriesList = [
    'National dishes',
    "Fast food",
    "Fruits",
    "International dishes",
    "Drinks",
    "Bread and pastry products",
    "Salads",
    "Sweets and desserts",
    "Greens and vegetable dishes",
    "For athletes",
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
          title: const Text("Select Categories"),
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
                  itemCount: categoriesList.length,
                  itemBuilder: (context, index) {
                    final category = categoriesList[index];
                    final isSelected = selectedCategories.contains(category);

                    return CheckboxListTile(
                      title: Text(category),
                      value: isSelected,
                      activeColor: Colors.primaries[index % Colors.primaries.length],
                      onChanged: (_) {
                        selectedCategoriesNotifier.toggleCategory(category);
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
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                selectedCtg = ref.read(selectedCategoriesProvider.notifier).selectedList;
                Navigator.pop(context);
              },
              child: const Text("Select"),
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
     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
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
      _showValidationError('Please enter meal title');
      return false;
    }
    if (time.isEmpty || int.tryParse(time) == null) {
      _showValidationError('Please enter valid cooking time');
      return false;
    }
    if (ingredient.isEmpty) {
      _showValidationError('Please enter ingredients');
      return false;
    }
    if (steps.isEmpty) {
      _showValidationError('Please enter cooking steps');
      return false;
    }
    if (selectedCtg.isEmpty) {
      _showValidationError('Please select at least one category');
      return false;
    }
    return true;
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
        content: Text(widget.isEditing ? 'Meal updated!' : 'Meal added!',style: TextStyle(color: Colors.white,letterSpacing: 3.0),),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showErrorMessage(dynamic error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: ${error.toString()}'),
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
        title: Text(widget.isEditing ? 'Edit Meal' : 'Add Meal'),
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
                  _buildTextField(ref.watch(titleControllerProvider),),
                  const SizedBox(height: 10),
                  _buildTextField(ref.watch(timeControllerProvider),),
                  const SizedBox(height: 10),
                  _buildTextField(ref.watch(ingredientsControllerProvider)),
                  const SizedBox(height: 10),
                  _buildTextField(ref.watch(stepsControllerProvider)),
                  const SizedBox(height: 20),

                  // Categories Button
                  _buildCategoriesButton(context),
                  const SizedBox(height: 20),

                  // Filters Section
                  const Text('Filters', style: TextStyle(fontSize: 25)),
                  const SizedBox(height: 20),
                  _buildFilterSwitches(filterState, filterNotifier),
                  const SizedBox(height: 25),

                  // Submit Button
                  _buildSubmitButton(),

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
        onTap: () => ref.read(imagePickerProvider.notifier).pickImage(ImageSource.gallery),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: imageFile != null
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
          hintText: _getHintText(controller),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  String _getHintText(TextEditingController controller) {
    if (controller == ref.read(titleControllerProvider)) return "Title";
    if (controller == ref.read(timeControllerProvider)) return "Cooking time (minutes)";
    if (controller == ref.read(ingredientsControllerProvider)) return "Ingredients";
    if (controller == ref.read(stepsControllerProvider)) return "Steps";
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
          child: const Text('Select Categories'),
        ),
      ),
    );
  }

  Widget _buildFilterSwitches(FilterState state, FilterNotifier notifier) {
    return Column(
      children: [
        _buildSwitch(
          title: 'Vegetarian',
          value: state.isVegetarian,
          onChanged: (_) => notifier.toggleVegetarian(),
        ),
        _buildSwitch(
          title: 'Diabetes',
          value: state.isDiabetes,
          onChanged: (_) => notifier.toggleDiabetes(),
        ),
        _buildSwitch(
          title: 'Calorie',
          value: state.isCalorie,
          onChanged: (_) => notifier.toggleCalorie(),
        ),
        _buildSwitch(
          title: 'Kids',
          value: state.isKids,
          onChanged: (_) => notifier.toggleKids(),
        ),
        _buildSwitch(
          title: 'Protein',
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
          onPressed: (){
            final currentContext = context;
            _handleSubmit(currentContext);
          },
          child: Text(widget.isEditing ? 'Update Meal' : 'Add Meal'),
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
        title,
        style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 3),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}