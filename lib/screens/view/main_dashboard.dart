import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/screens/viewmodels/dashboard_controller.dart';
import 'package:hunargah/components/bottom_bar.dart';
import 'package:hunargah/screens/dashboard/category_screen.dart';
import 'package:hunargah/screens/dashboard/explore_screen.dart';
import 'package:hunargah/screens/dashboard/learner_feed_screen.dart';
import 'package:hunargah/screens/dashboard/user_profile_screen.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: [
            LearnerFeedScreen(isActive: controller.currentIndex.value == 0),
            const ExploreScreen(),
            const CategoryScreen(),
            const UserProfileScreen(),
          ],
        ),
      ),

      bottomNavigationBar: Obx(
        () => CustomBottomNav(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTabIndex,
        ),
      ),
    );
  }
}
