import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/screens/model/video_model.dart';
import 'package:hunargah/screens/viewmodels/feed_viewmodel.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LearnerFeedScreen extends StatelessWidget {
  final bool isActive;
  const LearnerFeedScreen({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final FeedController feedController = Get.put(FeedController());

    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. The Clean Feed
          Obx(() {
            if (feedController.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(color: themeColor),
              );
            }
            if (feedController.videos.isEmpty) {
              return const Center(
                child: Text(
                  'No videos available.',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: feedController.videos.length,
              itemBuilder: (context, index) {
                return VideoFeedItem(
                  video: feedController.videos[index],
                  isTabActive: isActive,
                  isDark: isDark,
                );
              },
            );
          }),

          // Top App Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Text(
                    'Following',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'For You',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.toNamed('/settings'),
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoFeedItem extends StatelessWidget {
  final VideoModel video;
  final bool isTabActive;
  final bool isDark;

  const VideoFeedItem({
    super.key,
    required this.video,
    required this.isTabActive,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      VideoItemController(video: video),
      tag: video.id,
    );
    final themeColor = Theme.of(context).primaryColor;

    return VisibilityDetector(
      key: Key(video.id),
      onVisibilityChanged: (info) {
        bool isVisible = info.visibleFraction >= 0.5;
        controller.updatePlayback(isVisible && isTabActive);
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // -- Video Player --
          GestureDetector(
            onTap: controller.togglePlay,
            child: RepaintBoundary(
              child: Obx(
                () => controller.isInitialized.value
                    ? Center(
                        child: AspectRatio(
                          aspectRatio:
                              controller.videoController.value.aspectRatio,
                          child: VideoPlayer(controller.videoController),
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(color: themeColor),
                      ),
              ),
            ),
          ),

          // -- Play/Pause Icon --
          Obx(
            () => !controller.isPlaying.value && controller.isInitialized.value
                ? const IgnorePointer(
                    child: Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white70,
                        size: 64,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // -- Gradient Overlay --
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4],
                ),
              ),
            ),
          ),

          // -- Right Actions --
          Positioned(
            right: 12,
            bottom: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildAvatar(themeColor),
                const SizedBox(height: 20),
                Obx(
                  () => _buildActionIcon(
                    icon: controller.isLiked.value
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: controller.isLiked.value ? Colors.red : Colors.white,
                    label: controller.likeCount.value.toString(),
                    onTap: controller.toggleLike,
                  ),
                ),
                _buildActionIcon(
                  icon: Icons.chat_bubble_outline,
                  label: video.commentCount.toString(),
                  onTap: () =>
                      controller.showCommentOptions(themeColor, isDark),
                ),
                Obx(
                  () => _buildActionIcon(
                    icon: controller.isSaved.value
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: controller.isSaved.value
                        ? Colors.amber
                        : Colors.white,
                    label: controller.saveCount.value.toString(),
                    onTap: controller.toggleSave,
                  ),
                ),
                _buildActionIcon(
                  icon: Icons.reply,
                  label: 'Share',
                  isShare: true,
                  onTap: () => controller.showShareOptions(themeColor, isDark),
                ),
              ],
            ),
          ),

          // -- Bottom Left Content --
          Positioned(
            left: 16,
            bottom: 20,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  video.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  video.description,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  video.tags,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- UI Helpers ---
  Widget _buildAvatar(Color themeColor) {
    return SizedBox(
      height: 60,
      width: 50,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: themeColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.white,
    bool isShare = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          children: [
            Transform(
              alignment: Alignment.center,
              transform: isShare
                  ? Matrix4.rotationY(3.14159)
                  : Matrix4.identity(),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
