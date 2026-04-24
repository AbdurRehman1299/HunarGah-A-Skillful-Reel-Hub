import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hunargah/database/firebase_service.dart';
import 'package:hunargah/screens/utils/route_observer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LearnerFeedScreen extends StatefulWidget {
  final bool isActive;

  const LearnerFeedScreen({super.key, required this.isActive});

  @override
  State<LearnerFeedScreen> createState() => _LearnerFeedScreenState();
}

class _LearnerFeedScreenState extends State<LearnerFeedScreen> {
  // Controls the vertical scrolling of videos
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // -- The Vertical Scrolling Feed --
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseService().getVideosStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: themeColor),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'No videos available yet. Check back later!',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                );
              }

              final video = snapshot.data!.docs;

              return PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: video.length,
                itemBuilder: (context, index) {
                  final videoData = video[index].data() as Map<String, dynamic>;
                  final videoId = video[index].id;

                  return VideoFeedItem(
                    videoData: videoData,
                    videoId: videoId,
                    isTabActive: widget.isActive,
                  );
                },
              );
            },
          ),

          // -- Top Floating App Bar --
          // Posiioned at the top of the content
          floatingAppBar(),
        ],
      ),
    );
  }

  SafeArea floatingAppBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Row(
              children: [
                Text(
                  'Following',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(width: 4),

                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00897B),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
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
              onPressed: () {
                Navigator.of(context).pushNamed('/settings');
              },
              icon: const Icon(Icons.settings_outlined, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Positioned bottomLeftContent(Map<String, dynamic> data, Color themeColor) {
    return Positioned(
      left: 16,
      bottom: 20,
      right: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              videoUsername(data),

              const SizedBox(width: 8),

              subscribeButton(themeColor),
            ],
          ),

          const SizedBox(height: 8),

          videoTitle(data),

          const SizedBox(height: 4),

          videoDescription(data),

          const SizedBox(height: 4),

          videoTags(data),

          const SizedBox(height: 12),

          // -- Audio Track Info --
          audioTrack(data),
        ],
      ),
    );
  }

  Text videoUsername(Map<String, dynamic> data) {
    return Text(
      data['username'],
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Row audioTrack(Map<String, dynamic> data) {
    return Row(
      children: [
        const Icon(Icons.music_note, color: Colors.white, size: 16),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: Text(
            data['audio'],
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ),
      ],
    );
  }

  Text videoTags(Map<String, dynamic> data) {
    return Text(
      data['tags'],
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    );
  }

  Text videoDescription(Map<String, dynamic> data) {
    return Text(
      data['description'],
      style: const TextStyle(color: Colors.white70, fontSize: 13),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Text videoTitle(Map<String, dynamic> data) {
    return Text(
      data['title'],
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    );
  }

  Container subscribeButton(Color themeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: themeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Subscribe',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Positioned rightActionButtons(Color themeColor, Map<String, dynamic> data) {
    return Positioned(
      right: 12,
      bottom: 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 60,
            width: 50,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [profileAvatar(), addSignBorder(themeColor)],
            ),
          ),

          const SizedBox(height: 20),

          _buildActionIcon(Icons.favorite, data['likes']),
          _buildActionIcon(Icons.chat_bubble_rounded, data['comments']),
          _buildActionIcon(Icons.bookmark, data['saves']),
          _buildActionIcon(Icons.reply, data['shares'], isShare: true),
        ],
      ),
    );
  }

  Positioned addSignBorder(Color themeColor) {
    return Positioned(
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(color: themeColor, shape: BoxShape.circle),
        child: const Icon(Icons.add, color: Colors.white, size: 14),
      ),
    );
  }

  CircleAvatar profileAvatar() {
    return const CircleAvatar(
      radius: 24,
      backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
    );
  }

  // Helper Widget for the right side icons
  Widget _buildActionIcon(IconData icon, String label, {bool isShare = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          iconFaceTurn(isShare, icon),

          const SizedBox(height: 4),

          actionButtonsLabel(label),
        ],
      ),
    );
  }

  Text actionButtonsLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Transform iconFaceTurn(bool isShare, IconData icon) {
    return Transform(
      // Mirror the button to opposite face for matching with share button
      alignment: Alignment.center,
      transform: isShare ? Matrix4.rotationY(3.14159) : Matrix4.identity(),
      child: Icon(icon, color: Colors.white, size: 32),
    );
  }
}

