import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/components/app_bar.dart';
import 'package:hunargah/auth/viewmodel/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Login',
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.help_outline,
              color: isDark ? Colors.grey[400] : Colors.black54,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // -- Logo Section --
            logoSection(themeColor),

            const SizedBox(height: 24),

            // -- Header Section --
            headerSection(isDark),

            const SizedBox(height: 12),

            descriptionSection(isDark),

            const SizedBox(height: 40),

            // -- Email/Username Field --
            emailSection(themeColor, isDark, controller),

            const SizedBox(height: 20),

            // -- Password Field --
            passwordSection(themeColor, isDark, controller),

            const SizedBox(height: 32),

            // -- Login Button --
            loginButton(themeColor, controller),

            const SizedBox(height: 16),

            dividerSection(isDark),

            const SizedBox(height: 16),

            // -- Move to SignUp --
            noAccount(themeColor, isDark),

            const SizedBox(height: 60),

            // -- Footer Section --
            footerSection(isDark),

            const SizedBox(height: 16),

            // RichText for clickable colored links
            privacyAndTerms(themeColor, isDark),
          ],
        ),
      ),
    );
  }

  Container logoSection(Color themeColor) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: themeColor.withValues(alpha: 0.5), width: 1),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/hunargah-logo.png',
          width: 55,
          height: 55,
        ),
      ),
    );
  }

  Text descriptionSection(bool isDark) {
    return Text(
      "Master new skills with Pakistan's best\nUstads. Enter your details to continue.",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 13,
        color: isDark ? Colors.grey[400] : Colors.black54,
        height: 1.5,
      ),
    );
  }

  Text headerSection(bool isDark) {
    return Text(
      'Welcome to HunarGah',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }

  Column emailSection(
    Color themeColor,
    bool isDark,
    LoginController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email or Username',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.grey[300] : Colors.black87,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller.emailController,
          decoration: InputDecoration(
            hintText: 'Enter your Email',
            hintStyle: TextStyle(
              color: isDark ? Colors.grey[600] : Colors.grey[400],
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            filled: isDark,
            fillColor: isDark ? Colors.grey[800] : Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: themeColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Column passwordSection(
    Color themeColor,
    bool isDark,
    LoginController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.grey[300] : Colors.black87,
          ),
        ),

        const SizedBox(height: 8),

        Obx(
          () => TextFormField(
            controller: controller.passwordController,
            obscureText: controller.isObscurePassword.value,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: TextStyle(
                color: isDark ? Colors.grey[600] : Colors.grey[400],
                fontSize: 14,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              filled: isDark,
              fillColor: isDark ? Colors.grey[800] : Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: themeColor, width: 2),
              ),

              // Eye icon to toggle password visibility
              suffixIcon: IconButton(
                onPressed: controller.togglePasswordVisiblity,
                icon: Icon(
                  controller.isObscurePassword.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  SizedBox loginButton(Color themeColor, LoginController controller) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Obx(
        () => ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.loginUser,
          style: ElevatedButton.styleFrom(
            backgroundColor: themeColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 0,
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Row(
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
    );
  }

  Row dividerSection(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Divider(color: isDark ? Colors.grey[800] : Colors.grey[300]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'OR',
            style: TextStyle(
              color: isDark ? Colors.grey[600] : Colors.grey[500],
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: isDark ? Colors.grey[800] : Colors.grey[300]),
        ),
      ],
    );
  }

  RichText privacyAndTerms(Color themeColor, bool isDark) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[600],
          fontSize: 10,
          height: 1.5,
        ),
        children: [
          const TextSpan(text: 'By signing up, you agree to our '),
          TextSpan(
            text: 'Terms of Service',
            style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.toNamed('/terms'),
          ),
          const TextSpan(text: ' and\n'),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()
              ..onTap = () => Get.toNamed('/privacy'),
          ),
        ],
      ),
    );
  }

  Row footerSection(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.shield_outlined,
          color: isDark ? Colors.grey[600] : Colors.grey[400],
          size: 16,
        ),
        const SizedBox(width: 6),
        Text(
          'Secure Login Powered by HunarGah',
          style: TextStyle(color: Colors.grey[500], fontSize: 11),
        ),
      ],
    );
  }

  Row noAccount(Color themeColor, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
        GestureDetector(
          onTap: () => Get.offNamed('/signup'),
          child: Text(
            "SignUp",
            style: TextStyle(
              color: themeColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
