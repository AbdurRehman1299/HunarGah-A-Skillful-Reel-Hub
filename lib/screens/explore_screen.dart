import 'package:flutter/material.dart';
import 'package:hunargah/components/app_bar.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Explore'),
      // -- Floating Action Filter Button --
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFilterModal(context),
        backgroundColor: themeColor,
        child: const Icon(Icons.tune, color: Colors.white),
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

            // -- Trending Skills --
            trendingSkillsText(themeColor),

            const SizedBox(height: 16),

            // Horizontal Scrolling skill pills
            trendingSkillPills(),

            const SizedBox(height: 32),

            // -- Top Ustads --
            topUstadsText(),

            // -- List Ustad Cards --
            _buildUstadCard(
              name: 'Ustad Ali Raza',
              skill: 'Expert AC Technician',
              rating: '4.9',
              reviews: '1.2k',
              statusColor: Colors.green,
            ),
            _buildUstadCard(
              name: 'Sajid Mahmood',
              skill: 'Master Electrician',
              rating: '4.8',
              reviews: '850',
              statusColor: Colors.orange,
            ),
            _buildUstadCard(
              name: 'Chef Imran',
              skill: 'Culinary Arts',
              rating: '4.7',
              reviews: '540',
              statusColor: Colors.red,
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Row topUstadsText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Top Ustads',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          'RECOMMENDED',
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  SingleChildScrollView trendingSkillPills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildSkillPill('AC Repair', isActive: true),
          _buildSkillPill('Graphic Designing'),
          _buildSkillPill('Stitching'),
          _buildSkillPill('Cooking'),
        ],
      ),
    );
  }

  Row trendingSkillsText(Color themeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            Text('🔥', style: TextStyle(fontSize: 18)),
            SizedBox(width: 8),
            Text(
              'Trending Skills',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Text(
          'See All',
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
          hintText: 'Search for skills or Ustad',
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // Method to show the Bottom sheet
  void _showFilterModal(BuildContext context) {
    // showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => const FilterBottomSheet);
  }

  // Reusable Widget: Horizontal Skills Pills
  Widget _buildSkillPill(String title, {bool isActive = false}) {
    final themeColor = Theme.of(context).primaryColor;

    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? themeColor : Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? themeColor : Colors.grey[200]!),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.grey[800],
          fontSize: 12,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  // Reusable Widget: Ustads Profile Card
  Widget _buildUstadCard({
    required String name,
    required String skill,
    required String rating,
    required String reviews,
    required Color statusColor,
  }) {
    final themeColor = Theme.of(context).primaryColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // -- Avatar with status indicator --
          profileAvatar(statusColor),

          const SizedBox(width: 16),

          // -- Info Column --
          profileInfo(name, themeColor, skill, rating, reviews),

          // -- Profile Button --
          profileButton(themeColor),
        ],
      ),
    );
  }

  OutlinedButton profileButton(Color themeColor) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: themeColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      ),
      child: Text('Profile', style: TextStyle(color: themeColor, fontSize: 12)),
    );
  }

  Expanded profileInfo(
    String name,
    Color themeColor,
    String skill,
    String rating,
    String reviews,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

              const SizedBox(width: 4),

              Icon(Icons.verified, color: themeColor, size: 14),
            ],
          ),

          const SizedBox(height: 4),

          Text(skill, style: TextStyle(color: Colors.grey[600], fontSize: 12)),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 14),

              const SizedBox(width: 4),

              Text(
                rating,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),

              const SizedBox(width: 4),

              Text(
                '$reviews reviews',
                style: TextStyle(color: Colors.grey[500], fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Stack profileAvatar(Color statusColor) {
    return Stack(
      children: [
        const CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
