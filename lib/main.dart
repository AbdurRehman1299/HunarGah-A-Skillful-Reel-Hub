import 'package:flutter/material.dart';

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
      // home: SplashScreen(),

      // Define the all routes
      routes: {
        // '/login': (context) => const LoginScreen(),
      },

      // Set theme to declare color one time
      theme: ThemeData(
        primaryColor: const Color(0xFF00897B), // Learner theme: Teal Green
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00897B)),
        useMaterial3: true,
      ),
    );
  }
}
