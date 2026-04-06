import 'package:flutter/material.dart';
import 'package:hunargah/components/bottom_bar.dart';
import 'package:hunargah/screens/category_screen.dart';
import 'package:hunargah/screens/explore_screen.dart';
import 'package:hunargah/screens/learner_feed_screen.dart';
import 'package:hunargah/screens/user_profile_screen.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;

  // List of Screens of Bottom Nav tabs
  final List<Widget> _screens = [
    const LearnerFeedScreen(),
    const ExploreScreen(),
    const CategoryScreen(),
    const UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // The body swaps out depending on the current index
      body: IndexedStack(index: _currentIndex, children: _screens),
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
