import 'package:get/get.dart';
import 'package:hunargah/database/firebase_service.dart';
import 'package:hunargah/screens/model/ustad_model.dart';
import 'package:flutter/material.dart';

class ExploreController extends GetxController {
  final RxList<UstadModel> allUstads = <UstadModel>[].obs;
  final RxBool isLoading = true.obs;

  final RxString searchQuery = ''.obs;
  final RxString selectedSkill = 'All'.obs;

  final List<String> trendingSkills = [
    'All',
    'AC Repair',
    'Graphic Designing',
    'Stitching',
    'Cooking',
  ];

  @override
  void onInit() {
    super.onInit();

    allUstads.bindStream(
      FirebaseService().getUstadsStream().map(
        (query) =>
            query.docs.map((doc) => UstadModel.fromSnapshot(doc)).toList(),
      ),
    );

    ever(allUstads, (_) => isLoading.value = false);
  }

  void updateSearch(String query) => searchQuery.value = query.toLowerCase();
  void selectSkill(String skill) => selectedSkill.value = skill;

  List<UstadModel> get filteredUstads {
    return allUstads.where((ustad) {
      final name = ustad.username.toLowerCase();
      final skill = ustad.skillTitle.toLowerCase();
      final query = searchQuery.value;

      bool matchesPill =
          selectedSkill.value == 'All' ||
          skill.contains(selectedSkill.value.toLowerCase());
      bool matchesSearch =
          query.isEmpty || name.contains(query) || skill.contains(query);

      return matchesPill && matchesSearch;
    }).toList();
  }

  var selectedSort = 'Most Popular'.obs;
  var selectedLanguage = 'Urdu'.obs;
  var selectedSkillLevel = 'All Levels'.obs;

  void resetFilters() {
    selectedSort.value = 'Most Popular';
    selectedLanguage.value = 'Urdu';
    selectedSkillLevel.value = 'All Levels';
  }

  void applyFilters() {
    Get.back();
  }

  void showFilterSheet(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Header
            _buildHeader(context, themeColor, isDark),
            Divider(
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              height: 1,
            ),

            // Options
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle(Icons.sort, 'Sort by', themeColor, isDark),
                    _buildSortOptions(themeColor, isDark),
                    const SizedBox(height: 24),

                    _sectionTitle(
                      Icons.language,
                      'Language',
                      themeColor,
                      isDark,
                    ),
                    _buildLanguageOptions(themeColor, isDark),
                    const SizedBox(height: 24),

                    _sectionTitle(
                      Icons.bar_chart,
                      'Skill Level',
                      themeColor,
                      isDark,
                    ),
                    _buildSkillLevelOptions(themeColor, isDark),
                  ],
                ),
              ),
            ),

            // Footer Button
            _buildApplyButton(themeColor, isDark),
          ],
        ),
      ),
    );
  }

  // --- UI Helper Methods (Inside Controller for cleaner code) ---

  Widget _buildHeader(BuildContext context, Color themeColor, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.close,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          Text(
            'Filters',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          TextButton.icon(
            onPressed: resetFilters,
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

  Widget _sectionTitle(
    IconData icon,
    String title,
    Color themeColor,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: themeColor),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortOptions(Color themeColor, bool isDark) {
    return Obx(
      () => Column(
        children: [
          _radioCard(
            'Most Popular',
            'Courses with most learners',
            selectedSort.value,
            (v) => selectedSort.value = v,
            themeColor,
            isDark,
          ),
          _radioCard(
            'Recently Added',
            'New Skills from Top Ustads',
            selectedSort.value,
            (v) => selectedSort.value = v,
            themeColor,
            isDark,
          ),
          _radioCard(
            'Top Rated',
            'Highest user satisfaction',
            selectedSort.value,
            (v) => selectedSort.value = v,
            themeColor,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOptions(Color themeColor, bool isDark) {
    return Obx(
      () => Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          'Urdu',
          'English',
          'Punjabi',
        ].map((lang) => _languagePill(lang, themeColor, isDark)).toList(),
      ),
    );
  }

  Widget _buildSkillLevelOptions(Color themeColor, bool isDark) {
    return Obx(
      () => Column(
        children: [
          _radioCard(
            'All Levels',
            '',
            selectedSkillLevel.value,
            (v) => selectedSkillLevel.value = v,
            themeColor,
            isDark,
          ),
          _radioCard(
            'Beginner',
            'Start from basics',
            selectedSkillLevel.value,
            (v) => selectedSkillLevel.value = v,
            themeColor,
            isDark,
          ),
          _radioCard(
            'Intermediate',
            'Expand existing knowledge',
            selectedSkillLevel.value,
            (v) => selectedSkillLevel.value = v,
            themeColor,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _radioCard(
    String title,
    String sub,
    String group,
    Function(String) onTap,
    Color themeColor,
    bool isDark,
  ) {
    bool isSelected = title == group;
    return GestureDetector(
      onTap: () => onTap(title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? themeColor.withValues(alpha: 0.1)
              : (isDark ? Colors.grey[800] : Colors.grey[50]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? themeColor.withValues(alpha: 0.5)
                : (isDark ? Colors.grey[700]! : Colors.grey[200]!),
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
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (sub.isNotEmpty)
                    Text(
                      sub,
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[500],
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
            _radioCircle(isSelected, themeColor),
          ],
        ),
      ),
    );
  }

  Widget _radioCircle(bool isSelected, Color themeColor) {
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

  Widget _languagePill(String lang, Color themeColor, bool isDark) {
    bool isSelected = selectedLanguage.value == lang;
    return GestureDetector(
      onTap: () => selectedLanguage.value = lang,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? themeColor.withValues(alpha: 0.1)
              : (isDark ? Colors.grey[800] : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? themeColor.withValues(alpha: 0.5)
                : (isDark ? Colors.grey[700]! : Colors.grey[200]!),
          ),
        ),
        child: Center(
          child: Text(
            lang,
            style: TextStyle(
              color: isSelected
                  ? themeColor
                  : (isDark ? Colors.white : Colors.grey[800]),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildApplyButton(Color themeColor, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: applyFilters,
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
            style: TextStyle(
              color: isDark ? Colors.grey[500] : Colors.grey[500],
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
