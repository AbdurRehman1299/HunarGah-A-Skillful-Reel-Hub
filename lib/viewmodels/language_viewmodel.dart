import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/database/firebase_service.dart';
import 'package:hunargah/model/language_model.dart';

class LanguageController extends GetxController {
  var selectedLanguageId = RxnString();
  var isLoading = false.obs;

  // Language Data
  final List<LanguageOption> languages = [
    LanguageOption(
      id: 'urdu',
      nativeName: 'اردو',
      englishName: 'URDU',
      icon: Icons.translate,
      watermarkIcon: Icons.sort_by_alpha,
    ),
    LanguageOption(
      id: 'english',
      nativeName: 'English',
      englishName: 'ENGLISH',
      icon: Icons.language,
      watermarkIcon: Icons.language,
    ),
    LanguageOption(
      id: 'punjabi',
      nativeName: 'पंजाबी',
      englishName: 'PUNJABI',
      icon: Icons.people_outline,
      watermarkIcon: Icons.people_outline,
    ),
  ];

  void selectLanguage(String id) {
    HapticFeedback.lightImpact();
    selectedLanguageId.value = id;
  }

  Future<void> saveLanguage() async {
    if (selectedLanguageId.value == null) return;

    isLoading.value = true;
    String? errorMessage = await FirebaseService().saveUserLanguage(
      selectedLanguageId.value!,
      2,
    );
    isLoading.value = false;

    if (errorMessage == null) {
      Get.offNamed('/skills');
    } else {
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
