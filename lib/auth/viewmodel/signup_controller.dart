import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/database/firebase_service.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isLoading = false.obs;
  var isObscurePassword = true.obs;
  var isObscureConfirmPassword = true.obs;

  void togglePassword() => isObscurePassword.value = !isObscurePassword.value;
  void toggleConfirmPassword() =>
      isObscureConfirmPassword.value = !isObscureConfirmPassword.value;

  Future<void> registerUser() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match!',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    String? errorMessage = await FirebaseService().registerUser(
      emailController.text.trim(),
      passwordController.text.trim(),
      nameController.text.trim(),
    );

    isLoading.value = false;

    if (errorMessage == null) {
      Get.snackbar(
        'Success',
        'Account created! Please log in.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offNamed('/login');
    } else {
      Get.snackbar(
        'Registration Failed',
        errorMessage,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
