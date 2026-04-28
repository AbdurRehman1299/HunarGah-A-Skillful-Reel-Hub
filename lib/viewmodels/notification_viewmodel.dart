import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hunargah/database/firebase_service.dart';
import 'package:hunargah/model/notification_model.dart';

class NotificationsController extends GetxController {
  final RxString selectedFilter = 'All'.obs;

  Stream<List<NotificationModel>> get notificationStream {
    return FirebaseService().getNotificationStream().map((snapshot) {
      return snapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();
    });
  }

  void setFilter(String filter) => selectedFilter.value = filter;

  Future<void> markAllAsRead() async {
    await FirebaseService().markAllNotificationsRead();
  }

  String formatTimeAgo(Timestamp? timestamp) {
    if (timestamp == null) return 'JUST NOW';
    final duration = DateTime.now().difference(timestamp.toDate());

    if (duration.inDays > 365) {
      return "${(duration.inDays / 365).floor()} YRS AGO";
    }
    if (duration.inDays > 30) {
      return "${(duration.inDays / 30).floor()} MONTHS AGO";
    }
    if (duration.inDays > 0) return "${(duration.inDays)} DAYS AGO";
    if (duration.inHours > 0) return "${(duration.inHours)} HRS AGO";
    if (duration.inMinutes > 0) return "${(duration.inMinutes)} MINS AGO";
    return 'JUST NOW';
  }
}
