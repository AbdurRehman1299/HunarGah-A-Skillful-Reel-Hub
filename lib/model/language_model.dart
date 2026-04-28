import 'package:flutter/material.dart';

class LanguageOption {
  final String id;
  final String nativeName;
  final String englishName;
  final IconData icon;
  final IconData watermarkIcon;

  LanguageOption({
    required this.id,
    required this.nativeName,
    required this.englishName,
    required this.icon,
    required this.watermarkIcon,
  });
}
