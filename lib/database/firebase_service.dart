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
          'fullName': username.trim(),
          'bio': 'No bio yet.',
          'email': email.trim(),
          'createdAt': FieldValue.serverTimestamp(),
          'city': '',
          'onboardingStep': 0,
          'language': '',
          'skills': [],
          'profileImageUrl': '',
          'role': 'learner',
          'profession': 'student',
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

  // Fetch user's data
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get real-time Followers count
  Stream<int> getFollowerCountStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('followers')
        .snapshots()
        .map((snap) => snap.docs.length);
  }

  // Get real-time Following count
  Stream<int> getFollowingCountStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('following')
        .snapshots()
        .map((snap) => snap.size);
  }

  // Get real-time Post count
  Stream<int> getPostCountStream(String uid) {
    return _firestore
        .collection('videos')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snap) => snap.size);
  }

  // Fetch saved videos
  Stream<QuerySnapshot> getSavedVideosStream(String uid) {
    return _firestore
        .collection('videos')
        .where('savedBy', arrayContains: uid)
        .snapshots();
  }

  // Fetch certificates
  Stream<QuerySnapshot> getCertificatesStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('certificates')
        .orderBy('date', descending: true)
        .snapshots();
  }

  // -- Video Fetch Logic -- Start from here
  String? get currentUserId => _auth.currentUser?.uid;

  // Stream videos for feed
  Stream<QuerySnapshot> getVideosStream() {
    return _firestore.collection('videos').snapshots();
  }

  // Like video
  Future<void> toggleLike(String videoId) async {
    if (currentUserId == null) return;

    final videoRef = _firestore.collection('videos').doc(videoId);

    return _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(videoRef);

      List likedBy = List.from(snapshot.get('likedBy') ?? []);

      if (likedBy.contains(currentUserId)) {
        transaction.update(videoRef, {
          'likedBy': FieldValue.arrayRemove([currentUserId]),
          'likes': FieldValue.increment(-1),
        });
      } else {
        transaction.update(videoRef, {
          'likedBy': FieldValue.arrayUnion([currentUserId]),
          'likes': FieldValue.increment(1),
        });
      }
    });
  }

  // Add comment in video
  Future<void> addComment(String videoId, String commentText) async {
    if (currentUserId == null || commentText.trim().isEmpty) return;

    await _firestore
        .collection('videos')
        .doc(videoId)
        .collection('comments')
        .add({
          'uid': currentUserId,
          'text': commentText,
          'timestamp': FieldValue.serverTimestamp(),
          'username': _auth.currentUser?.displayName ?? 'User',
        });

    await _firestore.collection('videos').doc(videoId).update({
      'commentCount': FieldValue.increment(1),
    });
  }

  // Fetch comments
  Stream<QuerySnapshot> getCommentsStream(String videoId) {
    return _firestore
        .collection('videos')
        .doc(videoId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Save video
  Future<void> toggleSave(String videoId) async {
    if (currentUserId == null) return;

    final videoRef = _firestore.collection('videos').doc(videoId);

    return _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(videoRef);

      List savedBy = List.from(snapshot.get('savedBy') ?? []);

      if (savedBy.contains(currentUserId)) {
        transaction.update(videoRef, {
          'savedBy': FieldValue.arrayRemove([currentUserId]),
          'saves': FieldValue.increment(-1),
        });
      } else {
        transaction.update(videoRef, {
          'savedBy': FieldValue.arrayUnion([currentUserId]),
          'saves': FieldValue.increment(1),
        });
      }
    });
  }

  // Fetch user's followers to share
  Stream<QuerySnapshot> getFollowersStream() {
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('followers')
        .snapshots();
  }

  // Send link to specific user
  Future<void> sendVideoToUser(
    String toUserId,
    String videoUrl,
    String videoTitle,
  ) async {
    await _firestore
        .collection('users')
        .doc(toUserId)
        .collection('messages')
        .add({
          'fromUserId': currentUserId,
          'videoUrl': videoUrl,
          'videoTitle': videoTitle,
          'type': 'video_share',
          'timestamp': FieldValue.serverTimestamp(),
        });
  }

  // Explore Screen Section
  Stream<QuerySnapshot> getUstadsStream() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'ustad')
        .snapshots();
  }
}
