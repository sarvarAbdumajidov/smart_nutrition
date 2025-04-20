import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_nutrition/models/meal_model.dart';
import 'package:smart_nutrition/service/log_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../pages/sign_in_page.dart';

class AuthService extends StateNotifier<User?> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance.ref();
  final folder_meal = "meal_images";

  AuthService() : super(null) {
    _auth.authStateChanges().listen((User? user) {
      state = user;
    });
  }

  // IS LOGGED IN
  bool isLoggedIn() => state != null;

  // UID
  String? currentUserId() => state?.uid;

  // SIGN IN
  Future<User?> signInUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      state = _auth.currentUser;
      return state;
    } catch (e) {
      LogService.e('This user does not exist!!  ');
      return null;
    }
  }

  // CHECK EMAIL
  Future<bool> checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    return user?.emailVerified ?? false;
  }

  // SIGN UP
  Future<User?> signUpUser(String email, String password) async {
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = authResult.user;

      if (user != null) {
        // Firebase'da users collectionga qo'shamiz
        await _firestore.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "email": user.email,
          "role": "user", // Default role
        });

        // Emailga verification link yuborish
        await user.sendEmailVerification();

        // Email yuborilganini tasdiqlovchi log qo'shamiz
        print("Verification email sent to: ${user.email}");

        return user;
      } else {
        return null;
      }
    } catch (e) {
      // Xatolikni logga yozamiz
      LogService.e("Sign Up failed: $e");
      return null;
    }
  }





  // UPDATE PASSWORD
  Future<String?> changePassword(String newPassword) async {
    try {
      await _auth.currentUser!.updatePassword(newPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      LogService.e(e.toString());
      return e.message;
    }
  }

  // RESET EMAIL
  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      LogService.e(e.toString());
      return e.message;
    }
  }

  // EMAIL VERIFICATION
  Future<String?> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        LogService.d("Email verification link yuborildi");
        return null;
      } else {
        return "Email already confirmed".tr();
      }
    } catch (e) {
      LogService.e("Email verificationda xatolik: $e");
      return "An error occurred during email verification.".tr();
    }
  }

  // GET ROLE
  Future<String?> getUserRole() async {
    if (state == null) return null;

    var doc = await _firestore.collection("users").doc(state!.uid).get();

    if (!doc.exists || doc.data() == null) return null;

    return doc.data()!["role"] as String?;
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    state = null;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

  // UPLOAD IMAGE (Optimized)
  Future<String?> uploadMealImage(File _image) async {
    try {
      String? uid = currentUserId();
      String imgName = "${uid}_${DateTime.now().millisecondsSinceEpoch}";
      var firebaseStorageRef = _storage.child(folder_meal).child(imgName);

      UploadTask uploadTask = firebaseStorageRef.putFile(_image);
      TaskSnapshot taskSnapshot = await uploadTask;

      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      LogService.d('DOWNLOAD URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      LogService.e("Rasm yuklashda xatolik: $e");
      return null;
    }
  }

  // STORE MEAL
  Future<void> addMeal(Meal meal) async {
    try {
      await _firestore.collection('meals').doc(meal.id).set(meal.toMap());
    } catch (e) {
      LogService.e("Firestore xatosi: $e");
    }
  }

  // FETCH MEAL
  Future<List<Meal>> fetchMeals() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('meals').get();
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;

        return Meal(
          id: doc.id,
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
      }).toList();
    } catch (e) {
      LogService.e("Xatolik: $e");
      return [];
    }
  }

  // DELETE MEAL
  Future<void> deleteMeal(String mealId, String imageUrl) async {
    try {
      // Firestore-dan taomni o‘chirish
      await _firestore.collection('meals').doc(mealId).delete();

      // Agar rasm URL berilgan bo‘lsa, uni ham o‘chiramiz
      if (imageUrl.isNotEmpty) {
        var imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
        await imageRef.delete();
      }

      LogService.d("Meal o‘chirildi: $mealId");
    } catch (e) {
      LogService.e("Mealni o‘chirishda xatolik: $e");
    }
  }

  // UPDATE MEAL
  Future<void> updateMeal(Meal meal) async {
    try {
      await _firestore.collection('meals').doc(meal.id).update(meal.toMap());
      LogService.d("Meal yangilandi: ${meal.id}");
    } catch (e) {
      LogService.e("Mealni yangilashda xatolik: $e");
    }
  }

}


// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:smart_nutrition/models/meal_model.dart';
// import 'package:smart_nutrition/service/log_service.dart';
// import 'package:firebase_storage/firebase_storage.dart';
//
// class AuthService extends StateNotifier<User?> {
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;
//   final _storage = FirebaseStorage.instance.ref();
//   final folder_meal = "meal_images";
//
//   AuthService() : super(null) {
//     _auth.authStateChanges().listen((User? user) {
//       state = user;
//     });
//   }
//
//   // IS LOGGED IN
//   bool isLoggedIn() => state != null;
//
//   // UID
//   String? currentUserId() => state?.uid;
//
//   // SIGN IN
//   Future<User?> signInUser(String email, String password) async {
//     try {
//       await _auth.signInWithEmailAndPassword(email: email, password: password);
//       state = _auth.currentUser;
//       return state;
//     } catch (e) {
//       LogService.e('bunday foydalanuvchi mavjud emas!!');
//     }
//   }
//
//   // SIGN UP
//   Future<User?> signUpUser(String email, String password) async {
//     try {
//       var authResult = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       User? user = authResult.user;
//
//       if (user != null) {
//         await _firestore.collection("users").doc(user.uid).set({
//           "uid": user.uid,
//           "email": user.email,
//           "role": "user", // Default user sifatida saqlanadi
//         });
//       }
//       state = user;
//       return user;
//     } catch (e) {
//       LogService.e('Sign Up da xatolik');
//     }
//   }
//
//   // GET ROLE
//   Future<String?> getUserRole() async {
//     if (state == null) return null;
//
//     var doc = await _firestore.collection("users").doc(state!.uid).get();
//
//     if (!doc.exists || doc.data() == null) return null;
//
//     return doc.data()!["role"] as String?;
//   }
//
//   // SIGN OUT
//   Future<void> signOut() async {
//     await _auth.signOut();
//     state = null;
//   }
//
//   // UPLOAD IMAGE
//   Future<String?> uploadMealImage(File _image) async {
//     String? uid = currentUserId();
//     String img_name = "${uid}_${DateTime.now()}";
//     var firebaseStorageRef = _storage.child(folder_meal).child(img_name);
//     var uploadTask = firebaseStorageRef.putFile(_image);
//     TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
//     final String downloadUrl = await firebaseStorageRef.getDownloadURL();
//     LogService.d('DOWNLOAD URL: $downloadUrl');
//     return downloadUrl;
//   }
//
//   // STORE MEAL
//   Future<void> addMeal(Meal meal) async {
//     try {
//       await _firestore.collection('meals').doc(meal.id).set(meal.toMap());
//     } catch (e) {
//       print("Firestore xatosi: $e");
//     }
//   }
//
//   // FETCH MEAL
//   Future<List<Meal>> fetchMeals() async {
//     try {
//       QuerySnapshot snapshot = await _firestore.collection('meals').get();
//       return snapshot.docs.map((doc) {
//         var data = doc.data() as Map<String, dynamic>;
//
//         return Meal(
//           id: doc.id,
//           title: data['title'] ?? '',
//           imageUrl: data['imageUrl'] ?? '',
//           duration: data['duration'] ?? 0,
//           ingredients: data['ingredients'] ?? '',
//           steps: data['steps'] ?? '',
//           category: (data['category'] as List<dynamic>?)?.cast<String>() ?? [],
//           isVegetarian: data['isVegetarian'] ?? false,
//           isDiabetes: data['isDiabetes'] ?? false,
//           isCalorie: data['isCalorie'] ?? false,
//           isKids: data['isKids'] ?? false,
//           isProtein: data['isProtein'] ?? false,
//         );
//       }).toList();
//     } catch (e) {
//       print("Xatolik: $e");
//       return [];
//     }
//   }
//
//   // Future<List<Meal>> fetchMeals() async {
//   //   try {
//   //     QuerySnapshot snapshot = await _firestore.collection('meals').get();
//   //     return snapshot.docs.map((doc) {
//   //       return Meal(
//   //         id: doc.id,
//   //         title: doc['title'],
//   //         imageUrl: doc['imageUrl'],
//   //         duration: doc['duration'],
//   //         ingredients: doc['ingredients'],
//   //         steps: doc['steps'],
//   //         category: doc['category'],
//   //         isVegetarian: doc['isVegetarian'],
//   //         isDiabetes: doc['isDiabetes'],
//   //         isCalorie: doc['isCalorie'],
//   //         isKids: doc['isKids'],
//   //         isProtein: doc['isProtein'],
//   //       );
//   //     }).toList();
//   //   } catch (e) {
//   //     print("Xatolik: $e");
//   //     return [];
//   //   }
//   // }
//
//
//
// }
