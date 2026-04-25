import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hunargah/components/app_bar.dart';
import 'package:hunargah/database/firebase_service.dart';

class UstadProfileScreen extends StatefulWidget {
  final String ustadId;

  const UstadProfileScreen({super.key, required this.ustadId});

  @override
  State<UstadProfileScreen> createState() => _UstadProfileScreenState();
}

class _UstadProfileScreenState extends State<UstadProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseService().getUserProfile(widget.ustadId),
      builder: (context, profileSnapshot) {
        if (profileSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!profileSnapshot.hasData || !profileSnapshot.data!.exists) {
          return const Scaffold(body: Center(child: Text("Ustad not found")));
        }

        final ustadData = profileSnapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: 'Ustad Profile',
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 20,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.share_outlined, color: Colors.black54),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert, color: Colors.black54),
              ),
            ],
          ),

          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -- Header Section (Cover Image + Profile Picture + Follow Button) --
                headerSection(themeColor, ustadData),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -- Ustad Info --
                      ustadInfo(
                        themeColor,
                        ustadData['username'] ?? 'HunarGah User',
                      ),

                      const SizedBox(height: 4),

                      Text(
                        ustadData['headline'] ?? 'Expert Professional',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),

                      const SizedBox(height: 16),

                      // Bio Description
                      Text(
                        ustadData['bio'] ?? 'No bio available.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // -- TAGS --
                      tagSection(ustadData['tags'] as List? ?? []),

                      const SizedBox(height: 24),

                      // -- Stats Box --
                      statsBox(ustadData),

                      const SizedBox(height: 32),

                      // -- Published Lesson --
                      publishedLesson(themeColor),

                      const SizedBox(height: 16),

                      // -- Video Grid --
                      videoGrid(),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget videoGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseService().getVideosByUserId(widget.ustadId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Center(child: Text("No videos posted yet."));
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.85, // Adjusts height vs width of thumbnails
          ),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final video = docs[index].data() as Map<String, dynamic>;
            return _buildVideoThumbnail(context, video);
          },
        );
      },
    );
  }

  Row publishedLesson(Color themeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Published Lessons',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          'View All',
          style: TextStyle(
            color: themeColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Container statsBox(Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IntrinsicHeight(
        // Allows vertical dividers to work
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem('${data['followerCount'] ?? 0}', 'LEARNER'),
            VerticalDivider(color: Colors.grey[300], thickness: 1, width: 1),
            _buildStatItem('${data['videoCount'] ?? 0}', 'LESSONS'),
            VerticalDivider(color: Colors.grey[300], thickness: 1, width: 1),
            _buildStatItem('${data['rating'] ?? '5.0'}', 'RATING'),
          ],
        ),
      ),
    );
  }

  Wrap tagSection(List tags) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) => _buildTag(tag.toString())).toList(),
    );
  }

  Row ustadInfo(Color themeColor, String name) {
    return Row(
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        const SizedBox(width: 4),

        Icon(Icons.verified, color: themeColor, size: 18),
      ],
    );
  }

  SizedBox headerSection(Color themeColor, Map<String, dynamic> data) {
    return SizedBox(
      height: 210,
      child: Stack(
        children: [
          // Cover Image
          coverImage(data),

          // Profile Picture
          profilePicture(data),

          // Follow Button
          followButton(themeColor),
        ],
      ),
    );
  }

  Positioned followButton(Color themeColor) {
    return Positioned(
      top: 155,
      right: 24,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 0,
          minimumSize: Size.zero,
        ),
        child: const Text(
          'Follow Ustad',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Positioned profilePicture(Map<String, dynamic> data) {
    String? imageString = data['profileImageUrl'];
    ImageProvider? imageProvider;

    if (imageString != null && imageString.isNotEmpty) {
      if (imageString.startsWith('http')) {
        // 1. If it's a normal web URL
        imageProvider = NetworkImage(imageString);
      } else {
        // 2. If it's a Base64 string (from your database)
        try {
          final String cleanBase64 = imageString.contains(',')
              ? imageString.split(',').last
              : imageString;
          imageProvider = MemoryImage(base64Decode(cleanBase64));
        } catch (e) {
          debugPrint('Error decoding base64 image: $e');
        }
      }
    }

    imageProvider ??= const NetworkImage('https://i.pravatar.cc/150?img=11');

    return Positioned(
      top: 100,
      left: 24,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: imageProvider,
        ),
      ),
    );
  }

  Container coverImage(Map<String, dynamic> data) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            data['coverUrl'] ??
                'https://images.unsplash.com/photo-1509391366360-2e959784a276?auto=format&fit=crop&w=800&q=80',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Reusable Widget: Tag Pills
  Widget _buildTag(String text) {
    final themeColor = Theme.of(context).primaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: themeColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: themeColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Reusable Widget: Stat Info
  Widget _buildStatItem(String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[500],
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // Reusable Widget: Video Thumbnail Card
  Widget _buildVideoThumbnail(
    BuildContext context,
    Map<String, dynamic> video,
  ) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/course-playlist', arguments: video),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(
              video['thumbnailUrl'] ??
                  'https://images.unsplash.com/photo-1509391366360-2e959784a276?auto=format&fit=crop&w=300&q=80',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Gradient to make text readable
            thumbnailGradient(),

            // Duration Badge
            durationBadge(),

            // Title & Views
            titleAndViews(),
          ],
        ),
      ),
    );
  }

  Positioned titleAndViews() {
    return Positioned(
      bottom: 8,
      left: 8,
      right: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Modern Door',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 2),

          Row(
            children: [
              Icon(Icons.play_arrow, color: Colors.white70, size: 10),

              SizedBox(height: 2),

              Text(
                '14.2k views',
                style: TextStyle(color: Colors.white70, fontSize: 8),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Positioned durationBadge() {
    return Positioned(
      top: 4,
      right: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          '12:45',
          style: TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Container thumbnailGradient() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withValues(alpha: 0.8),
            Colors.transparent,
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
