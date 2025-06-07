import 'package:sizer/sizer.dart';
import 'package:toilet_training/models/step.dart';
import 'package:flutter/material.dart';

class BuildStepCard extends StatefulWidget {
  const BuildStepCard({super.key, required this.step});
  final ToiletStep step;

  @override
  State<BuildStepCard> createState() => _BuildStepCardState();
}

class _BuildStepCardState extends State<BuildStepCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.2), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 0.9), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 0.9, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Center(
        child: SizedBox(
          width: 25.w,
          height: 25.h,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(widget.step.image, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
