import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_nutrition/pages/meal_detail_page.dart';
import '../models/meal_model.dart';
import '../provider/providers.dart';

class MealsPage extends ConsumerWidget {
  MealsPage({super.key, required this.categoryName});
  final String? categoryName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealData = ref.watch(mealProvider);
    final filter = ref.watch(filterProvider);

    return Scaffold(
      appBar: AppBar(),
      body: mealData.when(
        data: (meals) {
          // 1. Avval category bo'yicha filtrlash
          var categoryMeals = meals.where((meal) =>
          meal.category?.contains(categoryName) ?? false).toList();

          if (categoryMeals.isEmpty) {
            return Center(child: Text("str_no_food_available".tr()));
          }

          // 2. Filterlarni qo'llash
          final filteredMeals = categoryMeals.where((meal) {
            bool matchesAllFilters = true;
            if (filter.isVegetarian) matchesAllFilters = matchesAllFilters && (meal.isVegetarian ?? false);
            if (filter.isProtein) matchesAllFilters = matchesAllFilters && (meal.isProtein ?? false);
            if (filter.isKids) matchesAllFilters = matchesAllFilters && (meal.isKids ?? false);
            if (filter.isCalorie) matchesAllFilters = matchesAllFilters && (meal.isCalorie ?? false);
            if (filter.isDiabetes) matchesAllFilters = matchesAllFilters && (meal.isDiabetes ?? false);
            return matchesAllFilters;
          }).toList();

          // 3. Agar filter qo'llanganidan keyin hech narsa qolmasa
          if (filteredMeals.isEmpty) {
            return Center(child: Text("str_no_food_available".tr()));
          }

          // 4. Filtrlangan taomlarni ko'rsatish
          return ListView.builder(
            itemCount: filteredMeals.length,
            itemBuilder: (context, index) {
              return _mealItem(context, filteredMeals[index]);
            },
          );
        },
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => Center(child: LinearProgressIndicator()),
      ),
    );
  }

  Widget _mealItem(BuildContext context, Meal meal) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MealDetailPage(meal: meal)),
          );
        },
        child: SizedBox(
          width: double.infinity,
          height: 250,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.network(
                  meal.imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  color: Colors.black54,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        meal.title!,
                        style: TextStyle(fontSize: 18, letterSpacing: 3),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.clock, size: 15),
                          SizedBox(width: 10),
                          Text(
                            'duration_minutes'.tr(args: ['${meal.duration}']),
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}