class VideoFeedItem extends StatefulWidget {
  final Map<String, dynamic> videoData;
  final String videoId;
  final bool isTabActive;

  const VideoFeedItem({
    super.key,
    required this.videoData,
    required this.videoId,
    required this.isTabActive,
  });

  @override
  State<VideoFeedItem> createState() => _VideoFeedItemState();
}

class _VideoFeedItemState extends State<VideoFeedItem> with RouteAware {
  late VideoPlayerController _videoPlayerController;
  bool _isVideoInitialized = false;
  bool _isRouteActive = true;
  bool _isVisible = false;
  final TextEditingController _commentController = TextEditingController();
  final String? _currentUserId = FirebaseService().currentUserId;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didUpdateWidget(VideoFeedItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isTabActive != widget.isTabActive) {
      _updatePlayback();
    }
  }

  @override
  void didPushNext() {
    _isRouteActive = false;
    _updatePlayback();
  }

  @override
  void didPopNext() {
    _isRouteActive = true;
    _updatePlayback();
  }

  void _updatePlayback() {
    if (!mounted || !_isVideoInitialized) return;

    final shouldPlay = _isVisible && _isRouteActive && widget.isTabActive;

    if (shouldPlay) {
      _videoPlayerController.play();
    } else {
      _videoPlayerController.pause();
    }
  }

  void _initializeVideo() {
    // Load the video from the provided URL
    _videoPlayerController =
        VideoPlayerController.networkUrl(
            Uri.parse(widget.videoData['videoUrl']),
          )
          ..initialize().then((_) {
            if (mounted) {
              setState(() {
                _isVideoInitialized = true;
              });
              _videoPlayerController.setLooping(true);
              _updatePlayback();
            }
          });
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _videoPlayerController.pause();
    _videoPlayerController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _showComments() async {
    final themeColor = Theme.of(context).primaryColor;
    _videoPlayerController.pause();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              const SizedBox(height: 8),

              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Comments',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Divider(color: Colors.black26),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseService().getCommentsStream(widget.videoId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final docs = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, i) {
                        final comment = docs[i].data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(
                            comment['username'] ?? 'User',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 13,
                            ),
                          ),
                          subtitle: Text(
                            comment['text'] ?? '',
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: 'Add comment...',
                          hintStyle: TextStyle(color: Colors.black38),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        FirebaseService().addComment(
                          widget.videoId,
                          _commentController.text,
                        );
                        _commentController.clear();
                      },
                      icon: Icon(Icons.send, color: themeColor),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );

    if (mounted) {
      _videoPlayerController.play();
    }
  }

  void _showShareOptions() async {
    _videoPlayerController.pause();
    final themeColor = Theme.of(context).primaryColor;
    final String videoUrl = widget.videoData['videoUrl'] ?? '';
    final String videoTitle = widget.videoData['title'] ?? 'Check this out!';

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Share Video',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildShareOption(
                    icon: Icons.share,
                    label: 'Share',
                    color: themeColor,
                    onTap: () async {
                      Navigator.pop(context);
                      await SharePlus.instance.share(
                        ShareParams(
                          text: '$videoTitle\n$videoUrl',
                          subject: videoTitle,
                        ),
                      );
                    },
                  ),

                  _buildShareOption(
                    icon: Icons.link,
                    label: 'Copy Link',
                    color: Colors.blue,
                    onTap: () async {
                      Navigator.pop(context);
                      await Clipboard.setData(ClipboardData(text: videoUrl));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Link copied to clipboard!'),
                            backgroundColor: themeColor,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    },
                  ),

                  _buildShareOption(
                    icon: Icons.people,
                    label: 'Send To',
                    color: Colors.purple,
                    onTap: () {
                      Navigator.pop(context);
                      _showSendToFollower(videoUrl, videoTitle);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
    if (mounted) _updatePlayback();
  }

  void _showSendToFollower(String videoUrl, String videoTitle) async {
    _videoPlayerController.pause();
    final themeColor = Theme.of(context).primaryColor;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              const SizedBox(height: 8),

              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Send to',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              const Divider(color: Colors.black12),

              // -- Followers List from Firestore --
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseService().getFollowersStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(color: themeColor),
                      );
                    }

                    final followers = snapshot.data!.docs;

                    if (followers.isEmpty) {
                      return Center(
                        child: Text(
                          'No followers yet.',
                          style: TextStyle(color: Colors.black54),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: followers.length,
                      itemBuilder: (context, i) {
                        final follower =
                            followers[i].data() as Map<String, dynamic>;
                        final followerId = followers[i].id;

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              follower['photoUrl'] ??
                                  'https://i.pravatar.cc/150?img=$i',
                            ),
                          ),
                          title: Text(
                            follower['username'] ?? 'User',
                            style: const TextStyle(color: Colors.black87),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () async {
                              await FirebaseService().sendVideoToUser(
                                followerId,
                                videoUrl,
                                videoTitle,
                              );
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Sent to ${follower['username']}!',
                                    ),
                                    backgroundColor: themeColor,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Send',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
    if (mounted) _updatePlayback();
  }

  Future<void> _toggleLike() async {
    await FirebaseService().toggleLike(widget.videoId);
  }

  Future<void> _toggleSave() async {
    await FirebaseService().toggleSave(widget.videoId);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    final data = widget.videoData;

    final int likes = data['likes'] ?? 0;
    final int saves = data['saves'] ?? 0;
    final String likeCount = likes.toString();
    final String saveCount = saves.toString();
    final String commentCount = (data['commentCount'] ?? 0).toString();

    final List<dynamic> likedBy = data['likedBy'] ?? [];
    final List<dynamic> savedBy = data['savedBy'] ?? [];

    final bool isLiked =
        _currentUserId != null && likedBy.contains(_currentUserId);
    final isSaved = _currentUserId != null && savedBy.contains(_currentUserId);

    return VisibilityDetector(
      key: Key(widget.videoId),
      onVisibilityChanged: (visibilityInfo) {
        if (!mounted) return;

        _isVisible = visibilityInfo.visibleFraction >= 0.5;
        _updatePlayback();
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // -- Video Player --
          GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: () {
              // Play/Pause on tap
              setState(() {
                _videoPlayerController.value.isPlaying
                    ? _videoPlayerController.pause()
                    : _videoPlayerController.play();
              });
            },
            child: RepaintBoundary(
              child: Center(
                child: _isVideoInitialized
                    ? AspectRatio(
                        aspectRatio: _videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(_videoPlayerController),
                      )
                    : Center(
                        child: CircularProgressIndicator(color: themeColor),
                      ),
              ),
            ),
          ),

          // -- Play Icon Overlay when paused --
          if (!_videoPlayerController.value.isPlaying && _isVideoInitialized)
            const IgnorePointer(
              child: Center(
                child: Icon(Icons.play_arrow, color: Colors.white70, size: 64),
              ),
            ),

          // -- Bottom Gradient Overlay for Text Visibility --
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

          // -- Right Action Buttons --
          Positioned(
            right: 12,
            bottom: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Uploader Avatar
                SizedBox(
                  height: 60,
                  width: 50,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=11',
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () => {},
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: themeColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // -- Like Button --
                _buildActionButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.white,
                  label: likeCount,
                  onTap: _toggleLike,
                ),

                // -- Comment Button --
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: commentCount,
                  onTap: () => _showComments(),
                ),

                // -- Save Button --
                _buildActionButton(
                  icon: isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: isSaved ? Colors.amber : Colors.white,
                  label: saveCount,
                  onTap: _toggleSave,
                ),

                // -- Share Button --
                _buildActionButton(
                  icon: Icons.reply,
                  label: 'Share',
                  isShare: true,
                  onTap: () => _showShareOptions(),
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
                  data['username'] ?? '@Unknown',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data['title'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data['description'] ?? '',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  data['tags'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.music_note, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        data['audio'] ?? 'Original Audio',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
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

  // Reusable Widget: Build Action Buttons
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.white,
    bool isShare = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: onTap,
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

  // Reusable Widget: Share Option Tile
  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),

          const SizedBox(height: 8),

          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
