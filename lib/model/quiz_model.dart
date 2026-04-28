import 'package:flutter/material.dart';

class QuizOption {
  final String id;
  final String text;
  final IconData icon;

  QuizOption({required this.id, required this.text, required this.icon});
}

class Question {
  final String text;
  final String level;
  final List<QuizOption> options;
  final String tip;

  Question({
    required this.text,
    required this.level,
    required this.options,
    required this.tip,
  });
}
