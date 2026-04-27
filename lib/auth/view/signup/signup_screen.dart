import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/auth/viewmodel/signup_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController controller = Get.put(SignupController());

    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      // Use theme background color
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              logoSection(themeColor),
              const SizedBox(height: 12),
              logoText(themeColor),
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Join HunarGah and start learning practical skills today.',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // -- Full Name Section --
              _buildTextField(
                context: context, // Fixed: Pass as named parameter
                controller: controller.nameController,
                label: 'Full Name',
                hint: 'Enter your name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),

              // -- Email Section --
              _buildTextField(
                context: context, // Fixed: Pass as named parameter
                controller: controller.emailController,
                label: 'Email Address',
                hint: 'Enter your email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              passwordSection(context, controller, themeColor, isDark),
              const SizedBox(height: 16),

              confirmPasswordSection(context, controller, themeColor, isDark),
              const SizedBox(height: 32),

              signupButton(controller, themeColor),
              const SizedBox(height: 16),

              // Fixed: Ensure method receives isDark
              guestButton(context, isDark),
              const SizedBox(height: 16),
              dividerSection(isDark),
              const SizedBox(height: 16),
              alreadyAccount(themeColor, textColor),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Helper Components ---

  Widget alreadyAccount(Color themeColor, Color textColor) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Already have an account? ",
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
      ),
      GestureDetector(
        onTap: () => Get.offNamed('/login'),
        child: Text(
          "Login",
          style: TextStyle(
            color: themeColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );

  Widget dividerSection(bool isDark) => Row(
    children: [
      Expanded(
        child: Divider(color: isDark ? Colors.grey[800] : Colors.grey[300]),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'OR',
          style: TextStyle(
            color: Colors.grey[500],
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

  // Fixed: Added isDark parameter and updated to GetX navigation
  Widget guestButton(BuildContext context, bool isDark) {
    return TextButton(
      onPressed: () => Get.offNamed('/dashboard'),
      child: Text(
        'Continue as Guest',
        style: TextStyle(
          color: isDark ? Colors.white70 : Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget signupButton(SignupController controller, Color themeColor) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Obx(
        () => ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : controller.registerUser,
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
                      'Sign Up',
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

  Widget passwordSection(
    BuildContext context,
    SignupController controller,
    Color themeColor,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => TextFormField(
            controller: controller.passwordController,
            obscureText: controller.isObscurePassword.value,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: _inputDecoration(
              context: context,
              hint: 'Create a strong password',
              icon: Icons.lock_outline,
              themeColor: themeColor,
              isDark: isDark,
              suffix: IconButton(
                icon: Icon(
                  controller.isObscurePassword.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey[500],
                  size: 20,
                ),
                onPressed: controller.togglePassword,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget confirmPasswordSection(
    BuildContext context,
    SignupController controller,
    Color themeColor,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Password',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => TextFormField(
            controller: controller.confirmPasswordController,
            obscureText: controller.isObscureConfirmPassword.value,
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: _inputDecoration(
              context: context,
              hint: 'Re-enter your password',
              icon: Icons.lock_outline,
              themeColor: themeColor,
              isDark: isDark,
              suffix: IconButton(
                icon: Icon(
                  controller.isObscureConfirmPassword.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  size: 20,
                  color: Colors.grey[500],
                ),
                onPressed: controller.toggleConfirmPassword,
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required BuildContext context,
    required String hint,
    required IconData icon,
    required Color themeColor,
    required bool isDark,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: isDark ? Colors.grey[500] : Colors.grey[400],
        fontSize: 14,
      ),
      prefixIcon: Icon(icon, color: Colors.grey[500], size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
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
    );
  }

  Widget logoText(Color themeColor) => Text(
    'HunarGah',
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: themeColor,
      letterSpacing: 1.0,
    ),
  );

  Widget logoSection(Color themeColor) => Container(
    width: 80,
    height: 80,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: themeColor.withValues(alpha: 0.5)),
    ),
    child: Center(
      child: Image.asset(
        'assets/images/hunargah-logo.png',
        width: 55,
        height: 55,
      ),
    ),
  );

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          decoration: _inputDecoration(
            context: context,
            hint: hint,
            icon: icon,
            themeColor: Theme.of(context).primaryColor,
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}
