import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal_model.dart';
import '../provider/providers.dart';
import 'meal_detail_page.dart';

class SearchMealsPage extends ConsumerStatefulWidget {
  const SearchMealsPage({super.key});

  @override
  ConsumerState<SearchMealsPage> createState() => _SearchMealsPageState();
}

class _SearchMealsPageState extends ConsumerState<SearchMealsPage> {
  bool searchByTitle = true;
  bool searchByIngredients = true;

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
    final mealData = ref.watch(mealProvider);
    final filter = ref.watch(filterProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 2, color: Color(0xFFBD883E)),
          ),
          child: SearchBar(
            autoFocus: true,
            leading: Icon(Icons.search, size: 20),
            elevation: MaterialStateProperty.all(0),
            onChanged: (value) {
              ref.read(searchQueryProvider.notifier).state = value;
            },
          ),
        ),
        leading: BackButton(
          onPressed: () {
            ref.read(searchQueryProvider.notifier).state = "";
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "str_search_options".tr(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Divider(),
                            CheckboxListTile(
                              title: Text("str_search_by_title".tr()),
                              value: searchByTitle,
                              onChanged: (value) {
                                setState(() {
                                  searchByTitle = value!;
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: Text("str_search_by_ingredients".tr()),
                              value: searchByIngredients,
                              onChanged: (value) {
                                setState(() {
                                  searchByIngredients = value!;
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              child: Text("str_apply".tr()),
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: mealData.when(
        data: (meals) {
          if (searchQuery.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "str_search_for_meals".tr(),
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "str_filter_option_available_in_top_right_corner".tr(),
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final filteredMeals = meals.where((meal) {
            // 1. Qidiruv shartlarini tekshirish
            final titleMatches = searchByTitle &&
                (meal.title?.toLowerCase().contains(searchQuery) ?? false);
            final ingredientMatches = searchByIngredients &&
                (meal.ingredients?.toLowerCase().contains(searchQuery) ?? false);

            // Agar qidiruv bo'sh bo'lsa va hech qanday filter tanlanmagan bo'lsa
            if (searchQuery.isEmpty && !filter.hasActiveFilters) {
              return true;
            }

            // Qidiruv shartlarini tekshirish
            final matchesSearch = searchQuery.isEmpty || titleMatches || ingredientMatches;

            // 2. Filter shartlarini tekshirish
            final activeFilters = filter.activeFilters; // Faqat tanlangan filtrlarni olish

            if (activeFilters.isEmpty) return matchesSearch;

            // Agar faqat bitta filter tanlangan bo'lsa


            // Agar bir nechta filter tanlangan bo'lsa (AND sharti)
            bool matchesAllFilters = true;

            if (filter.isVegetarian) matchesAllFilters = matchesAllFilters && (meal.isVegetarian ?? false);
            if (filter.isProtein) matchesAllFilters = matchesAllFilters && (meal.isProtein ?? false);
            if (filter.isKids) matchesAllFilters = matchesAllFilters && (meal.isKids ?? false);
            if (filter.isCalorie) matchesAllFilters = matchesAllFilters && (meal.isCalorie ?? false);
            if (filter.isDiabetes) matchesAllFilters = matchesAllFilters && (meal.isDiabetes ?? false);

            return matchesSearch && matchesAllFilters;
          }).toList();


          if (filteredMeals.isEmpty) {
            return Center(
              child: Text(
                "str_no_results_for".tr(args: [searchQuery]),
                style: TextStyle(fontSize: 25),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
            itemCount: filteredMeals.length,
            itemBuilder: (context, index) {
              return _mealItem(filteredMeals[index]);
            },
          );
        },
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _mealItem(Meal meal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MealDetailPage(meal: meal)),
          );
        },
        child: SizedBox(
          height: 250,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: meal.imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.broken_image),
                ),
              ),
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: Text(
                    meal.title!,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}