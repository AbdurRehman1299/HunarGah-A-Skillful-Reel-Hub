import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/model/onboarding_model.dart';
import 'package:hunargah/viewmodels/onboarding_viewmodel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingViewModel());

    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          // -- Image and Text Content --
          PageView.builder(
            controller: controller.pageController,
            itemCount: controller.pages.length,
            itemBuilder: (context, index) {
              final page = controller.pages[index];
              return _buildPageContent(page);
            },
          ),

          // -- Footer Area (Indicator and Next Button) --
          footerSection(themeColor, context, controller),
        ],
      ),
    );
  }

  Align footerSection(
    Color themeColor,
    BuildContext context,
    OnboardingViewModel controller,
  ) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // -- Smooth Page Indicator --
              SmoothPageIndicator(
                controller: controller.pageController,
                count: controller.pages.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: themeColor,
                  dotColor: Colors.white.withValues(alpha: 0.5),
                  dotHeight: 8,
                  dotWidth: 8,
                  expansionFactor: 3,
                  spacing: 8,
                ),
              ),

              // -- Next Button --
              nextButton(themeColor, controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget nextButton(Color themeColor, OnboardingViewModel controller) {
    // Obx makes the button reactive so we can show a loader while saving to Firebase
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isUpdating.value
            ? null
            : () => controller.goNext(),
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          disabledBackgroundColor: themeColor.withValues(
            alpha: 0.5,
          ), // Dark mode friendly disabled state
        ),
        child: controller.isUpdating.value
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                ],
              ),
      ),
    );
  }

  Widget _buildPageContent(OnboardingPageModel page) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(page.image),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          const Spacer(),
          // Adding a dark gradient at the bottom ensures white text is ALWAYS readable
          // even if the user switches to a lighter image later.
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 24.0,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(
                    alpha: 0.8,
                  ), // Dark mode text readability
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  page.heading,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  page.description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 100), // Space for footer elements
              ],
            ),
          ),
        ],
      ),
    );
  }
}
