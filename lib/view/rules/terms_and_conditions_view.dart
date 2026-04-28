import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/view/components/app_bar.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      appBar: CustomAppBar(
        title: 'Terms and Conditions',
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : Colors.black,
            size: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          // --- Scrollable term content ---
          termsContent(isDark),
        ],
      ),
    );
  }

  Expanded termsContent(bool isDark) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last updated: April 6, 2026',
              style: TextStyle(
                color: isDark ? Colors.grey[200] : Colors.grey[500],
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Please read these terms and conditions carefully before using Our Service.',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // Standard mock sections
            _buildSection(
              '1. Acceptance of Terms',
              'By accessing or using the Service, You agree to be bound by these Terms and Conditions. If You disagree with any part of these Terms and Conditions then You may not access the Service.',
              isDark,
            ),
            _buildSection(
              '2. User Accounts',
              'When You create an account with Us, You must provide Us information that is accurate, complete, and current at all times. Failure to do so constitutes a breach of the Terms, which may result in immediate termination of Your account on Our Service.',
              isDark,
            ),
            _buildSection(
              '3. Content and Courses',
              'Our Service allows You to post, link, store, share and otherwise make available certain information, text, graphics, videos, or other material. The course instructors (Ustads) are responsible for the accuracy and quality of their respective content.',
              isDark,
            ),
            _buildSection(
              '4. Intellectual Property',
              'The Service and its original content (excluding Content provided by You or other users), features and functionality are and will remain the exclusive property of the Company and its licensors.',
              isDark,
            ),
            _buildSection(
              '5. Termination',
              'We may terminate or suspend Your Account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if You breach these Terms and Conditions.',
              isDark,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Reusable Widget: Build Section Text
  Widget _buildSection(String title, String content, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
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
              color: isDark ? Colors.grey[400] : Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
