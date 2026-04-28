import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hunargah/model/quiz_model.dart';
import 'package:hunargah/viewmodels/quiz_viewmodel.dart';

class QuizDialog extends StatelessWidget {
  const QuizDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuizController());

    final themeColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // -- Floating close button --
          _closeButton(),

          const SizedBox(height: 12),

          // -- Main Quiz Card --
          _quizCard(context, controller, themeColor, isDark),
        ],
      ),
    );
  }

  Widget _quizCard(
    BuildContext context,
    QuizController controller,
    Color themeColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -- Header (Timer & Question Count) --
          _header(controller, themeColor, isDark),

          const SizedBox(height: 12),

          // -- Custom Progress Bar --
          _progressBar(controller, themeColor, isDark),

          const SizedBox(height: 20),

          // -- Level Pill --
          _levelPill(controller, themeColor),

          const SizedBox(height: 16),

          // -- Question Text --
          _questionText(controller, isDark),

          const SizedBox(height: 24),

          // -- Options (Reactive List) --
          Column(
            children: controller.question.options.map((opt) {
              return Obx(
                () => _buildOption(
                  opt,
                  controller.selectedOptionId.value == opt.id,
                  themeColor,
                  isDark,
                  () => controller.selectOption(opt.id),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // -- Ustad's Tip Box --
          _tipBox(controller, isDark),

          const SizedBox(height: 24),

          // -- Footer (Points & Skip) --
          _footer(controller, isDark),
        ],
      ),
    );
  }

  Widget _header(QuizController controller, Color themeColor, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.timer_outlined, size: 16, color: themeColor),
            const SizedBox(width: 8),
            Obx(
              () => Text(
                'QUESTION ${controller.currentQuestionIndex} OF ${controller.totalQuestions}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
        Obx(
          () => Text(
            controller.timerText.value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: themeColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _progressBar(
    QuizController controller,
    Color themeColor,
    bool isDark,
  ) {
    return Obx(() {
      double progress =
          controller.currentQuestionIndex.value /
          controller.totalQuestions.value;
      return Row(
        children: [
          Expanded(
            flex: (progress * 10).toInt(),
            child: Container(height: 4, color: themeColor),
          ),
          Expanded(
            flex: (10 - (progress * 10)).toInt(),
            child: Container(
              height: 4,
              color: themeColor.withValues(alpha: 0.15),
            ),
          ),
        ],
      );
    });
  }

  Widget _levelPill(QuizController controller, Color themeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: themeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'LEVEL: ${controller.question.level}',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: themeColor,
        ),
      ),
    );
  }

  Widget _questionText(QuizController controller, bool isDark) {
    return Text(
      controller.question.text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black,
        height: 1.2,
      ),
    );
  }

  Widget _buildOption(
    QuizOption opt,
    bool isSelected,
    Color themeColor,
    bool isDark,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? themeColor.withValues(alpha: 0.05)
              : (isDark ? Colors.grey[900] : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? themeColor
                : (isDark ? Colors.grey[800]! : Colors.grey[200]!),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  opt.id,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : Colors.grey[800],
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                opt.text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            Icon(
              opt.icon,
              size: 20,
              color: isSelected ? themeColor : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tipBox(QuizController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.help_outline,
            size: 18,
            color: isDark ? Colors.white70 : Colors.grey[800],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: "Ustad's Tip: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  TextSpan(text: controller.question.tip),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer(QuizController controller, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 16),
            const SizedBox(width: 6),
            Text(
              'Win +50 Hunar Points',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: controller.skipQuestion,
          child: Text(
            'Skip for now',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.grey[500] : Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  Widget _closeButton() {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
