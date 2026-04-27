import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/database/firebase_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await Future.wait([
        Future.delayed(const Duration(seconds: 2)),
        Firebase.initializeApp().catchError((_) => Firebase.app()),
      ]);

      int? step = await FirebaseService().getUserOnboardingSteps();
      if (step == null) {
        Get.offNamed('/signup');
      } else if (step == 0) {
        Get.offNamed('/onboarding');
      } else if (step == 1) {
        Get.offNamed('/language');
      } else if (step == 2) {
        Get.offNamed('/skills');
      } else if (step == 3) {
        Get.offNamed('/profile-picture');
      } else {
        Get.offNamed('/dashboard');
      }
    } catch (e) {
      debugPrint('Splash Screen Error: $e');
      Get.snackbar(
        'Error',
        'Initializing app: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      Get.offNamed('/login');
    }
  }
}