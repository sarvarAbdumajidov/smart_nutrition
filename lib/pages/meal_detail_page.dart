import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_nutrition/models/meal_model.dart';

class MealDetailPage extends StatelessWidget {
  final Meal meal;

  const MealDetailPage({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(meal.title!)),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.width / 1.5,
              child: Image.network(
                meal.imageUrl!,
                width: double.infinity,
                height: MediaQuery.of(context).size.width / 1.5,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "str_ingredients".tr(),
              style: TextStyle(fontSize: 23, color: Color(0xFFEE9624)),
            ),
            SizedBox(height: 10),
            Text(
              meal.ingredients!.tr(),
              style: TextStyle(color: Colors.white, fontSize: 17, height: 1.5),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              "str_steps".tr(),
              style: TextStyle(fontSize: 23, color: Color(0xFFEE9624)),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                meal.steps!,
                style: TextStyle(color: Colors.white, fontSize: 17, height: 2),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
