import 'package:flutter/material.dart';
import 'package:hunargah/dashboards/main_dashboard.dart';
import 'package:hunargah/screens/language_selector_screen.dart';
import 'package:hunargah/screens/login_screen.dart';
import 'package:hunargah/screens/onboarding_screen.dart';
import 'package:hunargah/screens/profile_picture_screen.dart';
import 'package:hunargah/screens/signup_screen.dart';
import 'package:hunargah/screens/skills_interested_screen.dart';
import 'package:hunargah/screens/splash_screen.dart';
import 'package:hunargah/screens/ustad_profile_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HunarGah',
      debugShowCheckedModeBanner: false,
      // Set the first screen that loads
      home: SplashScreen(),

      // Define the all routes
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        // '/terms': (context) => const TermsServiceScreen(),
        // '/privacy': (context) => const PrivacyPolicyScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/language': (context) => const LanguageSelectorScreen(),
        '/skills': (context) => const SkillsInterestedScreen(),
        '/profile': (context) => const ProfilePictureScreen(),
        '/dashboard': (context) => const MainDashboard(),
        '/ustad-profile': (context) => const UstadProfileScreen(),
      },

      // Set theme to declare color one time
      theme: ThemeData(
        primaryColor: const Color(0xFF00897B), // Learner theme: Teal Green
        useMaterial3: true,
      ),
    );
  }
}
