import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_nutrition/pages/meal_detail_page.dart';
import 'package:smart_nutrition/pages/sign_in_page.dart';
import '../models/meal_model.dart';
import '../provider/providers.dart';

class MealsPage extends ConsumerWidget {
   MealsPage({super.key,required this.categoryName});
  String? categoryName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider.notifier);
    final mealData = ref.watch(mealProvider);
    return Scaffold(
      appBar: AppBar(
      ),
      body: mealData.when(
        data: (meals) {
          if (meals.isEmpty) {
            return Center(child: Text('Hech qanday taom mavjud emas'));
          }
          return ListView.builder(
            itemCount: meals.length,
            itemBuilder: (context, index) {
              return _meal(context, meals[index]);
            },
          );
        },
        error: (error, stackTrace) => Center(child: Text('Xatolik: $error')),
        loading: () => Center(child: LinearProgressIndicator()),
      ),
    );
  }

  Widget _meal(BuildContext context, Meal meal) {
    return  !meal.category!.contains(categoryName) ? SizedBox.shrink() :
      Padding(
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
                            '${meal.duration} min',
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
