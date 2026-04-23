import 'package:flutter/material.dart';
import 'package:hunargah/components/bottom_bar.dart';
import 'package:hunargah/screens/dashboard/category_screen.dart';
import 'package:hunargah/screens/dashboard/explore_screen.dart';
import 'package:hunargah/screens/dashboard/learner_feed_screen.dart';
import 'package:hunargah/screens/dashboard/user_profile_screen.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // List of Screens of Bottom Nav tabs
    final List<Widget> screens = [
      LearnerFeedScreen(isActive: _currentIndex == 0),
      const ExploreScreen(),
      const CategoryScreen(),
      const UserProfileScreen(),
    ];
    return Scaffold(
      backgroundColor: Colors.transparent,
      // The body swaps out depending on the current index
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
