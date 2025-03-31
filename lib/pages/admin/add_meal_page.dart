import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_nutrition/provider/providers.dart';
import 'package:smart_nutrition/service/log_service.dart';

import '../../models/meal_model.dart';

class AddMealPage extends ConsumerWidget {
  AddMealPage({super.key});

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

  void _showCategoryDialog(
    BuildContext context,
    WidgetRef ref,
    List<String> categoriesList,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Categories"),
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
                      activeColor:
                          Colors.primaries[index % Colors.primaries.length],
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
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                selectedCtg = ref.read(selectedCategoriesProvider.notifier).selectedList;
                if(selectedCtg.isNotEmpty){
                  LogService.d(selectedCtg.last.toString());
                }
                ref.refresh(selectedCategoriesProvider);
                Navigator.pop(context);
              },
              child: Text("Select"),
            ),
          ],
        );
      },
    );
  }

  void uploadImage(BuildContext context, WidgetRef ref) async {
    final imageFile = ref.read(imagePickerProvider.notifier);
    final storage = ref.read(authProvider.notifier);
    await storage.uploadMealImage(imageFile as File);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);
    final storage = ref.read(authProvider.notifier);
    final title = ref.watch(titleControllerProvider);
    final time = ref.watch(timeControllerProvider);
    final ingredient = ref.watch(ingredientsControllerProvider);
    final steps = ref.watch(stepsControllerProvider);
    final imageFile = ref.watch(imagePickerProvider);
    final filterState = ref.watch(filterProvider);
    final filterNotifier = ref.read(filterProvider.notifier);
    final categoriesNotifier = ref.watch(selectedCategoriesProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            ref.read(titleControllerProvider).clear();
            ref.read(timeControllerProvider).clear();
            ref.read(stepsControllerProvider).clear();
            ref.read(ingredientsControllerProvider).clear();
            ref.refresh(filterProvider);
            ref.refresh(imagePickerProvider);
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        ref
                            .read(imagePickerProvider.notifier)
                            .pickImage(ImageSource.gallery);
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child:
                            imageFile == null
                                ? SizedBox(
                                  width: double.infinity,
                                  height: 250,
                                  child: Icon(Icons.add, size: 80),
                                )
                                : Image.file(
                                  imageFile,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 250,
                                ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // MEALS SETTINGS
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      controller: title,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(hintText: "Title"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: time,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(hintText: "Cooking time"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      controller: ingredient,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(hintText: "Ingredients"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      controller: steps,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(hintText: "Steps"),
                    ),
                  ),
                  SizedBox(height: 20),
                  ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: MaterialButton(
                        elevation: 0,
                        color: Color(0xFF3E9FBD),
                        onPressed: () {
                          _showCategoryDialog(context, ref, categoriesList);
                        },
                        child: Text('Select Categories'),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Filters', style: TextStyle(fontSize: 25)),
                  const SizedBox(height: 20),

                  _buildSwitch(
                    title: 'Vegetarian',
                    value: filterState.isVegetarian,
                    onChanged: (value) => filterNotifier.toggleVegetarian(),
                  ),
                  _buildSwitch(
                    title: 'Diabetes',
                    value: filterState.isDiabetes,
                    onChanged: (value) => filterNotifier.toggleDiabetes(),
                  ),
                  _buildSwitch(
                    title: 'Calorie',
                    value: filterState.isCalorie,
                    onChanged: (value) => filterNotifier.toggleCalorie(),
                  ),
                  _buildSwitch(
                    title: 'Kids',
                    value: filterState.isKids,
                    onChanged: (value) => filterNotifier.toggleKids(),
                  ),
                  _buildSwitch(
                    title: 'Protein',
                    value: filterState.isProtein,
                    onChanged: (value) => filterNotifier.toggleProtein(),
                  ),
                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      clipBehavior: Clip.antiAlias,
                      child: MaterialButton(
                        color: Color(0xFFBD883E),
                        onPressed: () async {

                          if (imageFile != null && title.text.isNotEmpty) {
                            ref.read(loadingProvider.notifier).startLoading();
                            String? imageUrl = await storage.uploadMealImage(
                              imageFile,
                            );

                            if (imageUrl != null) {

                              Meal newMeal = Meal(
                                id:
                                    DateTime.now().millisecondsSinceEpoch
                                        .toString(),
                                title: title.text,
                                imageUrl: imageUrl,
                                duration: int.tryParse(time.text) ?? 0,
                                ingredients: ingredient.text,
                                steps: steps.text,
                                // TODO
                                category: selectedCtg,
                                isVegetarian: filterState.isVegetarian,
                                isDiabetes: filterState.isDiabetes,
                                isCalorie: filterState.isCalorie,
                                isKids: filterState.isKids,
                                isProtein: filterState.isProtein,
                              );

                              await storage.addMeal(newMeal);
                              ref.refresh(imagePickerProvider);
                              ref.read(loadingProvider.notifier).stopLoading();
                              ref.read(titleControllerProvider).clear();
                              ref.read(timeControllerProvider).clear();
                              ref.read(stepsControllerProvider).clear();
                              ref.read(ingredientsControllerProvider).clear();
                              ref.refresh(filterProvider);
                              ref.refresh(imagePickerProvider);
                             if(selectedCtg.isEmpty){
                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('category was not selected')));
                              return;
                             }
                              Navigator.pop(context,'success');
                            }
                          }
                        },
                        child: Text('Upload'),
                      ),
                    ),
                  ),
                ],
              ),

              isLoading ? CircularProgressIndicator() : SizedBox.shrink(),
            ],
          ),
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
        style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 3),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
