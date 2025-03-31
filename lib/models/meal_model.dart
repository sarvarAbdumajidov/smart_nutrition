class Meal {
  final String? id;
  final String? title;
  final String? imageUrl;
  final int? duration;
  final String? ingredients;
  final String? steps;
  final List<String>? category;
  final bool? isVegetarian;
  final bool? isDiabetes;
  final bool? isCalorie;
  final bool? isKids;
  final bool? isProtein;

  const Meal({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.duration,
    required this.ingredients,
    required this.steps,
    required this.category,
    required this.isVegetarian,
    required this.isDiabetes,
    required this.isCalorie,
    required this.isKids,
    required this.isProtein,
  });

  factory Meal.fromMap(Map<String, dynamic> data, String docId) {
    return Meal(
      id: docId,
      title: data['title'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      duration: data['duration'] ?? 0,
      ingredients: data['ingredients'] ?? '',
      steps: data['steps'] ?? '',
      category: (data['category'] as List<dynamic>?)?.cast<String>() ?? [],
      isVegetarian: data['isVegetarian'] ?? false,
      isDiabetes: data['isDiabetes'] ?? false,
      isCalorie: data['isCalorie'] ?? false,
      isKids: data['isKids'] ?? false,
      isProtein: data['isProtein'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'duration': duration,
      'ingredients': ingredients,
      'steps': steps,
      'category': category,
      'isVegetarian': isVegetarian,
      'isDiabetes': isDiabetes,
      'isCalorie': isCalorie,
      'isKids': isKids,
      'isProtein': isProtein,
    };
  }
}



// class Meal {
//   final String id;
//   final String title;
//   final String imageUrl;
//   final int duration;
//   final String ingredients;
//   final String steps;
//   final List<String> category;
//   final bool isVegetarian;
//   final bool isDiabetes;
//   final bool isCalorie;
//   final bool isKids;
//   final bool isProtein;
//
//   const Meal({
//     required this.id,
//     required this.title,
//     required this.imageUrl,
//     required this.duration,
//     required this.ingredients,
//     required this.steps,
//     required this.category,
//     required this.isVegetarian,
//     required this.isDiabetes,
//     required this.isCalorie,
//     required this.isKids,
//     required this.isProtein,
//   });
//
//   factory Meal.fromMap(Map<String, dynamic> data, String docId) {
//     return Meal(
//       id: docId,
//       title: data['title'],
//       imageUrl: data['imageUrl'],
//       duration: data['duration'],
//       ingredients: data['ingredients'],
//       steps: data['steps'],
//       category: data['category'],
//       isVegetarian: data['isVegetarian'],
//       isDiabetes: data['isDiabetes'],
//       isCalorie: data['isCalorie'],
//       isKids: data['isKids'],
//       isProtein: data['isProtein'],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'title': title,
//       'imageUrl': imageUrl,
//       'duration': duration,
//       'ingredients': ingredients,
//       'steps': steps,
//       'category':category,
//       'isVegetarian': isVegetarian,
//       'isDiabetes': isDiabetes,
//       'isCalorie': isCalorie,
//       'isKids': isKids,
//       'isProtein': isProtein,
//     };
//   }
// }
