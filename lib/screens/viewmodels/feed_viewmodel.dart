import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/screens/model/video_model.dart';
import 'package:video_player/video_player.dart';
import 'package:hunargah/database/firebase_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedController extends GetxController {
  final RxList<VideoModel> videos = <VideoModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    videos.bindStream(
      FirebaseFirestore.instance
          .collection('videos')
          .snapshots()
          .map(
            (query) =>
                query.docs.map((doc) => VideoModel.fromSnapshot(doc)).toList(),
          ),
    );
    ever(videos, (_) => isLoading.value = false);
  }
}

class VideoItemController extends GetxController {
  final VideoModel video;
  VideoItemController({required this.video});

  late VideoPlayerController videoController;
  final commentTextController = TextEditingController();

  var isInitialized = false.obs;
  var isPlaying = false.obs;

  late RxBool isLiked;
  late RxBool isSaved;
  late RxInt likeCount;
  late RxInt saveCount;

  @override
  void onInit() {
    super.onInit();
    final userId = FirebaseService().currentUserId ?? '';

    isLiked = video.likedBy.contains(userId).obs;
    isSaved = video.savedBy.contains(userId).obs;
    likeCount = video.likes.obs;
    saveCount = video.saves.obs;

    _initializeVideo();
  }

  void _initializeVideo() async {
    videoController = VideoPlayerController.networkUrl(
      Uri.parse(video.videoUrl),
    );
    await videoController.initialize();
    videoController.setLooping(true);
    isInitialized.value = true;
  }

  void updatePlayback(bool shouldPlay) {
    if (!isInitialized.value) return;
    if (shouldPlay) {
      videoController.play();
      isPlaying.value = true;
    } else {
      videoController.pause();
      isPlaying.value = false;
    }
  }

  void togglePlay() {
    if (!isInitialized.value) return;
    isPlaying.value ? videoController.pause() : videoController.play();
    isPlaying.toggle();
  }

  Future<void> toggleLike() async {
    isLiked.value ? likeCount.value-- : likeCount.value++;
    isLiked.toggle();
    await FirebaseService().toggleLike(video.id);
  }

  Future<void> toggleSave() async {
    isSaved.value ? saveCount.value-- : saveCount.value++;
    isSaved.toggle();
    await FirebaseService().toggleSave(video.id);
  }

  @override
  void onClose() {
    videoController.dispose();
    commentTextController.dispose();
    super.onClose();
  }

  void showShareOptions(Color themeColor, bool isDark) {
    videoController.pause();
    Get.bottomSheet(
      Container(
        color: isDark ? Colors.grey[900] : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Video',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _shareIcon(Icons.share, 'Share', themeColor, () {
                  Get.back();
                  SharePlus.instance.share(
                    ShareParams(text: '${video.title}\n${video.videoUrl}'),
                  );
                }),
                _shareIcon(Icons.link, 'Copy Link', Colors.blue, () {
                  Get.back();
                  Clipboard.setData(ClipboardData(text: video.videoUrl));
                  Get.snackbar(
                    'Success',
                    'Link copied!',
                    backgroundColor: themeColor,
                    colorText: Colors.white,
                  );
                }),
              ],
            ),
          ],
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ).whenComplete(() => videoController.play());
  }

  Widget _shareIcon(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void showCommentOptions(Color themeColor, bool isDark) {
    videoController.pause();
    Get.bottomSheet(
      Container(
        height: Get.height * 0.6,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${video.commentCount} Comments',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            Divider(color: isDark ? Colors.grey[800] : Colors.grey[200]),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('videos')
                    .doc(video.id)
                    .collection('comments')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: themeColor),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No comments yet. Be the first to comment!",
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey,
                        ),
                      ),
                    );
                  }

                  final comments = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final commentData =
                          comments[index].data() as Map<String, dynamic>;

                      final String text =
                          commentData['text'] ?? commentData['comment'] ?? '';
                      final String username = commentData['username'] ?? 'User';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                'https://i.pravatar.cc/150?img=11',
                              ), // Placeholder avatar
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    username,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    text,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=11',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: commentTextController,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Add comment...',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey[500] : Colors.grey,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: themeColor),
                    onPressed: () async {
                      final String commentText = commentTextController.text
                          .trim();

                      if (commentText.isNotEmpty) {
                        await FirebaseService().addComment(
                          video.id,
                          commentText,
                        );
                        commentTextController.clear();
                        FocusManager.instance.primaryFocus?.unfocus();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    ).whenComplete(() => videoController.play());
  }
}
