import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/screens/security/secure_storage.dart';

class ThemeController extends GetxController {
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  ThemeController({required ThemeMode initialTheme}) {
    themeMode.value = initialTheme;
  }

  Future<void> toggleTheme() async {
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
      await SecureStorage.saveTheme('dark');
    } else {
      themeMode.value = ThemeMode.light;
      await SecureStorage.saveTheme('light');
    }
  }
}