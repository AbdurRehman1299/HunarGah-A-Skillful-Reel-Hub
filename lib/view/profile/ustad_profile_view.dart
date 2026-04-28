import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/view/components/app_bar.dart';
import 'package:hunargah/model/ustad_model.dart';
import 'package:hunargah/viewmodels/ustad_profile_viewmodel.dart';

class UstadProfileScreen extends StatelessWidget {
  final String ustadId;

  const UstadProfileScreen({super.key, required this.ustadId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      UstadProfileController(ustadId: ustadId),
      tag: ustadId,
    );

    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (controller.isLoadingProfile.value) {
        return Scaffold(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          body: Center(child: CircularProgressIndicator(color: themeColor)),
        );
      }

      if (controller.ustad.value == null) {
        return Scaffold(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          body: Center(
            child: Text(
              "Ustad not found",
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
          ),
        );
      }

      final UstadModel ustad = controller.ustad.value!;

      return Scaffold(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        appBar: CustomAppBar(
          title: 'Ustad Profile',
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: isDark ? Colors.white : Colors.black,
              size: 20,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.share_outlined,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerSection(themeColor, ustad, controller, isDark),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ustadInfo(themeColor, ustad.username, isDark),
                    const SizedBox(height: 4),

                    Text(
                      ustad.headline,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      ustad.bio,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    tagSection(ustad.tags, themeColor, isDark),
                    const SizedBox(height: 24),

                    statsBox(ustad, isDark),
                    const SizedBox(height: 32),

                    publishedLesson(themeColor, isDark),
                    const SizedBox(height: 16),

                    videoGrid(controller, isDark),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget videoGrid(UstadProfileController controller, bool isDark) {
    if (controller.isLoadingVideos.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.videosList.isEmpty) {
      return Center(
        child: Text(
          "No videos posted yet.",
          style: TextStyle(color: isDark ? Colors.grey[400] : Colors.black87),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: controller.videosList.length,
      itemBuilder: (context, index) {
        final video = controller.videosList[index];
        return _buildVideoThumbnail(context, video);
      },
    );
  }

  Row publishedLesson(Color themeColor, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Published Lessons',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
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

  Container statsBox(UstadModel ustad, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isDark ? Colors.grey[800] : Colors.transparent,
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(ustad.followerCount, 'LEARNER', isDark),
            VerticalDivider(
              color: isDark ? Colors.grey[700] : Colors.grey[300],
              thickness: 1,
              width: 1,
            ),
            _buildStatItem(ustad.videoCount, 'LESSONS', isDark),
            VerticalDivider(
              color: isDark ? Colors.grey[700] : Colors.grey[300],
              thickness: 1,
              width: 1,
            ),
            _buildStatItem(ustad.rating, 'RATING', isDark),
          ],
        ),
      ),
    );
  }

  Wrap tagSection(List<String> tags, Color themeColor, bool isDark) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) => _buildTag(tag, themeColor, isDark)).toList(),
    );
  }

  Row ustadInfo(Color themeColor, String name, bool isDark) {
    return Row(
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(width: 4),
        Icon(Icons.verified, color: themeColor, size: 18),
      ],
    );
  }

  SizedBox headerSection(
    Color themeColor,
    UstadModel ustad,
    UstadProfileController controller,
    bool isDark,
  ) {
    return SizedBox(
      height: 210,
      child: Stack(
        children: [
          coverImage(ustad),
          profilePicture(controller, isDark),
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

  Positioned profilePicture(UstadProfileController controller, bool isDark) {
    return Positioned(
      top: 100,
      left: 24,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          radius: 40,
          backgroundColor: isDark ? Colors.grey[800] : Colors.grey,
          backgroundImage: controller.getProfileImage(),
        ),
      ),
    );
  }

  Container coverImage(UstadModel ustad) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(ustad.coverUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color themeColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
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

  Widget _buildStatItem(String value, String label, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? Colors.grey[400] : Colors.grey[500],
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

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
          children: [thumbnailGradient(), durationBadge(), titleAndViews()],
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
          const Text(
            'Modern Door',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Row(
            children: const [
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
