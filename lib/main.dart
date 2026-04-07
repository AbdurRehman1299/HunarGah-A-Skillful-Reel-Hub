import 'package:flutter/material.dart';
import 'package:hunargah/dashboards/main_dashboard.dart';
import 'package:hunargah/screens/course_playlist_screen.dart';
import 'package:hunargah/screens/edit_profile_screen.dart';
import 'package:hunargah/screens/language_selector_screen.dart';
import 'package:hunargah/screens/login_screen.dart';
import 'package:hunargah/screens/notifications_screen.dart';
import 'package:hunargah/screens/onboarding_screen.dart';
import 'package:hunargah/screens/privacy_and_policy_screen.dart';
import 'package:hunargah/screens/profile_picture_screen.dart';
import 'package:hunargah/screens/quiz_dialog_screen.dart';
import 'package:hunargah/screens/settings_screen.dart';
import 'package:hunargah/screens/signup_screen.dart';
import 'package:hunargah/screens/skills_interested_screen.dart';
import 'package:hunargah/screens/splash_screen.dart';
import 'package:hunargah/screens/terms_and_conditions_screen.dart';
import 'package:hunargah/screens/ustad_profile_screen.dart';
import 'package:hunargah/screens/video_player_screen.dart';

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
        '/terms': (context) => const TermsAndConditionsScreen(),
        '/privacy': (context) => const PrivacyPolicyScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/language': (context) => const LanguageSelectorScreen(),
        '/skills': (context) => const SkillsInterestedScreen(),
        '/profile': (context) => const ProfilePictureScreen(),
        '/dashboard': (context) => const MainDashboard(),
        '/settings': (context) => const SettingsScreen(),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/ustad-profile': (context) => const UstadProfileScreen(),
        '/course-playlist': (context) => const CoursePlaylistScreen(),
        '/video-player': (context) => const VideoPlayerScreen(),
        '/quiz': (context) => const QuizDialog(),
        '/notification': (context) => const NotificationsScreen(),
      },

      // Set theme to declare color one time
      theme: ThemeData(
        primaryColor: const Color(0xFF00897B), // Learner theme: Teal Green
        useMaterial3: true,
      ),
    );
  }
}
