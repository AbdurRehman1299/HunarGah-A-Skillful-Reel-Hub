import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hunargah/model/quiz_model.dart';

class QuizController extends GetxController {
  var selectedOptionId = RxnString();
  var currentQuestionIndex = 4.obs;
  var totalQuestions = 10.obs;
  var timerText = "0:15s".obs;

  final question = Question(
    text: 'Which tool is used for\ntightening pipes?',
    level: 'BEGINNER',
    tip:
        "Most pipes have circular bodies; look for a tool designed to grip rounded surfaces without slipping.",
    options: [
      QuizOption(id: 'A', text: 'Pipe Wrench', icon: Icons.build_outlined),
      QuizOption(id: 'B', text: 'Claw Hammer', icon: Icons.gavel),
      QuizOption(
        id: 'C',
        text: 'Screwdriver',
        icon: Icons.settings_input_component,
      ),
    ],
  );

  void selectOption(String id) {
    selectedOptionId.value = id;
  }

  void skipQuestion() {
    Get.back();
  }
}
