import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<int?> getUserOnboardingSteps() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return null;

    DocumentSnapshot userDoc = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();
    if (!userDoc.exists) return null;

    final data = userDoc.data() as Map<String, dynamic>?;
    return data?['onboardingStep'] ?? 0;
  }

  // Register the user on Firebase
  Future<String?> registerUser(
    String email,
    String password,
    String username,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(username.trim());

        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'username': username.trim(),
          'email': email.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'city': '',
          'onboardingStep': 0,
          'language': '',
          'skills': [],
          'profileImageUrl': '',
        });

        return null;
      }
      return 'Failed to create user.';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'An account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        return 'The email address is not valid.';
      }
      return 'An error occurred. Please try again.';
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }

  // Login the user in application
  Future<String?> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        return 'Invalid email or password. Please try again.';
      }
      return 'An error occurred. Please try again.';
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }

  // SignOut the user
  Future<void> signOutUser() async {
    try {
      await _auth.signOut();
    } catch (e) {
      return;
    }
  }

  // Update the onboardingSteps
  Future<String?> updateOnboardingStep(int step) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'onboardingStep': step,
        });
      }
      return null;
    } catch (e) {
      return 'Error saving progress: $e';
    }
  }

  // Save user's language
  Future<String?> saveUserLanguage(String language, int nextStep) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'language': language,
          'onboardingStep': nextStep,
        });
        return null;
      }
      return 'User not found. Please try again';
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }

  // Save user's skills
  Future<String?> saveUserSkills(List<String> skills, int nextStep) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'skills': skills,
          'onboardingStep': nextStep,
        });
        return null;
      }
      return 'User session expired. Please log in again';
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }

  // Save user's profile picture
  Future<String?> saveProfilePicture(File imageFile, int nextStep) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        List<int> imageBytes = await imageFile.readAsBytes();
        String base64Image = base64Encode(imageBytes);

        await _firestore.collection('users').doc(user.uid).update({
          'profileImageUrl': base64Image,
          'onboardingStep': nextStep,
        });

        return null;
      }
      return 'User session expired.';
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }
}
