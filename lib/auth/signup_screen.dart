import 'package:flutter/material.dart';
import 'package:hunargah/database/firebase_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controllers to grab the text user types
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // State to hide/show the password
  bool _obsecurePassword = true;
  bool _obsecureConfirmPassword = true;

  bool _isLoading = false;

  Future<void> _registerUser(
    String email,
    String password,
    String username,
  ) async {
    setState(() {
      _isLoading = true;
    });

    String? errorMessage = await FirebaseService().registerUser(
      email,
      password,
      username,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully! Please log in.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    // Always dispose the controllers to prevent memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // -- Logo Section --
              logoSection(themeColor),

              const SizedBox(height: 12),

              // -- Header --
              logoText(themeColor),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
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
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // -- Full Name Section --
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                hint: 'Enter your name',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 16),

              // -- Email Section --
              _buildTextField(
                controller: _emailController,
                label: 'Email Address',
                hint: 'Enter your email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              // -- Password Section --
              passwordSection(themeColor),

              const SizedBox(height: 16),

              // -- Confirm Password Section
              confirmPasswordSection(themeColor),

              const SizedBox(height: 32),

              // -- SignUp Button --
              signupButton(themeColor),

              const SizedBox(height: 16),

              // -- Continue as Guest --
              guestButton(context),

              const SizedBox(height: 16),

              dividerSection(),

              const SizedBox(height: 16),

              alreadyAccount(context, themeColor),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Row alreadyAccount(BuildContext context, Color themeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account? ",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
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

  TextButton guestButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/dashboard');
      },
      child: const Text(
        'Continue as Guest',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  SizedBox signupButton(Color themeColor) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (_isLoading) return;

          if (_nameController.text.isEmpty ||
              _emailController.text.isEmpty ||
              _passwordController.text.isEmpty ||
              _confirmPasswordController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please fill in all fields.'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          if (_passwordController.text != _confirmPasswordController.text) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Passwords do not match!'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          _registerUser(
            _emailController.text,
            _passwordController.text,
            _nameController.text,
          );
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
    );
  }

  Column passwordSection(Color themeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: _passwordController,
          obscureText: _obsecurePassword,
          decoration: InputDecoration(
            hintText: 'Create a strong password',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: Colors.grey[500],
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obsecurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[500],
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obsecurePassword = !_obsecurePassword;
                });
              },
            ),
            filled: true,
            fillColor: Colors.grey[50],
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

  Column confirmPasswordSection(Color themeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Confirm Password',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obsecureConfirmPassword,
          decoration: InputDecoration(
            hintText: 'Re-enter your password',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: Colors.grey[500],
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obsecureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey[500],
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obsecureConfirmPassword = !_obsecureConfirmPassword;
                });
              },
            ),
            filled: true,
            fillColor: Colors.grey[50],
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

  Text logoText(Color themeColor) {
    return Text(
      'HunarGah',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: themeColor,
        letterSpacing: 1.0,
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

  // Reusable Widget: Builds text field
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Icon(icon, color: Colors.grey[500], size: 20),
            filled: true,
            fillColor: Colors.grey[50],
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
              borderSide: BorderSide(color: Color(0xFF00897B), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
