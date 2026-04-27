import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/components/app_bar.dart';
import 'package:hunargah/screens/model/category_model.dart';
import 'package:hunargah/screens/viewmodels/category_viewmodel.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller
    final CategoryController controller = Get.put(CategoryController());

    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      appBar: CustomAppBar(
        title: 'Categories',
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('/notification');
            },
            icon: Icon(
              Icons.notifications_none,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            searchBar(isDark, controller),
            const SizedBox(height: 24),
            featureSkillHeader(themeColor, isDark),
            const SizedBox(height: 16),
            trendingNowCards(themeColor),
            const SizedBox(height: 32),
            skillCategoryHeader(themeColor, isDark),
            const SizedBox(height: 16),
            categoriesGrid(isDark, controller, themeColor),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget categoriesGrid(
    bool isDark,
    CategoryController controller,
    Color themeColor,
  ) {
    return Obx(() {
      if (controller.categories.isEmpty) {
        return Center(child: CircularProgressIndicator(color: themeColor));
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          return _buildCategoryCard(category, isDark, themeColor);
        },
      );
    });
  }

  Widget _buildCategoryCard(
    CategoryModel category,
    bool isDark,
    Color themeColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : category.bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.grey[700]!
              : Colors.black.withValues(alpha: 0.03),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Icon(category.icon, color: themeColor, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            category.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            category.subtitle,
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[500],
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // --- UI Helpers remain the same but use controller where needed ---

  Container searchBar(bool isDark, CategoryController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller.searchController, // Attached to ViewModel
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          icon: Icon(
            Icons.search,
            color: isDark ? Colors.grey[100] : Colors.grey[500],
          ),
          hintText: 'Search for skills or Ustads',
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[100] : Colors.grey[500],
            fontSize: 14,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Row skillCategoryHeader(Color themeColor, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'All Skill Categories',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: themeColor.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '24+ Types',
            style: TextStyle(
              color: themeColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Row featureSkillHeader(Color themeColor, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Featured Skills',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        Text(
          'View All',
          style: TextStyle(
            color: themeColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Container trendingNowCards(Color themeColor) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1509391366360-2e959784a276?auto=format&fit=crop&w=800&q=80',
          ),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Trending Now',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Solar Technician',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '8 New Advanced Modules',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: themeColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
