import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smart_nutrition/pages/admin/add_meal_page.dart';
import 'package:smart_nutrition/pages/sign_in_page.dart';
import '../../models/meal_model.dart';
import '../../provider/providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}
class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(loadingProvider.notifier).startLoading();
      ref.refresh(mealProvider); // refreshni keyinroq chaqirish
      ref.read(loadingProvider.notifier).stopLoading();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                String? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMealPage(isEditing: false),
                  ),
                );


                  ref.read(loadingProvider.notifier).startLoading();
                  ref.refresh(mealProvider);
                  ref.read(loadingProvider.notifier).stopLoading();

              },
              icon: Icon(Icons.add),
            ),


          ),
        ],
        leading: IconButton(
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
                            ref.read(searchQueryProvider.notifier).state = "";
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()));
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
      ),
      body: RefreshIndicator(
        child: mealData.when(
          data: (meals) {
            final filteredMeals = meals.where(
                    (meal) =>
                meal.title!.toLowerCase().contains(searchQuery) || // nom bo'yicha qidirish
                    meal.title!.toLowerCase().contains(searchQuery) || // tavsif bo'yicha qidirish
                    meal.ingredients!.toLowerCase().contains(searchQuery), // ingredients bo'yicha qidirish

            ).toList();



            if (filteredMeals.isEmpty) {
              return Center(child: Text("str_no_food_available".tr()));
            }

            return ListView.builder(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 40,
              ),
              itemCount: filteredMeals.length,
              cacheExtent: 300, // Faqat ko'rinadigan qismi yuklanadi
              itemBuilder: (context, index) {
                return _mealItem(filteredMeals[index], ref, isLoading, context);
              },
            );
          },
          error: (error, stackTrace) => Center(child: Text('Error: $error'.tr())),
          loading: () => Center(child: LinearProgressIndicator()),
        ),
        onRefresh: () async {
          ref.read(loadingProvider.notifier).startLoading();
          ref.refresh(mealProvider);
          ref.read(loadingProvider.notifier).stopLoading();
        },
      ),
    );
  }

  Widget _mealItem(
    Meal meal,
    WidgetRef ref,
    final isLoading,
    BuildContext context,
  ) {
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
                    memCacheHeight: 250,
                    // Faqat kerakli hajmda yuklash
                    memCacheWidth: 400,
                    placeholder:
                        (context, url) =>
                            Center(child: CircularProgressIndicator()),
                    errorWidget:
                        (context, url, error) => Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.red,
                        ),
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
                        IconButton(
                          onPressed: () {
                            ref.read(searchQueryProvider.notifier).state = "";
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => AddMealPage(
                                      isEditing: true,
                                      meal: meal,
                                    ),
                              ),
                            );
                          },
                          icon: Icon(
                            CupertinoIcons.pen,
                            color: Colors.blueAccent,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {

                            ref.read(loadingProvider.notifier).startLoading();
                            await ref
                                .read(authProvider.notifier)
                                .deleteMeal(meal.id!, meal.imageUrl!);
                            ref.refresh(mealProvider);
                            ref.read(loadingProvider.notifier).stopLoading();
                          },
                          icon: Icon(CupertinoIcons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        isLoading
            ? Center(child: CircularProgressIndicator())
            : SizedBox.shrink(),
      ],
    );
  }
}
