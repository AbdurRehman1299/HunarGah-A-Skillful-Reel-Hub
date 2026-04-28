import 'package:get/get.dart';
import 'package:hunargah/model/lesson_model.dart';

class CoursePlaylistController extends GetxController {
  var isSubscribed = false.obs;

  final lessons = <Lesson>[
    Lesson(
      title: '1. Introduction to Plumbing Tools',
      statusText: 'Completed',
      duration: '12:45',
      state: LessonState.completed,
    ),
    Lesson(
      title: '2. Understanding Water Pressure',
      statusText: 'Now Playing',
      duration: '18:20',
      state: LessonState.playing,
    ),
    Lesson(
      title: '3. Fixing Common Leaky Pressure',
      statusText: 'Up Next',
      duration: '25:10',
      state: LessonState.upNext,
    ),
    Lesson(
      title: '4. Pipe Materials: PVC vs Copper',
      statusText: 'Unlock after Level 3',
      duration: '15:30',
      state: LessonState.locked,
    ),
    Lesson(
      title: '5. Kitchen Sink Installation',
      statusText: 'Unlock after Level 4',
      duration: '32:00',
      state: LessonState.locked,
    ),
  ].obs;

  void toggleSubscribe() {
    isSubscribed.value = !isSubscribed.value;
  }
}
