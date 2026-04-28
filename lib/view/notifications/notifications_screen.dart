import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/view/components/app_bar.dart';
import 'package:hunargah/model/notification_model.dart';
import 'package:hunargah/viewmodels/notification_viewmodel.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController());

    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      appBar: CustomAppBar(
        title: 'Notification',
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : Colors.black,
            size: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: controller.markAllAsRead,
            child: Text(
              'Mark all read',
              style: TextStyle(
                color: themeColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildFilterChips(controller, themeColor, isDark),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<List<NotificationModel>>(
              stream: controller.notificationStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: themeColor),
                  );
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return _buildEmptyState(isDark);
                }

                return Obx(() {
                  var list = snapshot.data!;
                  if (controller.selectedFilter.value != 'All') {
                    list = list
                        .where((n) => n.type == controller.selectedFilter.value)
                        .toList();
                  }

                  if (list.isEmpty) {
                    return Center(
                      child: Text(
                        "No ${controller.selectedFilter.value} notifications",
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    );
                  }

                  final unread = list.where((n) => !n.isRead).toList();
                  final read = list.where((n) => n.isRead).toList();

                  return RefreshIndicator(
                    color: themeColor,
                    onRefresh: () async =>
                        await Future.delayed(const Duration(seconds: 1)),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        if (unread.isNotEmpty) ...[
                          _sectionHeader('RECENT ALERTS'),
                          ...unread.map(
                            (n) => _notificationItem(
                              n,
                              controller,
                              isDark,
                              themeColor,
                            ),
                          ),
                        ],
                        if (unread.isNotEmpty && read.isNotEmpty)
                          Divider(
                            color: isDark ? Colors.grey[800] : Colors.grey[200],
                            height: 32,
                          ),
                        if (read.isNotEmpty) ...[
                          _sectionHeader('EARLIER'),
                          ...read.map(
                            (n) => _notificationItem(
                              n,
                              controller,
                              isDark,
                              themeColor,
                            ),
                          ),
                        ],
                        const SizedBox(height: 40),
                        _buildEmptyState(isDark),
                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(
    NotificationsController controller,
    Color themeColor,
    bool isDark,
  ) {
    final filters = ['All', 'Courses', 'Job Alert', 'System'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: filters.map((label) {
          return Obx(() {
            bool isSelected = controller.selectedFilter.value == label;
            return GestureDetector(
              onTap: () => controller.setFilter(label),
              child: Container(
                margin: const EdgeInsets.only(right: 8.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? themeColor
                      : (isDark ? Colors.grey[800] : Colors.grey[100]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.grey[300] : Colors.grey[700]),
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          });
        }).toList(),
      ),
    );
  }

  Widget _notificationItem(
    NotificationModel notification,
    NotificationsController controller,
    bool isDark,
    Color themeColor,
  ) {
    IconData iconData = Icons.notifications;
    if (notification.type == 'Courses') iconData = Icons.menu_book;
    if (notification.type == 'Job Alert') iconData = Icons.work_outline;
    if (notification.type == 'System') iconData = Icons.settings;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: !notification.isRead
          ? themeColor.withValues(alpha: isDark ? 0.1 : 0.05)
          : Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark
                  ? themeColor.withValues(alpha: 0.2)
                  : themeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(iconData, color: themeColor, size: 20),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      controller.formatTimeAgo(notification.timestamp),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.check,
              color: isDark ? Colors.grey[500] : Colors.grey[400],
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "You're all caught up",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.grey[500] : Colors.grey[400],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Check back later for new updates',
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
