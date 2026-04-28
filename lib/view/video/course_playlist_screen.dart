import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/view/components/app_bar.dart';
import 'package:hunargah/model/lesson_model.dart';
import 'package:hunargah/viewmodels/course_playlist_viewmodel.dart';

class CoursePlaylistScreen extends StatelessWidget {
  const CoursePlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CoursePlaylistController());

    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      appBar: CustomAppBar(
        title: 'Basic Plumbing',
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : Colors.black,
            size: 20,
          ),
        ),
      ),
      bottomNavigationBar: _actionButtons(themeColor, isDark),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _videoPlayerPreview(themeColor),
            _courseInfo(isDark),
            Divider(
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              thickness: 1,
              height: 1,
            ),
            _instructorInfo(controller, themeColor, isDark),
            Divider(
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              thickness: 1,
              height: 1,
            ),
            _courseContentList(controller, themeColor, isDark),
          ],
        ),
      ),
    );
  }

  Widget _videoPlayerPreview(Color themeColor) {
    return Container(
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
          Container(color: Colors.black.withValues(alpha: 0.3)),
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
          _videoProgressOverlay(themeColor),
        ],
      ),
    );
  }

  Widget _videoProgressOverlay(Color themeColor) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(height: 3, color: themeColor),
                ),
                Expanded(
                  flex: 6,
                  child: Container(height: 3, color: Colors.white38),
                ),
              ],
            ),
            const SizedBox(height: 8),
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
    );
  }

  Widget _courseInfo(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mastering Pipe Repairs & Installation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star_border, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              const Text(
                '4.9',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Text(
                ' (2.4k)',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.people_outline, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              const Text(
                '12,500',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Text(
                ' Learner',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _instructorInfo(
    CoursePlaylistController controller,
    Color themeColor,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lead Instructor',
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
                Text(
                  'Ustad Ali Khan',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => OutlinedButton(
              onPressed: controller.toggleSubscribe,
              style: OutlinedButton.styleFrom(
                backgroundColor: controller.isSubscribed.value
                    ? themeColor
                    : Colors.transparent,
                side: BorderSide(color: themeColor.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                controller.isSubscribed.value ? 'Subscribed' : 'Subscribe',
                style: TextStyle(
                  color: controller.isSubscribed.value
                      ? Colors.white
                      : themeColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _courseContentList(
    CoursePlaylistController controller,
    Color themeColor,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Course Content',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Text(
                '6 Lessons . 2h 15m',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(
            () => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.lessons.length,
              itemBuilder: (context, index) {
                return _buildLessonItem(
                  controller.lessons[index],
                  themeColor,
                  isDark,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonItem(Lesson lesson, Color themeColor, bool isDark) {
    Color bgColor = isDark ? Colors.grey[900]! : Colors.grey[50]!;
    Color borderColor = isDark
        ? Colors.grey[800]!
        : Colors.black.withValues(alpha: 0.05);
    Color titleColor = isDark ? Colors.white70 : Colors.black87;
    Color statusColor = Colors.grey[500]!;
    IconData leadingIcon = Icons.lock_outline;
    Color iconColor = Colors.grey[400]!;
    double opacity = 1.0;

    if (lesson.state == LessonState.playing) {
      bgColor = themeColor.withValues(alpha: 0.08);
      borderColor = themeColor.withValues(alpha: 0.3);
      titleColor = themeColor;
      statusColor = themeColor;
      leadingIcon = Icons.play_circle_fill;
      iconColor = themeColor;
    } else if (lesson.state == LessonState.completed) {
      leadingIcon = Icons.check_circle_outline;
      iconColor = isDark ? Colors.green[400]! : Colors.black54;
    } else if (lesson.state == LessonState.locked) {
      opacity = 0.5;
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
          children: [
            Icon(leadingIcon, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lesson.statusText,
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
                      lesson.duration,
                      style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                    ),
                  ],
                ),
                if (lesson.state != LessonState.locked)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Colors.grey[400],
                    ),
                    onPressed: () => Get.toNamed('/video-player'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButtons(Color themeColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
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
          const SizedBox(height: 8),
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
    );
  }
}
