import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/components/app_bar.dart';
import 'package:hunargah/screens/model/skill_category_model.dart';
import 'package:hunargah/screens/viewmodels/skill_category_viewmodel.dart';

class SkillsInterestedScreen extends StatelessWidget {
  const SkillsInterestedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SkillsInterestedController());

    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      appBar: CustomAppBar(title: 'Personalized HunarGah'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerSection(themeColor, isDark),
              const SizedBox(height: 8),

              Text(
                'Select at least 3 categories to help us\ntailor your learning experience.',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // -- Skills Grid --
              Obx(
                () => Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: controller.skills.map((skill) {
                    final chipWidth =
                        (MediaQuery.of(context).size.width - 48 - 12) / 2;
                    return SizedBox(
                      width: chipWidth,
                      child: _buildSkillChip(
                        skill,
                        themeColor,
                        controller,
                        isDark,
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 32),
              dailyInspirationBanner(themeColor, isDark),
              const SizedBox(height: 24),

              // -- Start Learning Button --
              Obx(() => startLearningButton(controller, themeColor, isDark)),

              const SizedBox(height: 16),
              footerText(isDark),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  RichText headerSection(Color themeColor, bool isDark) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: isDark ? Colors.white : Colors.black87,
          fontFamily: 'Roboto',
        ),
        children: [
          const TextSpan(text: 'What skills are you '),
          TextSpan(
            text: 'interested',
            style: TextStyle(color: themeColor, fontStyle: FontStyle.italic),
          ),
          const TextSpan(text: ' in?'),
        ],
      ),
    );
  }

  Container dailyInspirationBanner(Color themeColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeColor.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: themeColor.withValues(alpha: 0.5)),
            ),
            child: Icon(Icons.lightbulb_outline, color: themeColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Inspiration',
                  style: TextStyle(
                    color: themeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "We'll notify you when your favorite\nUstads post new lessons.",
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Center footerText(bool isDark) {
    return Center(
      child: Text(
        'You can change your interest anytime in Settings.',
        style: TextStyle(
          color: isDark ? Colors.grey[500] : Colors.grey[600],
          fontSize: 10,
        ),
      ),
    );
  }

  Widget startLearningButton(
    SkillsInterestedController controller,
    Color themeColor,
    bool isDark,
  ) {
    final bool canProceed =
        controller.hasEnoughSkills && !controller.isSaving.value;
    final Color disabledBg = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final Color disabledText = isDark ? Colors.grey[500]! : Colors.grey[500]!;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: canProceed ? controller.saveSelectedSkills : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: controller.hasEnoughSkills ? themeColor : disabledBg,
          disabledBackgroundColor: disabledBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
          elevation: 0,
        ),
        child: controller.isSaving.value
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Start Learning',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: controller.hasEnoughSkills
                          ? Colors.white
                          : disabledText,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    color: controller.hasEnoughSkills
                        ? Colors.white
                        : disabledText,
                    size: 18,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSkillChip(
    SkillCategory skill,
    Color themeColor,
    SkillsInterestedController controller,
    bool isDark,
  ) {
    final bool isSelected = controller.selectedSkills.contains(skill.name);

    return GestureDetector(
      onTap: () => controller.toggleSkill(skill.name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? themeColor
              : (isDark ? Colors.grey[800] : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? themeColor
                : (isDark ? Colors.grey[700]! : Colors.grey[200]!),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                skill.icon,
                size: 18,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.tealAccent[400] : Colors.teal[600]),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                skill.name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.grey[300] : Colors.grey[700]),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              const Icon(Icons.check_circle, color: Colors.white, size: 16),
            ],
          ],
        ),
      ),
    );
  }
}
