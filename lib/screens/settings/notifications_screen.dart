import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hunargah/components/app_bar.dart';
import 'package:hunargah/database/firebase_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';

  String _timeAgo(Timestamp? timestamp) {
    if (timestamp == null) return 'JUST NOW';

    final duration = DateTime.now().difference(timestamp.toDate());
    if (duration.inDays > 365) return "${(duration.inDays / 365).floor()} YRS AGO";
    if (duration.inDays > 30) return "${(duration.inDays / 30).floor()} MONTHS AGO";
    if (duration.inDays > 0) return "${(duration.inDays)} DAYS AGO";
    if (duration.inHours > 0) return "${(duration.inHours)} HRS AGO";
    if (duration.inMinutes > 0) return "${(duration.inMinutes)} MINS AGO";
    return 'JUST NOW';
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      appBar: CustomAppBar(
        title: 'Notification',
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : Colors.black, size: 20),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseService().markAllNotificationsRead();
            },
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
            const SizedBox(height: 10,),
            // -- Filter Chips --
            filterChips(),

            const SizedBox(height: 8),

            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseService().getNotificationStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator(color: themeColor,));
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error loading notifications.', style: TextStyle(color: isDark ? Colors.white : Colors.black)));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return footerSection(isDark);
                      }

                      var allDocs = snapshot.data!.docs;
                      if (_selectedFilter != 'All') {
                        allDocs = allDocs.where((doc) => doc['type'] == _selectedFilter).toList();
                      }

                      if (allDocs.isEmpty) {
                        return Center(child: Text("No $_selectedFilter notifications", style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600])));
                      }

                      final unreadDocs = allDocs.where((doc) => doc['isRead'] == false).toList();
                      final readDocs = allDocs.where((doc) => doc['isRead'] == true).toList();

                      return RefreshIndicator(
                        color: themeColor,
                        backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                        onRefresh: () async {
                          await Future.delayed(const Duration(seconds: 1));
                        },
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            children: [
                              // -- Recent Alerts Section --
                              if (unreadDocs.isNotEmpty) ...[
                                recentAlertSection(),
                                const SizedBox(height: 8),
                                ...unreadDocs.map((doc) => _buildNotificationFromDoc(doc, isDark, themeColor)),
                              ],
                        
                              if (unreadDocs.isNotEmpty && readDocs.isNotEmpty)
                                Divider(color: isDark ? Colors.grey[800] : Colors.grey[200], height: 32, thickness: 1),
                        
                              // -- Earlier Section --
                              if (readDocs.isNotEmpty) ...[
                                earlierSection(),
                                const SizedBox(height: 8),
                                ...readDocs.map((doc) => _buildNotificationFromDoc(doc, isDark, themeColor)),
                              ],
                        
                              const SizedBox(height: 40),
                              footerSection(isDark),
                              const SizedBox(height: 40),
                            ],
                          ),
                      );
                    }
                )
            ),
          ],
        ),
    );
  }

  // Reusable widget: Map Notification
  Widget _buildNotificationFromDoc(QueryDocumentSnapshot doc, bool isDark, Color themeColor) {
    final data = doc.data() as Map<String, dynamic>;

    return _buildNotificationItem(
      title: data['title'] ?? 'Notification',
      description: data['description'] ?? '',
      time: _timeAgo(data['timestamp'] as Timestamp?),
      isUnread: !(data['isRead'] ?? true),
      type: data['type'] ?? 'System',
      isDark: isDark,
      themeColor: themeColor,
    );
  }

  Center footerSection(bool isDark) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!, width: 1.5),
            ),
            child: Icon(Icons.check, color: isDark ? Colors.grey[500] : Colors.grey[400], size: 24),
          ),

          const SizedBox(height: 16),

          Text(
            'You\'re all caught up',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.grey[500] : Colors.grey[400],
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Check back later for new updates',
            style: TextStyle(fontSize: 11, color: isDark ? Colors.grey[600] : Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Padding earlierSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        'EARLIER',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Padding recentAlertSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        'RECENT ALERTS',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  SingleChildScrollView filterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          _buildFilterChip('All'),
          _buildFilterChip('Courses'),
          _buildFilterChip('Job Alert'),
          _buildFilterChip('System'),
        ],
      ),
    );
  }

  // Reusable Widget: Filter Chips
  Widget _buildFilterChip(String label) {
    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool isSelected = _selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? themeColor : (isDark ? Colors.grey[800] : Colors.grey[100]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : (isDark ? Colors.grey[300] : Colors.grey[700]),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // Reusable Widget: Notification List Item
  Widget _buildNotificationItem({
    required String title,
    required String description,
    required String time,
    required bool isUnread,
    required String type,
    required bool isDark,
    required Color themeColor,
  }) {
    final themeColor = Theme.of(context).primaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: isUnread ? themeColor.withValues(alpha: isDark ? 0.1 : 0.05) : Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          iconBox(themeColor, type, isDark),

          const SizedBox(width: 12),

          // Text Content
          notificationContent(title, isUnread, description, time, isDark),
        ],
      ),
    );
  }

  Expanded notificationContent(
    String title,
    bool isUnread,
    String description,
    String time,
      bool isDark,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              if (isUnread) ...[
                const SizedBox(width: 8),
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 4),

          Text(
            description,
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
                time,
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
    );
  }

  Container iconBox(Color themeColor, String type, bool isDark) {
    IconData iconData = Icons.notifications;
    if (type == 'Courses') iconData = Icons.menu_book;
    if (type == 'Job Alert') iconData = Icons.work_outline;
    if (type == 'System') iconData = Icons.settings;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDark ? themeColor.withValues(alpha: 0.2) : themeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, color: themeColor, size: 20), // Course Icon
    );
  }
}
