import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_nutrition/pages/filter_page.dart';
import 'package:smart_nutrition/pages/meals_page.dart';
import 'package:smart_nutrition/pages/search_meals_page.dart';
import 'package:smart_nutrition/pages/settings_page.dart';
import 'package:smart_nutrition/pages/sign_in_page.dart';
import 'package:smart_nutrition/provider/providers.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {
  final List<String> categoriesList = [
    "str_national_dishes".tr(),
    "str_fast_food".tr(),
    "str_fruits".tr(),
    "str_international_dishes".tr(),
    "str_drinks".tr(),
    "str_bread_and_pastry_products".tr(),
    "str_salads".tr(),
    "str_sweets_and_desserts".tr(),
    "str_greens_and_vegetable_dishes".tr(),
    "str_for_athletes".tr(),
  ];

  final List<Color> colors = [
    Colors.purple,
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.lightBlue,
    Colors.green,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.pink,
    Colors.teal,
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authProvider.notifier);
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.fastfood,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 18),
                  Text(
                    "str_cooking_up".tr(),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.restaurant,
                      size: 26,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    title: Text(
                      "str_meals".tr(),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 24,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.search,
                      size: 26,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    title: Text(
                      "str_search_meals".tr(),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 24,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SearchMealsPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.filter_alt,
                      size: 26,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    title: Text(
                      "str_filters".tr(),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 24,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FilterPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      size: 26,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    title: Text(
                      "str_settings".tr(),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 24,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("str_do_you_want_to_log_out".tr()),
                    content: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(width: double.infinity, height: 1),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("str_no".tr(), style: TextStyle(fontSize: 20)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInPage(),
                                ),
                              );
                            },
                            child: Text("str_yes".tr(), style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.logout_outlined),
          ),
          SizedBox(width: 10),
        ],
        elevation: 0,
        centerTitle: true,
        title: Text("str_categories".tr()),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(24),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 1.5,
        ),
        itemCount: categoriesList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealsPage(categoryName: categoriesList[index]),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    colors[index].withOpacity(0.55),
                    colors[index].withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                categoriesList[index].tr(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
            ),
          );
        },
      ),
    );
  }
}
