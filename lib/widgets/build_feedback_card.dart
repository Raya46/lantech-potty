import 'package:toilet_training/models/step.dart';
import 'package:flutter/material.dart';

class BuildFeedbackCard extends StatelessWidget {
  const BuildFeedbackCard({super.key, required this.step});
  final ToiletStep step;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
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

