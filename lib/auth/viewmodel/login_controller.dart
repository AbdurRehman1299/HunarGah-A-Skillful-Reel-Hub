import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/database/firebase_service.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isObscurePassword = true.obs;
  var isLoading = false.obs;

  void togglePasswordVisiblity() {
    isObscurePassword.value = !isObscurePassword.value;
  }

  Future<void> loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter both email and password.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    String? errorMessage = await FirebaseService().loginUser(email, password);

    isLoading.value = false;

    if (errorMessage == null) {
      int? step = await FirebaseService().getUserOnboardingSteps();

      if (step == 0 || step == null) {
        Get.offNamed('/onboarding');
      } else if (step == 1) {
        Get.snackbar(
          'Notice',
          'Please select your preferred language to continue.',
          backgroundColor: Colors.blueAccent,
          colorText: Colors.white,
        );
        Get.offNamed('/language');
      } else if (step == 2) {
        Get.snackbar(
          'Notice',
          'Please select your skills of interest to continue.',
          backgroundColor: Colors.blueAccent,
          colorText: Colors.white,
        );
        Get.offNamed('/skills');
      } else if (step == 3) {
        Get.snackbar(
          'Notice',
          'Please upload a profile picture to continue.',
          backgroundColor: Colors.blueAccent,
          colorText: Colors.white,
        );
        Get.offNamed('/profile');
      } else {
        Get.snackbar(
          'Success',
          'Login successful! Redirecting...',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offNamed('/dashboard');
      }
    } else {
      Get.snackbar(
        'Login Failed',
        errorMessage,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
