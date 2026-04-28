import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/database/firebase_service.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureController extends GetxController {
  var profileImage = Rxn<File>();
  var isUploading = false.obs;

  final ImagePicker _picker = ImagePicker();

  // Function to pick an image
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxHeight: 400,
        maxWidth: 400,
      );

      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
        if (Get.isBottomSheetOpen ?? false) Get.back();
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Could not pick image: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Save Image
  Future<void> saveProfilePicture() async {
    if (profileImage.value == null) return;

    isUploading.value = true;
    String? errorMessage = await FirebaseService().saveProfilePicture(
      profileImage.value!,
      4,
    );
    isUploading.value = false;

    if (errorMessage == null) {
      Get.offAllNamed('/dashboard');
    } else {
      Get.snackbar(
        "Upload Failed",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Skip
  Future<void> skipStep() async {
    await FirebaseService().updateOnboardingStep(4);
    Get.offAllNamed('/dashboard');
  }
}
