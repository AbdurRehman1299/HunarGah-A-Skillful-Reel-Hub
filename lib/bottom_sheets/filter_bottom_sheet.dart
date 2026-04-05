import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // State variables for tracking selections
  String _selectedSort = 'Most Popular';
  String _selectedLanguage = 'Urdu';
  String _selectedSkillLevel = 'All Levels';

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // -- Header Section --
          headerSection(context, themeColor),

          Divider(color: Colors.grey[200], height: 1, thickness: 1),

          // -- Scrollable Filter Options --
          filterOptions(),

          // -- Apply Button --
          applyButton(context, themeColor),
        ],
      ),
    );
  }

  Padding applyButton(BuildContext context, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Apply Filter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Personalizing your skill feed...',
            style: TextStyle(color: Colors.grey[500], fontSize: 11),
          ),
        ],
      ),
    );
  }

  Expanded filterOptions() {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Sort By
            _buildSectionTitle(Icons.sort, 'Sort by'),
            _buildRadioOption(
              'Most Popular',
              'Courses with most learner',
              _selectedSort,
              (val) => setState(() => _selectedSort = val),
            ),
            _buildRadioOption(
              'Recently Added',
              'New Skills from Top Ustads',
              _selectedSort,
              (val) => setState(() => _selectedSort = val),
            ),
            _buildRadioOption(
              'Top Rated',
              'Highest user satisfaction',
              _selectedSort,
              (val) => setState(() => _selectedSort = val),
            ),

            const SizedBox(height: 24),

            // 2. Language
            _buildSectionTitle(Icons.language, 'Language'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildLanguagePill('Urdu'),
                _buildLanguagePill('English'),
                _buildLanguagePill('Punjabi'),
              ],
            ),

            const SizedBox(height: 24),

            // 3. Skill Level
            _buildSectionTitle(Icons.bar_chart, 'Skill Level'),
            _buildRadioOption(
              'All Levels',
              '',
              _selectedSkillLevel,
              (val) => setState(() => _selectedSkillLevel = val),
            ),
            _buildRadioOption(
              'Beginner',
              'Start from basics',
              _selectedSkillLevel,
              (val) => setState(() => _selectedSkillLevel = val),
            ),
            _buildRadioOption(
              'Intermediate',
              'Expand your existing knowledge',
              _selectedSkillLevel,
              (val) => setState(() => _selectedSkillLevel = val),
            ),
            _buildRadioOption(
              'Advanced',
              'Take your skills on another level',
              _selectedSkillLevel,
              (val) => setState(() => _selectedSkillLevel = val),
            ),
          ],
        ),
      ),
    );
  }

  Padding headerSection(BuildContext context, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: Colors.black),
          ),
          const Text(
            'Filters',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _selectedSort = 'Most Popular';
                _selectedLanguage = 'Urdu';
                _selectedSkillLevel = 'All Levels';
              });
            },
            icon: Icon(Icons.refresh, color: themeColor, size: 16),
            label: Text(
              'Reset',
              style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable Widget: Section Titles
  Widget _buildSectionTitle(IconData icon, String title) {
    final themeColor = Theme.of(context).primaryColor;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: themeColor),

          const SizedBox(width: 8),

          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Reusable Widget: Radio Option Card
  Widget _buildRadioOption(
    String title,
    String subtitle,
    String groupValue,
    Function(String) onChanged,
  ) {
    final themeColor = Theme.of(context).primaryColor;
    bool isSelected = groupValue == title;

    return GestureDetector(
      onTap: () => onChanged(title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? themeColor.withValues(alpha: 0.08)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? themeColor.withValues(alpha: 0.5)
                : Colors.grey[200]!,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[500], fontSize: 11),
                    ),
                  ],
                ],
              ),
            ),
            // Custom Radio Circle
            radioCircle(isSelected, themeColor),
          ],
        ),
      ),
    );
  }

  Container radioCircle(bool isSelected, Color themeColor) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? themeColor : Colors.grey[400]!,
          width: 1.5,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: themeColor,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }

  // Reusable Widget: Language Pill
  Widget _buildLanguagePill(String language) {
    final themeColor = Theme.of(context).primaryColor;
    bool isSelected = _selectedLanguage == language;

    return GestureDetector(
      onTap: () => setState(() => _selectedLanguage = language),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? themeColor.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? themeColor.withValues(alpha: 0.5)
                : Colors.grey[200]!,
          ),
        ),
        child: Center(
          child: Text(
            language,
            style: TextStyle(
              color: isSelected ? themeColor : Colors.grey[800],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
