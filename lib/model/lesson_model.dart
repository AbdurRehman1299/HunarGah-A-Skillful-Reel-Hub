enum LessonState { completed, playing, upNext, locked }

class Lesson {
  final String title;
  final String statusText;
  final String duration;
  final LessonState state;

  Lesson({
    required this.title,
    required this.statusText,
    required this.duration,
    required this.state,
  });
}
