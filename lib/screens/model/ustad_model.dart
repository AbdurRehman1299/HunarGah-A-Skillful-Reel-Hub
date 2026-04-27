import 'package:cloud_firestore/cloud_firestore.dart';

class UstadModel {
  final String id;
  final String username;
  final String skillTitle;
  final String rating;
  final String reviewsCount;
  final String? profileImageUrl;

  UstadModel({
    required this.id,
    required this.username,
    required this.skillTitle,
    required this.rating,
    required this.reviewsCount,
    this.profileImageUrl,
  });

  factory UstadModel.fromSnapshot(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>? ?? {};
    return UstadModel(
      id: snap.id,
      username: data['username'] ?? 'Unknown Ustad',
      skillTitle: data['skillTitle'] ?? 'Professional',
      rating: (data['rating'] ?? 0.0).toString(),
      reviewsCount: (data['reviewsCount'] ?? 0).toString(),
      profileImageUrl: data['profileImageUrl'],
    );
  }
}
