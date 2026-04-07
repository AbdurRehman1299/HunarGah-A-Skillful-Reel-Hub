import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hunargah/components/app_bar.dart';

class SkillsInterestedScreen extends StatefulWidget {
  const SkillsInterestedScreen({super.key});

  @override
  State<SkillsInterestedScreen> createState() => _SkillsInterestedScreenState();
}

class _SkillsInterestedScreenState extends State<SkillsInterestedScreen> {
  // A set to store the skills the user has tapped
  final Set<String> _selectedSkills = {};

  // The list of skills with icons
  final List<SkillCategory> _skills = [
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

  Future<void> _saveSelectedSkills() async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'skills': _selectedSkills
              .toList(), // Convert Set to List for Firestore
          'onboardingStep': 3, // Mark skills selection as completed
        });

        navigator.pushNamed('/profile');
      } catch (e) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Failed to save skills. Please try again.'),
          ),
        );
      }
    }
  }

  // Function to toggle skill on or off
  void _toggleSkill(String skillName) {
    setState(() {
      if (_selectedSkills.contains(skillName)) {
        _selectedSkills.remove(skillName);
      } else {
        _selectedSkills.add(skillName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    // Check if the user has selected at least 3 skills
    final bool hasEnoughSkills = _selectedSkills.length >= 3;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
        ),
        title: 'Personalized HunarGah',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -- Header Section --
              headerSection(themeColor),

              const SizedBox(height: 8),

              Text(
                'Select at least 3 categories to help us\ntailor your learning experience.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              // -- Skills Grid --
              // Wrap automatically to move item on next line
              Wrap(
                spacing: 12, // Horizontal space
                runSpacing: 12, // Vertical space
                children: _skills.map((skill) {
                  // Calculate width so eactly 2 chips fit side-by-side
                  final chipWidth =
                      (MediaQuery.of(context).size.width - 48 - 12) / 2;

                  return SizedBox(
                    width: chipWidth,
                    child: _buildSkillChip(skill, themeColor),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              // -- Daily Inspiration Banner --
              dailyInspirationBanner(themeColor),

              const SizedBox(height: 24),

              // -- Start Learning Button --
              startLearningButton(hasEnoughSkills, context, themeColor),

              const SizedBox(height: 16),

              // -- Footer Text --
              footerText(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  RichText headerSection(Color themeColor) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: Colors.black87,
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

  Container dailyInspirationBanner(Color themeColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeColor.withValues(alpha: 0.08),
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
                    color: Colors.grey[600],
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

  Center footerText() {
    return Center(
      child: Text(
        'You can change your interest anytime in Settings.',
        style: TextStyle(color: Colors.grey[600], fontSize: 10),
      ),
    );
  }

  SizedBox startLearningButton(
    bool hasEnoughSkills,
    BuildContext context,
    Color themeColor,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: hasEnoughSkills ? _saveSelectedSkills : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: hasEnoughSkills ? themeColor : Colors.grey[300],
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
              'Start Learning',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: hasEnoughSkills ? Colors.white : Colors.grey[500],
              ),
            ),
            Icon(
              Icons.arrow_forward,
              color: hasEnoughSkills ? Colors.white : Colors.grey[500],
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Component: Skill Chip
  Widget _buildSkillChip(SkillCategory skill, Color themeColor) {
    final bool isSelected = _selectedSkills.contains(skill.name);

    return GestureDetector(
      onTap: () => _toggleSkill(skill.name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? themeColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? themeColor : Colors.grey[200]!,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // -- Icon Container --
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
                color: isSelected ? Colors.white : Colors.teal[600],
              ),
            ),

            const SizedBox(width: 8),

            // -- Skill Text --
            Expanded(
              child: Text(
                skill.name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey[700],
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

class SkillCategory {
  final String name;
  final IconData icon;

  SkillCategory(this.name, this.icon);
}
