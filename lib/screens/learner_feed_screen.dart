import 'package:flutter/material.dart';

class LearnerFeedScreen extends StatefulWidget {
  const LearnerFeedScreen({super.key});

  @override
  State<LearnerFeedScreen> createState() => _LearnerFeedScreenState();
}

class _LearnerFeedScreenState extends State<LearnerFeedScreen> {
  // Controls the vertical scrolling of videos
  final PageController _pageController = PageController();

  // Mock data to check different videos in feed
  final List<Map<String, dynamic>> _mockFeedData = [
    {
      'username': '@Ustad Ali',
      'title': 'Basics of Electric Circuit Repair ⚡',
      'description':
          'In this lesson, we will learn how to identify common circuit faults in home appliances.',
      'tags': '#Skills #Electrician',
      'audio': 'Ustad Ali • Original sound',
      'likes': '3.1M',
      'comments': '45.4K',
      'saves': '233.8K',
      'shares': '183.9K',
      'image': 'assets/images/onboarding/onboarding1.jpg',
    },
    {
      'username': '@Ustad Fatima',
      'title': 'Advanced Tailoring: Necklines ✂️',
      'description':
          'Master the art of creating perfect boat necks and V-necks for traditional wear.',
      'tags': '#Tailoring #Fashion #Skills',
      'audio': 'Fatima • sewing machine sounds',
      'likes': '1.2M',
      'comments': '12K',
      'saves': '95K',
      'shares': '40K',
      'image': 'assets/images/onboarding/onboarding3.jpg',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // -- The Vertical Scrolling Feed --
          verticalScrollingFeed(),

          // -- Top Floating App Bar --
          // Posiioned at the top of the content
          floatingAppBar(),
        ],
      ),
    );
  }

  PageView verticalScrollingFeed() {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: _mockFeedData.length,
      itemBuilder: (context, index) {
        return _buildFeedItem(_mockFeedData[index]);
      },
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

            const Icon(Icons.settings_outlined, color: Colors.white),
          ],
        ),
      ),
    );
  }

  // Reusable Widget: The individual video screen overlay
  Widget _buildFeedItem(Map<String, dynamic> data) {
    final themeColor = Theme.of(context).primaryColor;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(data['image'], fit: BoxFit.cover),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withValues(alpha: 0.8),
                Colors.black.withValues(alpha: 0.0),
                Colors.black.withValues(alpha: 0.0),
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
        ),

        rightActionButtons(themeColor, data),

        // -- Bottom Left Content --
        bottomLeftContent(data, themeColor),
      ],
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
              children: [profileAvatar(), addSign_border(themeColor)],
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

  Positioned addSign_border(Color themeColor) {
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
