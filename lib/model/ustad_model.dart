import 'package:cloud_firestore/cloud_firestore.dart';

class UstadModel {
  final String id;
  final String username;
  final String skillTitle;
  final String rating;
  final String reviewsCount;
  final String? profileImageUrl;

  final String headline;
  final String bio;
  final String coverUrl;
  final String followerCount;
  final String videoCount;
  final List<String> tags;

  UstadModel({
    required this.id,
    required this.username,
    required this.skillTitle,
    required this.rating,
    required this.reviewsCount,
    this.profileImageUrl,
    required this.headline,
    required this.bio,
    required this.coverUrl,
    required this.followerCount,
    required this.videoCount,
    required this.tags,
  });

  factory UstadModel.fromSnapshot(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>? ?? {};
    return UstadModel(
      id: snap.id,
      username: data['username'] ?? 'Unknown Ustad',
      skillTitle: data['skillTitle'] ?? 'Professional',
      rating: (data['rating'] ?? 5.0).toString(),
      reviewsCount: (data['reviewsCount'] ?? 0).toString(),
      profileImageUrl: data['profileImageUrl'],
      headline: data['headline'] ?? data['skillTitle'] ?? 'Expert Professional',
      bio: data['bio'] ?? 'No bio available.',
      coverUrl:
          data['coverUrl'] ??
          'https://images.unsplash.com/photo-1509391366360-2e959784a276?auto=format&fit=crop&w=800&q=80',
      followerCount: (data['followerCount'] ?? 0).toString(),
      videoCount: (data['videoCount'] ?? 0).toString(),
      tags: List<String>.from(data['tags'] ?? []),
    );
  }
}
