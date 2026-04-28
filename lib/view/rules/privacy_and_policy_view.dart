import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/view/components/app_bar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color themeColor = const Color(0xFF00897B);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      appBar: CustomAppBar(
        title: 'Privacy Policy',
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : Colors.black,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // --- Scrollable privacy content ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Effective Date: April 6, 2026',
                    style: TextStyle(
                      color: isDark ? Colors.grey[200] : Colors.grey[500],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your personal information when you use our skill-learning platform.',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Standard Privacy Sections
                  _buildSection(
                    '1. Information We Collect',
                    'We collect information you provide directly to us, such as when you create an account, update your profile, enroll in a course, or communicate with us. This may include your name, email address, phone number, and learning preferences.',
                    isDark,
                  ),
                  _buildSection(
                    '2. How We Use Your Information',
                    'We use the information we collect to provide, maintain, and improve our services. This includes personalizing your course recommendations, tracking your learning progress, and processing payments for premium content.',
                    isDark,
                  ),
                  _buildSection(
                    '3. Information Sharing',
                    'We do not share your personal information with third parties except as described in this policy. We may share information with Ustads (instructors) strictly for course administration and completion tracking.',
                    isDark,
                  ),
                  _buildSection(
                    '4. Data Security',
                    'We implement reasonable security measures to protect your personal information from unauthorized access, alteration, or disclosure. However, no internet transmission is completely secure.',
                    isDark,
                  ),
                  _buildSection(
                    '5. Your Rights',
                    'You have the right to access, correct, or delete your personal information. You can manage your data preferences through your account settings or by contacting our support team.',
                    isDark,
                  ),
                  const SizedBox(height: 16),

                  // Contact Support Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: themeColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.mail_outline,
                              color: themeColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Have Questions?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'If you have any questions about this Privacy Policy, please contact our support team at privacy@hunargah.app',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable Widget: Policy Sections
  Widget _buildSection(String title, String content, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey[300] : Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
