import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  final String id;
  final String username;
  final String videoUrl;
  final String title;
  final String description;
  final String tags;
  final String audio;
  final int likes;
  final int saves;
  final int shares;
  final int commentCount;
  final List<String> likedBy;
  final List<String> savedBy;

  VideoModel({
    required this.id,
    required this.username,
    required this.videoUrl,
    required this.title,
    required this.description,
    required this.tags,
    required this.audio,
    required this.likes,
    required this.saves,
    required this.shares,
    required this.commentCount,
    required this.likedBy,
    required this.savedBy,
  });

  factory VideoModel.fromSnapshot(DocumentSnapshot snap) {
    var data = snap.data() as Map<String, dynamic>? ?? {};
    return VideoModel(
      id: snap.id,
      username: data['username'] ?? '@Unknown',
      videoUrl: data['videoUrl'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      tags: data['tags'] ?? '',
      audio: data['audio'] ?? 'Original Audio',
      likes: data['likes'] ?? 0,
      saves: data['saves'] ?? 0,
      shares: data['shares'] ?? 0,
      commentCount: data['commentCount'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
      savedBy: List<String>.from(data['savedBy'] ?? []),
    );
  }
}
