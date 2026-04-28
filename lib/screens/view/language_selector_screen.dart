import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/components/app_bar.dart';
import 'package:hunargah/screens/model/language_model.dart';
import 'package:hunargah/screens/viewmodels/language_viewmodel.dart';

class LanguageSelectorScreen extends StatelessWidget {
  const LanguageSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LanguageController());

    final themeColor = Theme.of(context).primaryColor;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      appBar: CustomAppBar(title: 'Choose Language'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              logoSection(),
              const SizedBox(height: 24),
              headerSection(isDark),
              const SizedBox(height: 12),
              languageDescriptionSection(isDark),
              const SizedBox(height: 32),

              Expanded(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.languages.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return Obx(
                      () => _buildLanguageCard(
                        option: controller.languages[index],
                        isSelected:
                            controller.selectedLanguageId.value ==
                            controller.languages[index].id,
                        themeColor: themeColor,
                        isDark: isDark,
                        onTap: () => controller.selectLanguage(
                          controller.languages[index].id,
                        ),
                      ),
                    );
                  },
                ),
              ),

              infoBanner(isDark),
              const SizedBox(height: 24),

              // Continue Button
              Obx(
                () => continueButton(
                  controller.selectedLanguageId.value != null,
                  controller.isLoading.value,
                  controller.saveLanguage,
                  themeColor,
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget logoSection() =>
      Image.asset('assets/images/hunargah-logo.png', width: 60, height: 60);

  Widget headerSection(bool isDark) => Text(
    'Welcome to HunarGah',
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w800,
      color: isDark ? Colors.white : Colors.black87,
    ),
  );

  Widget languageDescriptionSection(bool isDark) => Text(
    'Please select your preferred language to\nstart your skill journey.',
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 13,
      color: isDark ? Colors.white70 : Colors.black54,
      height: 1.5,
    ),
  );

  Widget _buildLanguageCard({
    required LanguageOption option,
    required bool isSelected,
    required Color themeColor,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 80,
        decoration: BoxDecoration(
          color: isSelected
              ? themeColor.withValues(alpha: 0.05)
              : (isDark ? Colors.grey[900] : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? themeColor : Colors.grey.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                option.watermarkIcon,
                size: 100,
                color: Colors.grey.withValues(alpha: 0.1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(option.icon, color: Colors.grey[600], size: 24),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        option.nativeName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        option.englishName,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[500],
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (isSelected) Icon(Icons.check_circle, color: themeColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.bolt, color: Colors.orange[300], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'You can always change your language\npreference later in the account settings.',
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget continueButton(
    bool isEnabled,
    bool isLoading,
    VoidCallback onPressed,
    Color themeColor,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? themeColor : Colors.grey[300],
          disabledBackgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isEnabled ? Colors.white : Colors.grey[500],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward,
                    color: isEnabled ? Colors.white : Colors.grey[500],
                    size: 18,
                  ),
                ],
              ),
      ),
    );
  }
}
