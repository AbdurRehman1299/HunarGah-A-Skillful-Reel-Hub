import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  final bool _showControls = true;

  @override
  void initState() {
    super.initState();
    // Initialize the video player with a sample video for now
    _controller =
        VideoPlayerController.networkUrl(
            Uri.parse(
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
            ),
          )
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized
            setState(() {});
          });

    // Add listener to update the UI (progress bar) as the video plays
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Function to format the video duration
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  // Toggle Play and Pause Button
  void _togglePlay() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  // Skip forward 10 seconds
  void _forward10() {
    final currentPosition = _controller.value.position;
    _controller.seekTo(currentPosition + const Duration(seconds: 10));
  }

  // Rewind 10 seconds
  void _rewind10() {
    final currentPosition = _controller.value.position;
    _controller.seekTo(currentPosition - const Duration(seconds: 10));
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 1),

            // -- Video Player --
            if (_controller.value.isInitialized)
              videoControllers()
            else
              Center(child: CircularProgressIndicator(color: themeColor)),

            // -- Interactive Text & Quiz Card --
            interactiveTextAndQuizCard(themeColor),
          ],
        ),
      ),
    );
  }

  Expanded interactiveTextAndQuizCard(Color themeColor) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Interactive Learning Mode Pill
            interactiveLearningPill(themeColor),

            const SizedBox(height: 12),
            // Subtitle
            experienceInfo(),

            const Spacer(),

            // Quiz Card
            quizCard(themeColor),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Container interactiveLearningPill(Color themeColor) {
    return Container(
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
  }

  Container quizCard(Color themeColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.help_outline, color: Colors.black87, size: 28),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick Check!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Ready for 2-minute quiz?',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          startButton(themeColor),
        ],
      ),
    );
  }

  ElevatedButton startButton(Color themeColor) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: themeColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: const Text(
        'Start',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Text experienceInfo() {
    return Text(
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

  GestureDetector videoControllers() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showControls != _showControls;
        });
      },
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // The actual video
            VideoPlayer(_controller),

            // The Custom UI Overlay
            if (_showControls) _buildControlsOverlay(),
          ],
        ),
      ),
    );
  }

  // Reusable Widget: Custom UI Controller Overlay
  Widget _buildControlsOverlay() {
    final themeColor = Theme.of(context).primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
      ), // Darken video for readable text
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: Back, Title, Settings
          controlsTopRow(),

          // Middle Row: Play, Pause, Skip Controls
          controlsMiddleRow(themeColor),

          // Bottom Row: Progress Bar & TimeStamps
          controlsBottomRow(themeColor),
        ],
      ),
    );
  }

  Padding controlsBottomRow(Color themeColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
      child: Row(
        children: [
          Text(
            _formatDuration(_controller.value.position),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: VideoProgressIndicator(
              _controller,
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

          Text(
            _formatDuration(_controller.value.duration),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Row controlsMiddleRow(Color themeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.replay_10, color: Colors.white, size: 32),
          onPressed: _rewind10,
        ),

        const SizedBox(width: 24),

        GestureDetector(
          onTap: _togglePlay,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: themeColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),

        const SizedBox(width: 24),

        IconButton(
          icon: Icon(Icons.forward_10, color: Colors.white, size: 32),
          onPressed: _forward10,
        ),
      ],
    );
  }

  Padding controlsTopRow() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 18,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lesson 4:\nHigh-Pressue Joint Welding',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Ustad Arshad Mehmood',
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ),
          Container(
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
          ),

          const SizedBox(width: 12),

          const Icon(Icons.settings_outlined, color: Colors.white, size: 20),
        ],
      ),
    );
  }
}
