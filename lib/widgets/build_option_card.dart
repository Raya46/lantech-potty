import 'package:flutter/material.dart';
import 'package:toilet_training/models/step.dart';
import 'package:toilet_training/widgets/build_feedback_card.dart';

class BuildOptionCard extends StatelessWidget {
  const BuildOptionCard({super.key, required this.step});
  final ToiletStep step;
  @override
  Widget build(BuildContext context) {
    return Draggable<ToiletStep>(
      data: step,
      feedback: BuildFeedbackCard(step: step),
      childWhenDragging: SizedBox(width: 100, height: 140),
      child: SizedBox(
        width: 100,
        height: 140,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(step.image, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
