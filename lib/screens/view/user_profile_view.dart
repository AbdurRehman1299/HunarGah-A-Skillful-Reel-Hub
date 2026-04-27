import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hunargah/components/app_bar.dart';
import 'package:hunargah/database/firebase_service.dart';
import 'package:hunargah/screens/model/user_model.dart';
import 'package:hunargah/screens/viewmodels/user_profile_viewmodel.dart';
import 'package:share_plus/share_plus.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProfileController controller = Get.put(UserProfileController());
    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      appBar: CustomAppBar(
        title: 'Profile',
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: isDark ? Colors.white : Colors.black87,
            ),
            onPressed: () => Get.toNamed('/settings'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value || controller.user.value == null) {
          return Center(child: CircularProgressIndicator(color: themeColor));
        }

        final user = controller.user.value!;

        return RefreshIndicator(
          onRefresh: controller.loadUserData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _avatarAndStats(
                  user.profileImageUrl,
                  themeColor,
                  isDark,
                  user.uid,
                ),
                _profileBio(user.username, user.bio, isDark),
                const SizedBox(height: 20),
                _profileActionButtons(context, themeColor, user, isDark),
                const SizedBox(height: 20),
                _switchToCreator(themeColor, isDark, controller),
                const SizedBox(height: 24),
                _customTabs(controller, themeColor, isDark),
                Divider(
                  color: isDark ? Colors.grey[800] : Colors.grey[200],
                  height: 1,
                  thickness: 1,
                ),
                const SizedBox(height: 16),

                _selectedTabContent(controller, user.uid, themeColor, isDark),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      }),
    );
  }

  // --- UI Sub-Widgets ---

  Widget _selectedTabContent(
    UserProfileController controller,
    String uid,
    Color themeColor,
    bool isDark,
  ) {
    return controller.selectedTabIndex.value == 0
        ? _buildSavedVideosGrid(uid, isDark)
        : _buildCertificatesList(uid, themeColor, isDark);
  }

  Widget _avatarAndStats(
    String? imageUrl,
    Color themeColor,
    bool isDark,
    String uid,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        children: [
          _buildAvatar(imageUrl, themeColor),
          const SizedBox(width: 24),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLiveStatColumn(
                  stream: FirebaseService().getPostCountStream(uid),
                  label: 'Posts',
                  isDark: isDark,
                ),
                _buildLiveStatColumn(
                  stream: FirebaseService().getFollowerCountStream(uid),
                  label: 'Followers',
                  isDark: isDark,
                ),
                _buildLiveStatColumn(
                  stream: FirebaseService().getFollowingCountStream(uid),
                  label: 'Following',
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String? imageString, Color themeColor) {
    ImageProvider? imageProvider;
    if (imageString != null && imageString.isNotEmpty) {
      if (imageString.startsWith('http')) {
        imageProvider = NetworkImage(imageString);
      } else {
        try {
          imageProvider = MemoryImage(base64Decode(imageString));
        } catch (e) {
          debugPrint("Image Error: $e");
        }
      }
    }
    return CircleAvatar(
      radius: 40,
      backgroundColor: themeColor.withValues(alpha: 0.1),
      backgroundImage: imageProvider,
      child: imageProvider == null
          ? Icon(Icons.person, size: 40, color: themeColor)
          : null,
    );
  }

  Widget _buildLiveStatColumn({
    required Stream<int> stream,
    required String label,
    required bool isDark,
  }) {
    return StreamBuilder<int>(
      stream: stream,
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;
        final display = count >= 1000
            ? '${(count / 1000).toStringAsFixed(1)}k'
            : count.toString();
        return Column(
          children: [
            Text(
              display,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _profileBio(String name, String bio, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.verified, color: Colors.cyan[400], size: 18),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            bio,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white70 : Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          _buildTag('UI/UX Design', isDark),
        ],
      ),
    );
  }

  Widget _profileActionButtons(
    BuildContext context,
    Color themeColor,
    UserModel user,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => Get.toNamed('/edit-profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () => _showShareOption(context, user, isDark),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'Share Profile',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _switchToCreator(
    Color themeColor,
    bool isDark,
    UserProfileController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.bolt,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Switch to Creator',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    'Access analytics & monetization',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[500],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: controller.isCreatorMode.value,
              activeThumbColor: themeColor,
              onChanged: controller.toggleCreatorMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _customTabs(
    UserProfileController controller,
    Color themeColor,
    bool isDark,
  ) {
    return Row(
      children: [
        _buildTabItem(
          0,
          'Saved',
          Icons.bookmark_outline,
          controller,
          themeColor,
          isDark,
        ),
        _buildTabItem(
          1,
          'Certificates',
          Icons.workspace_premium_outlined,
          controller,
          themeColor,
          isDark,
        ),
      ],
    );
  }

  Widget _buildTabItem(
    int index,
    String title,
    IconData icon,
    UserProfileController controller,
    Color themeColor,
    bool isDark,
  ) {
    bool isSelected = controller.selectedTabIndex.value == index;
    final color = isSelected
        ? (isDark ? Colors.white : Colors.black87)
        : Colors.grey[500];

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? themeColor : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Methods ---

  Widget _buildTag(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.grey[300] : Colors.grey[800],
        ),
      ),
    );
  }

  void _showShareOption(BuildContext context, UserModel user, bool isDark) {
    final themeColor = Theme.of(context).primaryColor;
    final String profileLink = "hunargah.app/@${user.username}";
    final String shareMessage =
        "Check out ${user.username}'s profile on HunarGah: $profileLink";

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Share Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                // 1. Native System Share (Using SharePlus)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      SharePlus.instance.share(ShareParams(text: shareMessage));
                    },
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text("Send to Apps"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: profileLink));
                      Get.back();
                      Get.snackbar(
                        "Success",
                        "Link copied to clipboard!",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: themeColor,
                        colorText: Colors.white,
                      );
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text("Copy Link"),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: themeColor),
                      foregroundColor: themeColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedVideosGrid(String uid, bool isDark) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseService().getSavedVideosStream(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Text(
                'No saved videos yet.',
                style: TextStyle(
                  color: isDark ? Colors.grey[500] : Colors.grey,
                ),
              ),
            ),
          );
        }

        final videos = snapshot.data!.docs;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 24,
              childAspectRatio: 0.85,
            ),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index].data() as Map<String, dynamic>;
              return _buildVideoCard(video, isDark);
            },
          ),
        );
      },
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              image: video['thumbnailUrl'] != null
                  ? DecorationImage(
                      image: NetworkImage(video['thumbnailUrl']),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    color: Colors.white70,
                    size: 36,
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 10,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${(video['likedBy'] as List?)?.length ?? 0}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          video['title'] ?? 'Untitled',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: isDark ? Colors.white : Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          video['username'] ?? '',
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.grey[400] : Colors.grey[500],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildCertificatesList(String uid, Color themeColor, bool isDark) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseService().getCertificatesStream(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Text(
                'No certificates yet.',
                style: TextStyle(
                  color: isDark ? Colors.grey[500] : Colors.grey,
                ),
              ),
            ),
          );
        }

        final certs = snapshot.data!.docs;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: certs.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final cert = certs[index].data() as Map<String, dynamic>;
              return _buildCertificateCard(cert, themeColor, isDark);
            },
          ),
        );
      },
    );
  }

  Widget _buildCertificateCard(
    Map<String, dynamic> cert,
    Color themeColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: themeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: cert['imageUrl'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(cert['imageUrl'], fit: BoxFit.cover),
                  )
                : Icon(Icons.workspace_premium, color: themeColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cert['title'] ?? 'Certificate',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  cert['issuedBy'] ?? 'HunarGah',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  cert['date'] ?? '',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey[500] : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: themeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Verified',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: themeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
