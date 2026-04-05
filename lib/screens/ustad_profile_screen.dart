import 'package:flutter/material.dart';
import 'package:hunargah/components/app_bar.dart';

class UstadProfileScreen extends StatefulWidget {
  const UstadProfileScreen({super.key});

  @override
  State<UstadProfileScreen> createState() => _UstadProfileScreenState();
}

class _UstadProfileScreenState extends State<UstadProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Ustad Profile',
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
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
            headerSection(themeColor),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -- Ustad Info --
                  ustadInfo(themeColor),

                  const SizedBox(height: 4),

                  Text(
                    'Expert AC Technician',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),

                  const SizedBox(height: 16),

                  // Bio Description
                  Text(
                    'Helping over 50,000 learners master the art of woodworking and furniture design with 20+ years of industrial experience.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // -- TAGS --
                  tagSection(),

                  const SizedBox(height: 24),

                  // -- Stats Box --
                  statsBox(),

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
  }

  GridView videoGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.85, // Adjusts height vs width of thumbnails
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return _buildVideoThumbnail();
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

  Container statsBox() {
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
            _buildStatItem('54K', 'LEARNER'),
            VerticalDivider(color: Colors.grey[300], thickness: 1, width: 1),
            _buildStatItem('128', 'LESSONS'),
            VerticalDivider(color: Colors.grey[300], thickness: 1, width: 1),
            _buildStatItem('4.9', 'RATING'),
          ],
        ),
      ),
    );
  }

  Wrap tagSection() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildTag('Carpentry'),
        _buildTag('Design'),
        _buildTag('Home Decor'),
      ],
    );
  }

  Row ustadInfo(Color themeColor) {
    return Row(
      children: [
        const Text(
          'Ustad Ali Raza',
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

  SizedBox headerSection(Color themeColor) {
    return SizedBox(
      height: 210,
      child: Stack(
        children: [
          // Cover Image
          coverImage(),

          // Profile Picture
          profilePicture(),

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

  Positioned profilePicture() {
    return Positioned(
      top: 100, // Pushes it down to overlap the bottom edge of cover image
      left: 24,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
        ),
      ),
    );
  }

  Container coverImage() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
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
  Widget _buildVideoThumbnail() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/course-playlist'),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: const DecorationImage(
            image: NetworkImage(
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
