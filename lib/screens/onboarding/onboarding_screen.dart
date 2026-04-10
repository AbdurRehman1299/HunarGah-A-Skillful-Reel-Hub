import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // The controller for scrollable pages
  final PageController _pageController = PageController();
  // A timer to move to next slide automatically
  late Timer _carouselTimer;

  // List of Onboarding Screens
  final List<OnboardingPageModel> _pages = [
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
  void initState() {
    super.initState();
    // Initialize the timer of 3 seconds for move to next page
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.page == _pages.length - 1) {
        _pageController.jumpToPage(0);
      } else {
        // Standard next animation
        _pageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    // Always cancel timers and controllers to prevent memory leaks
    _carouselTimer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: Stack(
        children: [
          // -- Image and Text Content --
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return _buildPageContent(page);
            },
          ),

          // -- Footer Area (Indicator and Next Button) --
          footerSection(themeColor, context),
        ],
      ),
    );
  }

  Align footerSection(Color themeColor, BuildContext context) {
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
                controller: _pageController,
                count: _pages.length,
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
              nextButton(context, themeColor),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton nextButton(BuildContext context, Color themeColor) {
    return ElevatedButton(
      onPressed: () async {
        final navigator = Navigator.of(context);
        final scaffoldMessenger = ScaffoldMessenger.of(context);

        String? uid = FirebaseAuth.instance.currentUser?.uid;

        if (uid != null) {
          try {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .update({
                  'onboardingStep': 1, // Mark onboarding as completed
                });

            if (!mounted) return;

            navigator.pushReplacementNamed('/language');
          } catch (e) {
            if (!mounted) return;

            scaffoldMessenger.showSnackBar(
              SnackBar(content: Text('Error saving onboarding status: $e')),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: themeColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Next',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward, color: Colors.white, size: 18),
        ],
      ),
    );
  }
}

Widget _buildPageContent(OnboardingPageModel page) {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(image: AssetImage(page.image), fit: BoxFit.cover),
    ),
    child: Column(
      children: [
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
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

              const SizedBox(
                height: 100,
              ), // Provide space below the text for footer elements
            ],
          ),
        ),
      ],
    ),
  );
}

class OnboardingPageModel {
  final String image;
  final String heading;
  final String description;

  OnboardingPageModel({
    required this.image,
    required this.heading,
    required this.description,
  });
}
