import 'package:flutter/material.dart';
import 'package:hunargah/components/app_bar.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Categories',
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/notification');
            },
            icon: Icon(Icons.notifications_none, color: isDark ? Colors.white : Colors.black),
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

            // -- Search Bar --
            searchBar(),

            const SizedBox(height: 24),

            // -- Feature Skills Text & View All Button --
            featureSkillHeader(themeColor),

            const SizedBox(height: 16),

            // -- Trending Card --
            trendingNowCards(themeColor),

            const SizedBox(height: 32),

            // -- All Skill Categories Header --
            skillCategoryHeader(themeColor),

            const SizedBox(height: 16),

            // -- Categories Grid --
            categoriesCards(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  GridView categoriesCards() {
    return GridView.count(
      shrinkWrap: true, // Lets GridView live inside SingleChildScrollView
      physics:
          const NeverScrollableScrollPhysics(), // Disables Grid's own scrolling
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.9, // Adjusts he height of cards
      children: [
        _buildCategoryCard(
          'Electrician',
          '24 COURSES',
          Icons.bolt,
          const Color(0xFFE0F2F1),
        ),
        _buildCategoryCard(
          'Welder',
          '12 COURSES',
          Icons.local_fire_department,
          const Color(0xFFF1F8E9),
        ),
        _buildCategoryCard(
          'Tailor',
          '19 COURSES',
          Icons.content_cut,
          const Color(0xFFE0F7FA),
        ),
        _buildCategoryCard(
          'Plumber',
          '15 COURSES',
          Icons.water_drop,
          const Color(0xFFF1F8E9),
        ),
        _buildCategoryCard(
          'AC Mechanic',
          '9 COURSES',
          Icons.air,
          const Color(0xFFFFF8E1),
        ),
        _buildCategoryCard(
          'Carpentry',
          '14 COURSES',
          Icons.handyman,
          const Color(0xFFE0F7FA),
        ),
      ],
    );
  }

  Row skillCategoryHeader(Color themeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'All Skill Categories',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          // Dark overlay gradient to make text readable
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
                  // Yellow Tag
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

            // Circular Arrow Button
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: themeColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
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

  Row featureSkillHeader(Color themeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Featured Skills',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  Container searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: Colors.grey[500]),
          hintText: 'Search for skills or Ustads',
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // Reusable Widget: Build Category Cards
  Widget _buildCategoryCard(
    String title,
    String subtitle,
    IconData icon,
    Color bgColor,
  ) {
    final themeColor = Theme.of(context).primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular Icon Container
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: themeColor, size: 24),
          ),

          const SizedBox(height: 16),

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
