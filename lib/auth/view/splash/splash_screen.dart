import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/auth/viewmodel/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),

            logoSection(themeColor),

            const Spacer(flex: 2),

            loadingSection(themeColor, isDark),

            const Spacer(flex: 1),

            loadingSlogan(isDark),
          ],
        ),
      ),
    );
  }

  Padding loadingSlogan(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Text(
        'EMPOWERING THE CRAFTSMAN',
        style: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.black54,
          fontSize: 9,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Column loadingSection(Color themeColor, bool isDark) {
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

        Text(
          'Preparing your skills...',
          style: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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

  // Reusable widget: Create Dots
  Widget _buildDot(Color themeColor) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: themeColor, shape: BoxShape.circle),
    );
  }
}
