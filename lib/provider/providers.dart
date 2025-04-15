import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../models/filter_model.dart';
import '../models/meal_model.dart';
import '../service/auth_service.dart';

extension SelectedCategoriesNotifierX on SelectedCategoriesNotifier {
  void setAll(List<String> newList) {
    state = newList;
  }
}


final searchQueryProvider = StateProvider<String>((ref) => "");
final selectedCategoriesProvider = StateNotifierProvider<SelectedCategoriesNotifier,List<String>>((ref) => SelectedCategoriesNotifier());
final loadingProvider = StateNotifierProvider<LoadingNotifier,bool>((ref) => LoadingNotifier());
final authProvider = StateNotifierProvider<AuthService, User?>((ref) {
  return AuthService();
});

final mealProvider = FutureProvider<List<Meal>>((ref) async {
  final authService = ref.watch(authProvider.notifier);
  return await authService.fetchMeals();
});

final titleControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
    );
final timeControllerProvider = StateProvider.autoDispose<TextEditingController>(
  (ref) => TextEditingController(),
);
final ingredientsControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
    );
final stepsControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
    );

final emailControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
    );
final passwordControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
    );
final confirmPasswordControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
    );
final imagePickerProvider = StateNotifierProvider<ImagePickerNotifier, File?>((
  ref,
) {
  return ImagePickerNotifier();
});

final filterProvider = StateNotifierProvider<FilterNotifier, FilterState>((
  ref,
) {
  return FilterNotifier();
});

// FILTER
class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(FilterState());

  void toggleVegetarian() =>
      state = state.copyWith(isVegetarian: !state.isVegetarian);

  void toggleDiabetes() =>
      state = state.copyWith(isDiabetes: !state.isDiabetes);

  void toggleCalorie() => state = state.copyWith(isCalorie: !state.isCalorie);

  void toggleKids() => state = state.copyWith(isKids: !state.isKids);

  void toggleProtein() => state = state.copyWith(isProtein: !state.isProtein);

  void setAll({
    required bool isVegetarian,
    required bool isDiabetes,
    required bool isCalorie,
    required bool isKids,
    required bool isProtein,
  }) {
    state = FilterState(
      isVegetarian: isVegetarian,
      isDiabetes: isDiabetes,
      isCalorie: isCalorie,
      isKids: isKids,
      isProtein: isProtein,
    );
  }
  void resetFilters() {
    state = FilterState(); // Yangi boshlang'ich holatga qaytarish
  }
}


//  IMAGE PICKER
class ImagePickerNotifier extends StateNotifier<File?> {
  ImagePickerNotifier() : super(null);

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      state = File(pickedFile.path);
    }
  }
  void clearImage() {
    state = null;
  }
}
// SELECTED CATEGORIES
class SelectedCategoriesNotifier extends StateNotifier<List<String>> {
  SelectedCategoriesNotifier() : super([]);

  void toggleCategory(String category) {
    if (state.contains(category)) {
      state = state.where((c) => c != category).toList();
    } else {
      state = [...state, category];
    }
  }

  void clearCategory() {
    state = [];
  }
  List<String> get selectedList => state;
}

// Progress Indicator
class LoadingNotifier extends StateNotifier<bool>{
  LoadingNotifier():super(false);
  void startLoading() => state = true;
  void stopLoading() => state = false;
}