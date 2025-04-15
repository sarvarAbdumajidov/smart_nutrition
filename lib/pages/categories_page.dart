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
                    'Cooking Up!',
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
                      'Meals',
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
                      'Search meals',
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
                      'Filters',
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
                      'Settings',
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
                    title: Text('Do you want to log out?'),
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
                            child: Text('No', style: TextStyle(fontSize: 20)),
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
                            child: Text('Yes', style: TextStyle(fontSize: 20)),
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
        title: Text('Categories'),
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
                categoriesList[index],
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
