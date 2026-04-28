import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/screens/viewmodels/video_player_viewmodel.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatelessWidget {
  const VideoPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VideoController());
    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 1),

            Obx(
              () => controller.isInitialized.value
                  ? _buildVideoArea(controller, themeColor)
                  : Center(child: CircularProgressIndicator(color: themeColor)),
            ),

            _buildInteractiveSection(context, controller, themeColor, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoArea(VideoController controller, Color themeColor) {
    return GestureDetector(
      onTap: controller.toggleControls,
      child: AspectRatio(
        aspectRatio: controller.videoPlayerController.value.aspectRatio,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            VideoPlayer(controller.videoPlayerController),
            Obx(
              () => controller.showControls.value
                  ? _buildControlsOverlay(controller, themeColor)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlsOverlay(VideoController controller, Color themeColor) {
    return Container(
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _topRow(),
          _middleRow(controller, themeColor),
          _bottomRow(controller, themeColor),
        ],
      ),
    );
  }

  Widget _topRow() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lesson 4:\nHigh-Pressure Joint Welding',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Ustad Arshad Mehmood',
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ),
          _hdBadge(),
          const SizedBox(width: 12),
          const Icon(Icons.settings_outlined, color: Colors.white, size: 20),
        ],
      ),
    );
  }

  Widget _middleRow(VideoController controller, Color themeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.replay_10, color: Colors.white, size: 32),
          onPressed: controller.rewind10,
        ),
        const SizedBox(width: 24),
        GestureDetector(
          onTap: controller.togglePlay,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: themeColor,
              shape: BoxShape.circle,
            ),
            child: Obx(
              () => Icon(
                controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
        IconButton(
          icon: const Icon(Icons.forward_10, color: Colors.white, size: 32),
          onPressed: controller.forward10,
        ),
      ],
    );
  }

  Widget _bottomRow(VideoController controller, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
      child: Row(
        children: [
          Obx(
            () => Text(
              controller.formatDuration(controller.position.value),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: VideoProgressIndicator(
              controller.videoPlayerController,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: themeColor,
                bufferedColor: Colors.white24,
                backgroundColor: Colors.white12,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(width: 8),
          Obx(
            () => Text(
              controller.formatDuration(controller.duration.value),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveSection(
    BuildContext context,
    VideoController controller,
    Color themeColor,
    bool isDark,
  ) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _learningPill(themeColor),
            const SizedBox(height: 12),
            _experienceInfo(),
            const Spacer(),
            _quizCard(themeColor, isDark),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _quizCard(Color themeColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.help_outline,
            color: isDark ? Colors.white70 : Colors.black87,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Check!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ready for 2-minute quiz?',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.toNamed('/quiz'),
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Start',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _learningPill(Color themeColor) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    decoration: BoxDecoration(
      border: Border.all(color: themeColor.withValues(alpha: 0.5)),
      borderRadius: BorderRadius.circular(20),
      color: themeColor.withValues(alpha: 0.1),
    ),
    child: Text(
      'Interactive Learning Mode',
      style: TextStyle(
        color: themeColor,
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _hdBadge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.white54),
      borderRadius: BorderRadius.circular(4),
    ),
    child: const Text(
      'HD 1080p',
      style: TextStyle(
        color: Colors.white,
        fontSize: 8,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _experienceInfo() => Text(
    'Landscape view optimized for vertical learning.\nRotate your device for full experience.',
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.grey[500],
      fontSize: 11,
      fontStyle: FontStyle.italic,
      height: 1.5,
    ),
  );
}
