import 'package:flutter/material.dart';
import 'package:hunargah/components/app_bar.dart';

enum LessonState { completed, playing, upNext, locked }

class CoursePlaylistScreen extends StatefulWidget {
  const CoursePlaylistScreen({super.key});

  @override
  State<CoursePlaylistScreen> createState() => _CoursePlaylistScreenState();
}

class _CoursePlaylistScreenState extends State<CoursePlaylistScreen> {
  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Basic Plumbing',
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
      // Bottom navigation area for the action buttons
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 24,
          top: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Start Quiz Button
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero,
                ),
                child: const Text(
                  'Start Quiz',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Resume Lesson Button
            SizedBox(
              width: 160,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(
                  Icons.play_circle_outline,
                  color: Colors.white,
                  size: 20,
                ),
                label: const Text(
                  'Resume Lesson',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player
            Container(
              height: 220,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1509391366360-2e959784a276?auto=format&fit=crop&w=800&q=80',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Dark overlay
                  Container(color: Colors.black.withValues(alpha: 0.3)),
                  // Center Play Button
                  Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: themeColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  // Bottom Progress Area
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          // Progress Line
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Container(height: 3, color: themeColor),
                              ),
                              Expanded(
                                flex: 6,
                                child: Container(
                                  height: 3,
                                  color: Colors.white38,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Timestamps and setting
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '06:14/12:40',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '720p  1.0x',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // -- Course Info --
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mastering Pipe Repairs & Installation',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.star_border,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '4.9',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        ' (2.4k)',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.people_outline,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '12,500',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Learner',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(color: Colors.grey[200], thickness: 1, height: 1),

            // -- Instructor Info --
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=11',
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lead Instructor',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                        const Text(
                          'Ustad Ali Khan',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: themeColor.withValues(alpha: 0.5),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                      minimumSize: const Size(0, 32),
                    ),
                    child: Text(
                      'Subscribe',
                      style: TextStyle(
                        color: themeColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey[200], thickness: 1, height: 1),

            // -- Course Content List --
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Course Content',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '6 Lessons . 2h 15m',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // The Lessons
                  _buildLessonItem(
                    title: '1. Introduction to Plumbing Tools',
                    statusText: 'Completed',
                    time: '12:45',
                    state: LessonState.completed,
                  ),
                  _buildLessonItem(
                    title: '2. Understanding Water Pressure',
                    statusText: 'Now Playing',
                    time: '18:20',
                    state: LessonState.playing,
                  ),
                  _buildLessonItem(
                    title: '3. Fixing Common Leaky Pressure',
                    statusText: 'Up Next',
                    time: '25:10',
                    state: LessonState.upNext,
                  ),
                  _buildLessonItem(
                    title: '4. Pipe Materials: PVC vs Copper',
                    statusText: 'Unlock after Level 3',
                    time: '15:30',
                    state: LessonState.locked,
                  ),
                  _buildLessonItem(
                    title: '5. Kitchen Sink Installation',
                    statusText: 'Unlock after Level 4',
                    time: '32:00',
                    state: LessonState.locked,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Widget: Lesson List Items
  Widget _buildLessonItem({
    required String title,
    required String statusText,
    required String time,
    required LessonState state,
  }) {
    final themeColor = Theme.of(context).primaryColor;

    Color bgColor = Colors.grey[50]!;
    Color borderColor = Colors.black.withValues(alpha: 0.05);
    Color titleColor = Colors.black87;
    Color statusColor = Colors.grey[500]!;
    IconData leadingIcon = Icons.lock_outline;
    Color iconColor = Colors.grey[400]!;
    double opacity = 1.0;

    switch (state) {
      case LessonState.completed:
        leadingIcon = Icons.check_circle_outline;
        iconColor = Colors.black54;
        break;
      case LessonState.playing:
        bgColor = themeColor.withValues(alpha: 0.08);
        borderColor = themeColor.withValues(alpha: 0.3);
        titleColor = themeColor;
        statusColor = themeColor;
        leadingIcon = Icons.play_circle_fill;
        iconColor = themeColor;
        break;
      case LessonState.upNext:
        leadingIcon = Icons.play_circle_fill;
        iconColor = themeColor;
        break;
      case LessonState.locked:
        leadingIcon = Icons.lock_outline;
        opacity = 0.5;
        break;
    }

    return Opacity(
      opacity: opacity,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(leadingIcon, color: iconColor, size: 20),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: titleColor,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 10,
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, size: 10, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                if (state != LessonState.locked)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.grey[400],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
