import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hunargah/components/app_bar.dart';
import 'package:hunargah/database/firebase_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // To toggle password visibility
  bool _obsecurePassword = true;

  bool _isLoading = false;

  Future<void> _loginUser(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    String? errorMessage = await FirebaseService().loginUser(email, password);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    Navigator.pop(context);

    if (errorMessage == null) {
      int? step = await FirebaseService().getUserOnboardingSteps();

      if (!mounted) return;

      if (step == 0 || step == null) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      } else if (step == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select your preferred language to continue.'),
          ),
        );
        Navigator.pushReplacementNamed(context, '/language');
      } else if (step == 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select your skills of interest to continue.'),
          ),
        );
        Navigator.pushReplacementNamed(context, '/skills');
      } else if (step == 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please upload a profile picture to continue.'),
          ),
        );
        Navigator.pushReplacementNamed(context, '/profile');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful! Redirecting to dashboard...'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
            // -- Logo Section --
            logoSection(themeColor),

            const SizedBox(height: 24),

            // -- Header Section --
            headerSection(),

            const SizedBox(height: 12),

            descriptionSection(),

            const SizedBox(height: 40),

            // -- Email/Username Field --
            emailSection(themeColor),

            const SizedBox(height: 20),

            // -- Password Field --
            passwordSection(themeColor),

            const SizedBox(height: 32),

            // -- Login Button --
            loginButton(themeColor),

            const SizedBox(height: 16),

            dividerSection(),

            const SizedBox(height: 16),

            // -- Move to SignUp --
            noAccount(context, themeColor),

            const SizedBox(height: 60),

            // -- Footer Section --
            footerSection(),

            const SizedBox(height: 16),

            // RichText for clickable colored links
            privacyAndTerms(themeColor),
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

  Text descriptionSection() {
    return const Text(
      "Master new skills with Pakistan's best\nUstads. Enter your details to continue.",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.5),
    );
  }

  Text headerSection() {
    return const Text(
      'Welcome to HunarGah',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
      ),
    );
  }

  Column emailSection(Color themeColor) {
    return Column(
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
          controller: _emailController,
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
    );
  }

  Column passwordSection(Color themeColor) {
    return Column(
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
          controller: _passwordController,
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
                _obsecurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[500],
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  SizedBox loginButton(Color themeColor) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (_isLoading) return;

          if (_emailController.text.isNotEmpty &&
              _passwordController.text.isNotEmpty) {
            _loginUser(_emailController.text, _passwordController.text);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enter both email and password.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 0,
        ),
        child: _isLoading
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
    );
  }

  Row dividerSection() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
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
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  RichText privacyAndTerms(Color themeColor) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(color: Colors.grey[600], fontSize: 10, height: 1.5),
        children: [
          const TextSpan(text: 'By signing up, you agree to our '),
          TextSpan(
            text: 'Terms of Service',
            style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushNamed(context, '/terms');
              },
          ),
          const TextSpan(text: ' and\n'),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushNamed(context, '/privacy');
              },
          ),
        ],
      ),
    );
  }

  Row footerSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.shield_outlined, color: Colors.grey[400], size: 16),
        const SizedBox(width: 6),
        Text(
          'Secure Login Powered by HunarGah',
          style: TextStyle(color: Colors.grey[500], fontSize: 11),
        ),
      ],
    );
  }

  Row noAccount(BuildContext context, Color themeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/signup');
          },
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
