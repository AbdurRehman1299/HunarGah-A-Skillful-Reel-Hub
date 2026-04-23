import 'package:flutter/material.dart';
import 'package:hunargah/components/app_bar.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Terms and Conditions',
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        ),
      ),
      body: Column(
        children: [
          // --- Scrollable term content ---
          termsContent(),
        ],
      ),
    );
  }

  Expanded termsContent() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last updated: April 6, 2026',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Please read these terms and conditions carefully before using Our Service.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // Standard mock sections
            _buildSection(
              '1. Acceptance of Terms',
              'By accessing or using the Service, You agree to be bound by these Terms and Conditions. If You disagree with any part of these Terms and Conditions then You may not access the Service.',
            ),
            _buildSection(
              '2. User Accounts',
              'When You create an account with Us, You must provide Us information that is accurate, complete, and current at all times. Failure to do so constitutes a breach of the Terms, which may result in immediate termination of Your account on Our Service.',
            ),
            _buildSection(
              '3. Content and Courses',
              'Our Service allows You to post, link, store, share and otherwise make available certain information, text, graphics, videos, or other material. The course instructors (Ustads) are responsible for the accuracy and quality of their respective content.',
            ),
            _buildSection(
              '4. Intellectual Property',
              'The Service and its original content (excluding Content provided by You or other users), features and functionality are and will remain the exclusive property of the Company and its licensors.',
            ),
            _buildSection(
              '5. Termination',
              'We may terminate or suspend Your Account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if You breach these Terms and Conditions.',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Reusable Widget: Build Section Text
  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
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
