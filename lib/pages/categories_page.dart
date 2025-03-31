import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_nutrition/pages/meals_page.dart';
import 'package:smart_nutrition/pages/sign_in_page.dart';
import 'package:smart_nutrition/provider/providers.dart';

class CategoriesPage extends ConsumerWidget {
  CategoriesPage({super.key});

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
  List<Color> colors = [
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
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authProvider.notifier);
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        actions: [IconButton(onPressed: ()async{
          await auth.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
          );
        }, icon: Icon(Icons.logout)),SizedBox(width: 10)],
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => MealsPage(categoryName: categoriesList[index])));
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
              child: Text(categoriesList[index],textAlign: TextAlign.center,style: TextStyle(fontSize: 17),),
            ),
          );
        },
      ),
    );
  }
}
