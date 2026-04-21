import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:hunargah/screens/dashboard/main_dashboard.dart';
import 'package:hunargah/screens/course_playlist_screen.dart';
import 'package:hunargah/screens/edit_profile_screen.dart';
import 'package:hunargah/screens/onboarding/language_selector_screen.dart';
import 'package:hunargah/auth/login_screen.dart';
import 'package:hunargah/screens/notifications_screen.dart';
import 'package:hunargah/screens/onboarding/onboarding_screen.dart';
import 'package:hunargah/screens/privacy_and_policy_screen.dart';
import 'package:hunargah/screens/onboarding/profile_picture_screen.dart';
import 'package:hunargah/screens/quiz_dialog_screen.dart';
import 'package:hunargah/screens/settings_screen.dart';
import 'package:hunargah/auth/signup_screen.dart';
import 'package:hunargah/screens/onboarding/skills_interested_screen.dart';
import 'package:hunargah/auth/splash_screen.dart';
import 'package:hunargah/screens/terms_and_conditions_screen.dart';
import 'package:hunargah/screens/ustad_profile_screen.dart';
import 'package:hunargah/screens/video_player_screen.dart';

void main() async {
  // Ensure Flutter bindings are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HunarGah',
      debugShowCheckedModeBanner: false,
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
        '/profile-picture': (context) => const ProfilePictureScreen(),
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
        primaryColor: const Color(0xFF00897B),
        useMaterial3: true,
      ),
    );
  }
}
