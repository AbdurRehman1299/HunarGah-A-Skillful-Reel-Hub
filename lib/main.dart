import 'package:get/get.dart';
import 'package:hunargah/screens/security/secure_storage.dart';
import 'package:hunargah/screens/theme/theme_controller.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hunargah/screens/utils/route_observer.dart';
import 'package:hunargah/screens/view/main_dashboard.dart';
import 'package:hunargah/screens/courses/course_playlist_screen.dart';
import 'package:hunargah/screens/settings/edit_profile_screen.dart';
import 'package:hunargah/screens/onboarding/language_selector_screen.dart';
import 'package:hunargah/auth/view/login/login_screen.dart';
import 'package:hunargah/screens/settings/notifications_screen.dart';
import 'package:hunargah/screens/onboarding/onboarding_screen.dart';
import 'package:hunargah/screens/privacy_terms/privacy_and_policy_screen.dart';
import 'package:hunargah/screens/onboarding/profile_picture_screen.dart';
import 'package:hunargah/screens/courses/quiz_dialog_screen.dart';
import 'package:hunargah/screens/view/settings_screen.dart';
import 'package:hunargah/auth/view/signup/signup_screen.dart';
import 'package:hunargah/screens/onboarding/skills_interested_screen.dart';
import 'package:hunargah/auth/view/splash/splash_screen.dart';
import 'package:hunargah/screens/privacy_terms/terms_and_conditions_screen.dart';
import 'package:hunargah/screens/explore/ustad_profile_screen.dart';
import 'package:hunargah/screens/courses/video_player_screen.dart';

void main() async {
  // Ensure Flutter bindings are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  String? savedTheme = await SecureStorage.getTheme();
  ThemeMode initialTheme = savedTheme == 'dark'
      ? ThemeMode.dark
      : ThemeMode.light;
  Get.put(ThemeController(initialTheme: initialTheme));

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      return GetMaterialApp(
        title: 'HunarGah',
        debugShowCheckedModeBanner: false,
        navigatorObservers: [routeObserver],
        home: SplashScreen(),
        themeMode: themeController.themeMode.value,

        // Define the all routes
        getPages: [
          GetPage(name: '/login', page: () => const LoginScreen()),
          GetPage(name: '/signup', page: () => const SignupScreen()),
          GetPage(name: '/terms', page: () => const TermsAndConditionsScreen()),
          GetPage(name: '/privacy', page: () => const PrivacyPolicyScreen()),
          GetPage(name: '/onboarding', page: () => const OnboardingScreen()),
          GetPage(
            name: '/language',
            page: () => const LanguageSelectorScreen(),
          ),
          GetPage(name: '/skills', page: () => const SkillsInterestedScreen()),
          GetPage(
            name: '/profile-picture',
            page: () => const ProfilePictureScreen(),
          ),
          GetPage(name: '/dashboard', page: () => const MainDashboard()),
          GetPage(name: '/settings', page: () => const SettingsScreen()),
          GetPage(name: '/edit-profile', page: () => const EditProfileScreen()),
          GetPage(
            name: '/ustad-profile',
            page: () => UstadProfileScreen(ustadId: Get.arguments as String),
          ),
          GetPage(
            name: '/course-playlist',
            page: () => const CoursePlaylistScreen(),
          ),
          GetPage(name: '/video-player', page: () => const VideoPlayerScreen()),
          GetPage(name: '/quiz', page: () => const QuizDialog()),
          GetPage(
            name: '/notification',
            page: () => const NotificationsScreen(),
          ),
        ],
        // Set theme to declare color one time
        theme: ThemeData(
          primaryColor: const Color(0xFF00897B),
          useMaterial3: true,
          brightness: Brightness.light,
        ),

        darkTheme: ThemeData(
          primaryColor: const Color(0xFF00897B),
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
      );
    });
  }
}
