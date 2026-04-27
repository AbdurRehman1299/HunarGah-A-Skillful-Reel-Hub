import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/database/firebase_service.dart';
import 'package:hunargah/screens/model/onboarding_model.dart';

class OnboardingViewModel extends GetxController {
  final PageController pageController = PageController();
  late Timer _carouselTimer;

  var isUpdating = false.obs;

  final List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      image: 'assets/images/onboarding/onboarding1.jpg',
      heading: 'Learn Practical Skills\nfrom Experts',
      description:
          'Master plumbing, electric work, and more with our expert Ustads.',
    ),
    OnboardingPageModel(
      image: 'assets/images/onboarding/onboarding2.webp',
      heading: 'Explore Diverse Trades',
      description:
          'Find workshops in construction, tailoring, and automotive repair near you.',
    ),
    OnboardingPageModel(
      image: 'assets/images/onboarding/onboarding3.jpg',
      heading: 'Start Your Business',
      description:
          'Learn how to land gigs, open a shop, and start earning from day one.',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (pageController.hasClients) {
        if (pageController.page == pages.length - 1) {
          pageController.jumpToPage(0);
        } else {
          pageController.nextPage(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void onClose() {
    _carouselTimer.cancel();
    pageController.dispose();
    super.onClose();
  }

  Future<void> goNext() async {
    isUpdating.value = true;

    String? errorMessage = await FirebaseService().updateOnboardingStep(1);

    isUpdating.value = false;

    if (errorMessage == null) {
      Get.offNamed('/language');
    } else {
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
