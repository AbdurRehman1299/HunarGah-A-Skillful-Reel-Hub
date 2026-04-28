import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  late VideoPlayerController videoPlayerController;

  var isInitialized = false.obs;
  var isPlaying = false.obs;
  var showControls = true.obs;
  var position = Duration.zero.obs;
  var duration = Duration.zero.obs;

  @override
  void onInit() {
    super.onInit();
    _initializePlayer();
  }

  void _initializePlayer() {
    videoPlayerController =
        VideoPlayerController.networkUrl(
            Uri.parse(
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
            ),
          )
          ..initialize().then((_) {
            isInitialized.value = true;
            duration.value = videoPlayerController.value.duration;
          });

    videoPlayerController.addListener(() {
      position.value = videoPlayerController.value.position;
      isPlaying.value = videoPlayerController.value.isPlaying;
    });
  }

  void togglePlay() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
    } else {
      videoPlayerController.play();
    }
  }

  void toggleControls() {
    showControls.value = !showControls.value;
  }

  void forward10() {
    videoPlayerController.seekTo(position.value + const Duration(seconds: 10));
  }

  void rewind10() {
    videoPlayerController.seekTo(position.value - const Duration(seconds: 10));
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    super.onClose();
  }
}
