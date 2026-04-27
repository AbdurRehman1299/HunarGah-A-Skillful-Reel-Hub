import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/database/firebase_service.dart';
import 'package:hunargah/screens/security/secure_storage.dart';

class SettingsController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var userData = <String, dynamic>{}.obs;
  var isLoading = true.obs;
  var isDark = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDark.value = Get.isDarkMode;
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await FirebaseService().getUserProfile(user.uid);
        if (doc.exists) {
          userData.value = doc.data() as Map<String, dynamic>;
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load profile",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleTheme(bool value) async {
    isDark.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    await SecureStorage.saveTheme(value ? 'dark' : 'light');
  }

  Future<void> signOut() async {
    await FirebaseService().signOutUser();
    Get.offAllNamed('/login');
    Get.snackbar(
      "Success",
      "Logged out successfully.",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
