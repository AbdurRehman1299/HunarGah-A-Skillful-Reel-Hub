import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hunargah/database/firebase_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await Future.wait([
        Future.delayed(const Duration(seconds: 2)),
        Firebase.initializeApp().catchError((_) {}),
      ]);

      int? step = await FirebaseService().getUserOnboardingSteps();

      if (!mounted) return;

      if (step == null) {
        Navigator.of(context).pushReplacementNamed('/signup');
      } else if (step == 0) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      } else if (step == 1) {
        Navigator.of(context).pushReplacementNamed('/language');
      } else if (step == 2) {
        Navigator.of(context).pushReplacementNamed('/skills');
      } else if (step == 3) {
        Navigator.of(context).pushReplacementNamed('/profile-picture');
      } else {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } catch (e) {
      debugPrint('Splash Screen Error $e');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error initializing app: $e')));
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),

            // -- Main Logo Section --
            logoSection(themeColor),

            const Spacer(flex: 2),

            // -- Loading Section --
            loadingSection(themeColor),

            const Spacer(flex: 1),

            loadingSlogan(),
          ],
        ),
      ),
    );
  }

  Padding loadingSlogan() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 24.0),
      child: Text(
        'EMPOWERING THE CRAFTSMAN',
        style: TextStyle(
          color: Colors.black54,
          fontSize: 9,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Column loadingSection(Color themeColor) {
    return Column(
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(themeColor),
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Preparing your skills...',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pass the theme color to helper function
            _buildDot(themeColor),
            const SizedBox(width: 6),
            _buildDot(themeColor),
            const SizedBox(width: 6),
            _buildDot(themeColor),
            const SizedBox(width: 6),
          ],
        ),
      ],
    );
  }

  Center logoSection(Color themeColor) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            'assets/images/hunargah-logo.png',
            width: 110,
            height: 110,
          ),

          const SizedBox(height: 30),

          Text(
            'SEEKHO SIKHAO',
            style: TextStyle(
              color: themeColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 3.0,
            ),
          ),

          const SizedBox(height: 12),

          Container(width: 50, height: 2, color: themeColor),
        ],
      ),
    );
  }
}

Widget _buildDot(Color themecolor) {
  return Container(
    width: 6,
    height: 6,
    decoration: BoxDecoration(color: themecolor, shape: BoxShape.circle),
  );
}
