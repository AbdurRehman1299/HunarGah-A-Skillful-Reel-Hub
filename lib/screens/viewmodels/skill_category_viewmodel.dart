import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/database/firebase_service.dart';
import 'package:hunargah/screens/model/skill_category_model.dart';

class SkillsInterestedController extends GetxController {
  var selectedSkills = <String>{}.obs;
  var isSaving = false.obs;

  // The list of skills
  final List<SkillCategory> skills = [
    SkillCategory('AC Repair', Icons.ac_unit),
    SkillCategory('Plumbing', Icons.water_drop_outlined),
    SkillCategory('Cooking', Icons.soup_kitchen_outlined),
    SkillCategory('Electrician', Icons.bolt),
    SkillCategory('Tailoring', Icons.cut_outlined),
    SkillCategory('Mobile Repair', Icons.phone_android),
    SkillCategory('Beauty Salon', Icons.auto_awesome),
    SkillCategory('Graphic Design', Icons.palette_outlined),
    SkillCategory('Baking', Icons.cake_outlined),
    SkillCategory('Welding', Icons.build_outlined),
    SkillCategory('Digital Marketing', Icons.lightbulb_outline),
    SkillCategory('Photography', Icons.camera_alt_outlined),
  ];

  bool get hasEnoughSkills => selectedSkills.length >= 3;

  void toggleSkill(String skillName) {
    if (selectedSkills.contains(skillName)) {
      selectedSkills.remove(skillName);
    } else {
      selectedSkills.add(skillName);
    }
  }

  Future<void> saveSelectedSkills() async {
    isSaving.value = true;

    String? errorMessage = await FirebaseService().saveUserSkills(
      selectedSkills.toList(),
      3,
    );

    isSaving.value = false;

    if (errorMessage == null) {
      Get.offNamed('/profile-picture');
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
