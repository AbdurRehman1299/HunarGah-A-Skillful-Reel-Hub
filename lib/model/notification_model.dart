import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final Timestamp? timestamp;
  final bool isRead;
  final String type;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    this.timestamp,
    required this.isRead,
    required this.type,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      title: data['title'] ?? 'Notification',
      description: data['description'] ?? '',
      timestamp: data['timestamp'] as Timestamp?,
      isRead: data['isRead'] ?? false,
      type: data['type'] ?? 'System',
    );
  }
}
