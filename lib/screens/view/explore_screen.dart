import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/bottom_sheets/filter_bottom_sheet.dart';
import 'package:hunargah/components/app_bar.dart';
import 'package:hunargah/screens/model/ustad_model.dart';
import 'package:hunargah/screens/viewmodels/explore_controller.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExploreController());

    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      appBar: const CustomAppBar(title: 'Explore'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.bottomSheet(
          const FilterBottomSheet(),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: themeColor,
        child: Icon(Icons.tune, color: isDark ? Colors.white : Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // -- Search Bar --
            _buildSearchBar(controller, isDark),
            const SizedBox(height: 24),
            // -- Trending Skills Header --
            _buildSectionHeader(
              '🔥',
              'Trending Skills',
              'See All',
              themeColor,
              isDark,
            ),
            const SizedBox(height: 16),
            // -- Horizontal Scrolling skill pills --
            _buildTrendingSkillPills(controller, themeColor, isDark),
            const SizedBox(height: 32),
            // -- Top Ustads Header --
            _buildSectionHeader(
              '',
              'Top Ustads',
              'RECOMMENDED',
              isDark ? Colors.grey[400]! : Colors.grey[500]!,
              isDark,
            ),
            const SizedBox(height: 10),
            Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: themeColor),
                );
              }

              final filteredList = controller.filteredUstads;

              if (filteredList.isEmpty) {
                return Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: Text(
                      'No Ustad matches your search',
                      style: TextStyle(
                        color: isDark ? Colors.grey[900] : Colors.grey,
                      ),
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  return _UstadCard(
                    ustad: filteredList[index],
                    themeColor: themeColor,
                    isDark: isDark,
                  );
                },
              );
            }),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(ExploreController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onChanged: controller.updateSearch,
        decoration: InputDecoration(
          icon: Icon(
            Icons.search,
            color: isDark ? Colors.grey[100] : Colors.grey[500],
          ),
          hintText: 'Search for skills or Ustad',
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[100] : Colors.grey[500],
            fontSize: 14,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String emoji,
    String title,
    String actionText,
    Color actionColor,
    bool isDark,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (emoji.isNotEmpty) ...[
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        Text(
          actionText,
          style: TextStyle(
            color: actionColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingSkillPills(
    ExploreController controller,
    Color themeColor,
    bool isDark,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Row(
          children: controller.trendingSkills.map((skill) {
            final isActive = controller.selectedSkill.value == skill;
            return GestureDetector(
              onTap: () => controller.selectSkill(skill),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? themeColor
                      : (isDark ? Colors.grey[800] : Colors.grey[50]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive
                        ? themeColor
                        : (isDark ? Colors.grey[700]! : Colors.grey[200]!),
                  ),
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    color: isActive
                        ? Colors.white
                        : (isDark ? Colors.white70 : Colors.grey[800]),
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _UstadCard extends StatelessWidget {
  final UstadModel ustad;
  final Color themeColor;
  final bool isDark;

  const _UstadCard({
    required this.ustad,
    required this.themeColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        children: [
          _buildAvatar(ustad.profileImageUrl),
          const SizedBox(width: 16),
          _buildInfo(),
          _buildProfileButton(),
        ],
      ),
    );
  }

  Widget _buildAvatar(String? base64String) {
    ImageProvider? imageProvider;
    if (base64String != null && base64String.isNotEmpty) {
      try {
        final cleanBase64 = base64String.contains(',')
            ? base64String.split(',').last
            : base64String;
        imageProvider = MemoryImage(base64Decode(cleanBase64));
      } catch (e) {
        debugPrint('Error decoding base64: $e');
      }
    }
    return CircleAvatar(
      radius: 28,
      backgroundImage: imageProvider,
      backgroundColor: isDark ? Colors.grey[700] : Colors.grey[200],
      child: imageProvider == null
          ? Icon(Icons.person, color: isDark ? Colors.grey[400] : Colors.grey)
          : null,
    );
  }

  Widget _buildInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  ustad.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.verified, color: themeColor, size: 14),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            ustad.skillTitle,
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 14),
              const SizedBox(width: 4),
              Text(
                ustad.rating,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${ustad.reviewsCount} reviews',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileButton() {
    return OutlinedButton(
      onPressed: () => Get.toNamed('/ustad-profile', arguments: ustad.id),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: themeColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      ),
      child: Text('Profile', style: TextStyle(color: themeColor, fontSize: 12)),
    );
  }
}
