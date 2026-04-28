import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/model/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hunargah/database/firebase_service.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final cityController = TextEditingController();

  var isLoading = true.obs;
  var isSaving = false.obs;
  var newImage = Rxn<File>();
  var currentUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  @override
  void onClose() {
    nameController.dispose();
    cityController.dispose();
    super.onClose();
  }

  Future<void> loadUserData() async {
    isLoading.value = true;

    try {
      final Map<String, dynamic>? userData = await FirebaseService()
          .getUserData();

      if (userData != null) {
        currentUser.value = UserModel.fromMap(userData, 'current_user_id');
        nameController.text = currentUser.value?.username ?? '';
        cityController.text = currentUser.value?.city ?? '';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load profile: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Pick Image
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        newImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> saveUserData() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Name cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isSaving.value = true;

      String? finalBase64Image = currentUser.value?.profileImageUrl;
      if (newImage.value != null) {
        debugPrint("Encoding new image...");
        List<int> imageBytes = await newImage.value!.readAsBytes();
        finalBase64Image = base64Encode(imageBytes);
      }

      final String? error = await FirebaseService().updateProfileDetails(
        nameController.text.trim(),
        cityController.text.trim(),
        profileImageUrl: finalBase64Image,
      );

      if (error == null) {
        if (currentUser.value != null) {
          currentUser.value = UserModel(
            uid: currentUser.value!.uid,
            username: nameController.text.trim(),
            city: cityController.text.trim(),
            email: currentUser.value!.email,
            bio: currentUser.value!.bio,
            profileImageUrl: finalBase64Image,
          );
        }

        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.teal.withValues(alpha: 0.7),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar('Error', error, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
      debugPrint("Save process finished.");
    }
  }

  ImageProvider? getProfileImage() {
    if (newImage.value != null) {
      return FileImage(newImage.value!);
    } else if (currentUser.value?.profileImageUrl != null &&
        currentUser.value!.profileImageUrl!.isNotEmpty) {
      try {
        return MemoryImage(base64Decode(currentUser.value!.profileImageUrl!));
      } catch (e) {
        return null;
      }
    }
    return const NetworkImage(
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=150&q=80',
    );
  }

  void setCity(String city) {
    cityController.text = city;
  }
}
