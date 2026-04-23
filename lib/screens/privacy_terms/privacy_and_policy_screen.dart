import 'package:flutter/material.dart';
import 'package:hunargah/components/app_bar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color themeColor = const Color(0xFF00897B);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Privacy Policy',
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
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
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Your privacy is important to us. This Privacy Policy explains how we collect, use, and protect your personal information when you use our skill-learning platform.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Standard Privacy Sections
                  _buildSection(
                    '1. Information We Collect',
                    'We collect information you provide directly to us, such as when you create an account, update your profile, enroll in a course, or communicate with us. This may include your name, email address, phone number, and learning preferences.',
                  ),
                  _buildSection(
                    '2. How We Use Your Information',
                    'We use the information we collect to provide, maintain, and improve our services. This includes personalizing your course recommendations, tracking your learning progress, and processing payments for premium content.',
                  ),
                  _buildSection(
                    '3. Information Sharing',
                    'We do not share your personal information with third parties except as described in this policy. We may share information with Ustads (instructors) strictly for course administration and completion tracking.',
                  ),
                  _buildSection(
                    '4. Data Security',
                    'We implement reasonable security measures to protect your personal information from unauthorized access, alteration, or disclosure. However, no internet transmission is completely secure.',
                  ),
                  _buildSection(
                    '5. Your Rights',
                    'You have the right to access, correct, or delete your personal information. You can manage your data preferences through your account settings or by contacting our support team.',
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
                            const Text(
                              'Have Questions?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'If you have any questions about this Privacy Policy, please contact our support team at privacy@hunargah.app',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
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

  // 🛠️ Helper method for consistent text sections
  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
