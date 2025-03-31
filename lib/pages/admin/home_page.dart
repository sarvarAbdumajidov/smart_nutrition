import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smart_nutrition/pages/admin/add_meal_page.dart';
import 'package:smart_nutrition/pages/sign_in_page.dart';
import '../../models/meal_model.dart';
import '../../provider/providers.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);
    final auth = ref.read(authProvider.notifier);
    final mealData = ref.watch(mealProvider);
    final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

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
            autoFocus: false,
            leading: Icon(Icons.search, size: 20),
            elevation: MaterialStateProperty.all(0),
            onChanged: (value) {
              ref.read(searchQueryProvider.notifier).state = value;
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () async {
                String result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddMealPage()),
                );
                if (result == 'success') {
                  ref.read(loadingProvider.notifier).startLoading();
                  ref.refresh(mealProvider);
                  ref.read(loadingProvider.notifier).stopLoading();
                }
              },
              icon: Icon(Icons.add),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () async {
            await auth.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignInPage()),
            );
          },
          icon: Icon(Icons.logout_outlined),
        ),
      ),
      body: mealData.when(
        data: (meals) {
          final filteredMeals =
          meals.where((meal) => meal.title!.toLowerCase().contains(searchQuery)).toList();

          if (filteredMeals.isEmpty) {
            return Center(child: Text('No food available'));
          }

          return ListView.builder(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
            itemCount: filteredMeals.length,
            cacheExtent: 300, // Faqat ko'rinadigan qismi yuklanadi
            itemBuilder: (context, index) {
              return _mealItem(filteredMeals[index],ref,isLoading);
            },
          );
        },
        error: (error, stackTrace) => Center(child: Text('Xatolik: $error')),
        loading: () => Center(child: LinearProgressIndicator()),
      ),
    );
  }

  Widget _mealItem(Meal meal,WidgetRef ref, final isLoading) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SizedBox(
            width: double.infinity,
            height: 250,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: meal.imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250,
                    memCacheHeight: 250, // Faqat kerakli hajmda yuklash
                    memCacheWidth: 400,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.broken_image, size: 50, color: Colors.red),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Text(
                    meal.title!,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                Align(

                  alignment: Alignment.topRight,
                  child: Container(
                   margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    width: 97,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(onPressed: (){

                        }, icon: Icon(CupertinoIcons.pen,color: Colors.yellow)),
                        IconButton(onPressed: ()async{
                          ref.read(loadingProvider.notifier).startLoading();
                        await  ref.read(authProvider.notifier).deleteMeal(meal.id!, meal.imageUrl!);
                          ref.refresh(mealProvider);
                          ref.read(loadingProvider.notifier).stopLoading();
                        }, icon: Icon(CupertinoIcons.delete,color: Colors.red)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        isLoading ? Center(child: CircularProgressIndicator(),): SizedBox.shrink(),
      ],
    );
  }
}
