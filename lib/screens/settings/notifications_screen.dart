import 'package:flutter/material.dart';
import 'package:hunargah/components/app_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Notification',
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        ),
        actions: [
          TextButton(
            onPressed: () {},
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

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -- Filter Chips --
            filterChips(),

            const SizedBox(height: 16),

            // -- Recent Alerts Section --
            recentAlertSection(),

            const SizedBox(height: 8),

            _buildNotificationItem(
              title: 'New Course: Solar Panel Installation',
              description:
                  'Ustad Ali just launched a complete guide on off-grid solar setup. Start now',
              time: '2 MINS AGO',
              isUnread: true,
            ),
            _buildNotificationItem(
              title: 'New Course: Solar Panel Installation',
              description:
                  'Ustad Ali just launched a complete guide on off-grid solar setup. Start now',
              time: '2 MINS AGO',
              isUnread: true,
            ),

            Divider(color: Colors.grey[200], height: 32, thickness: 1),

            // -- Earlier Section --
            earlierSection(),

            const SizedBox(height: 8),

            _buildNotificationItem(
              title: 'New Course: Solar Panel Installation',
              description:
                  'Ustad Ali just launched a complete guide on off-grid solar setup. Start now',
              time: '2 MINS AGO',
              isUnread: false,
            ),
            _buildNotificationItem(
              title: 'New Course: Solar Panel Installation',
              description:
                  'Ustad Ali just launched a complete guide on off-grid solar setup. Start now',
              time: '2 MINS AGO',
              isUnread: false,
            ),
            _buildNotificationItem(
              title: 'New Course: Solar Panel Installation',
              description:
                  'Ustad Ali just launched a complete guide on off-grid solar setup. Start now',
              time: '2 MINS AGO',
              isUnread: false,
            ),

            const SizedBox(height: 40),

            // -- All Caught Up Footer --
            footerSection(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Center footerSection() {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!, width: 1.5),
            ),
            child: Icon(Icons.check, color: Colors.grey[400], size: 24),
          ),

          const SizedBox(height: 16),

          Text(
            'You\'re all caught up',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Check back later for new updates',
            style: TextStyle(fontSize: 11, color: Colors.grey[400]),
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
          color: isSelected ? themeColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
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
  }) {
    final themeColor = Theme.of(context).primaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: isUnread ? themeColor.withValues(alpha: 0.02) : Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          iconBox(themeColor),

          const SizedBox(width: 12),

          // Text Content
          notificationContent(title, isUnread, description, time),
        ],
      ),
    );
  }

  Expanded notificationContent(
    String title,
    bool isUnread,
    String description,
    String time,
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87,
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
              color: Colors.grey[600],
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

  Container iconBox(Color themeColor) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.menu_book, color: themeColor, size: 20), // Course Icon
    );
  }
}
