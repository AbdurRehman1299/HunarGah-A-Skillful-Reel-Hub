import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hunargah/components/app_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // To toggle password visibility
  bool _obsecurePassword = true;

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Login',
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help_outline, color: Colors.black54),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // -- Logo Placeholder --
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: themeColor.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/hunargah-logo.png',
                  width: 55,
                  height: 55,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // -- Header --
            const Text(
              'Welcome to HunarGah',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Master new skills with Pakistan's best\nUstads. Enter your details to continue.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 40),

            // -- Email/Username Field --
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Email or Username',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter your Email',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: themeColor, width: 2),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // -- Password Field --
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  obscureText: _obsecurePassword,
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: themeColor, width: 2),
                    ),

                    // Eye icon to toggle password visibility
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obsecurePassword = !_obsecurePassword;
                        });
                      },
                      icon: Icon(
                        _obsecurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey[500],
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // -- Login Button --
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 14),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // -- Continue as Guest --
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/onboarding');
              },
              child: const Text(
                'Continue as Guest',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 60),

            // -- Footer Section --
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shield_outlined, color: Colors.grey[400], size: 16),
                const SizedBox(width: 6),
                Text(
                  'Sevure Login Powered by HunarGah',
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // RichText for clickable colored links
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: 'By signing up, you agree to our '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Navigator.pushNamed(context, '/terms');
                      },
                  ),
                  const TextSpan(text: ' and\n'),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Navigator.pushNamed(context, '/privacy');+
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
