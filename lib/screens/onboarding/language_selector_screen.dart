import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hunargah/components/app_bar.dart';
import 'package:hunargah/database/firebase_service.dart';

class LanguageSelectorScreen extends StatefulWidget {
  const LanguageSelectorScreen({super.key});

  @override
  State<LanguageSelectorScreen> createState() => _LanguageSelectorScreenState();
}

class _LanguageSelectorScreenState extends State<LanguageSelectorScreen> {
  // Keeps track of which language the user tapped
  String? selectedLanguage;

  Future<void> _saveLanguagePreference() async {
    if (selectedLanguage == null) return;

    String? errorMessage = await FirebaseService().saveUserLanguage(
      selectedLanguage!,
      2,
    );

    if (!mounted) return;

    if (errorMessage == null) {
      Navigator.of(context).pushReplacementNamed('/skills');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Choose Language'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // -- Logo Section --
              logoSection(),

              const SizedBox(height: 24),

              // -- Header Section --
              headerSection(),

              const SizedBox(height: 12),

              languageDescriptionSection(),

              const SizedBox(height: 32),

              // -- Language Selection Cards --
              _buildLanguageCard(
                id: 'urdu',
                nativeName: 'اردو',
                englishName: 'URDU',
                icon: Icons.translate,
                watermarkIcon: Icons.sort_by_alpha,
                themeColor: themeColor,
              ),

              const SizedBox(height: 16),

              _buildLanguageCard(
                id: 'english',
                nativeName: 'English',
                englishName: 'ENGLISH',
                icon: Icons.language,
                watermarkIcon: Icons.language,
                themeColor: themeColor,
              ),

              const SizedBox(height: 16),

              _buildLanguageCard(
                id: 'punjabi',
                nativeName: 'पंजाबी',
                englishName: 'PUNJABI',
                icon: Icons.people_outline,
                watermarkIcon: Icons.people_outline,
                themeColor: themeColor,
              ),

              const Spacer(),

              // -- Info Banner --
              infoBanner(),

              const SizedBox(height: 24),

              // -- Continue Button --
              continueButton(context, themeColor),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox continueButton(BuildContext context, Color themeColor) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: selectedLanguage != null ? _saveLanguagePreference : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedLanguage == null
              ? Colors.grey[300]
              : themeColor,
          disabledBackgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Continue',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: selectedLanguage == null
                    ? Colors.grey[500]
                    : Colors.white,
              ),
            ),

            const SizedBox(width: 6),

            Icon(
              Icons.arrow_forward,
              color: selectedLanguage == null ? Colors.grey[500] : Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Container infoBanner() {
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
                color: Colors.grey[600],
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Text languageDescriptionSection() {
    return const Text(
      'Please select your preferred language to\nstart your skill journey.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.5),
    );
  }

  Text headerSection() {
    return const Text(
      'Welcome to HunarGah',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
      ),
    );
  }

  Image logoSection() {
    return Image.asset(
      'assets/images/hunargah-logo.png',
      width: 60,
      height: 60,
    );
  }

  // Reusable Component: Language Selection Card
  Widget _buildLanguageCard({
    required String id,
    required String nativeName,
    required String englishName,
    required IconData icon,
    required IconData watermarkIcon,
    required Color themeColor,
  }) {
    // Check if the specific card is the one currently selected
    bool isSelected = selectedLanguage == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          HapticFeedback.lightImpact();
          selectedLanguage = id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? themeColor.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? themeColor : Colors.grey.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        // Stack allows to place watermark behind the text
        child: Stack(
          children: [
            // -- Watermark icon --
            languageWatermark(watermarkIcon),

            // -- Foreground Content --
            languageContent(
              icon,
              nativeName,
              englishName,
              isSelected,
              themeColor,
            ),
          ],
        ),
      ),
    );
  }

  Padding languageContent(
    IconData icon,
    String nativeName,
    String englishName,
    bool isSelected,
    Color themeColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // Small left icon with grey background
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.grey[600], size: 24),
          ),

          const SizedBox(width: 16),

          // -- Language Text --
          languageText(nativeName, englishName),

          const Spacer(),

          if (isSelected) Icon(Icons.check_circle, color: themeColor),
        ],
      ),
    );
  }

  Column languageText(String nativeName, String englishName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          nativeName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          englishName,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey[500],
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Positioned languageWatermark(IconData watermarkIcon) {
    return Positioned(
      right: -20,
      bottom: -20,
      child: Icon(
        watermarkIcon,
        size: 100,
        color: Colors.grey.withValues(alpha: 0.1),
      ),
    );
  }
}
