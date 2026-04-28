import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/viewmodels/dashboard_viewmodel.dart';
import 'package:hunargah/view/components/bottom_bar.dart';
import 'package:hunargah/view/home/category_view.dart';
import 'package:hunargah/view/home/explore_view.dart';
import 'package:hunargah/view/home/learner_feed_view.dart';
import 'package:hunargah/view/home/user_profile_view.dart';

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
