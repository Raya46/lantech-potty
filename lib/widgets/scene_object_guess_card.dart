import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:toilet_training/models/scene_object.dart';

class SceneObjectGuessCard extends StatefulWidget {
  const SceneObjectGuessCard({
    super.key,
    required this.onTap,
    required this.answered,
    required this.item,
    required this.correctItem,
  });

  final VoidCallback onTap;
  final bool answered;
  final SceneObjectData item;
  final SceneObjectData correctItem;

  @override
  State<SceneObjectGuessCard> createState() => _SceneObjectGuessCardState();
}

class _SceneObjectGuessCardState extends State<SceneObjectGuessCard>
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
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
              color:
                  widget.answered && widget.item.id == widget.correctItem.id
                      ? Colors.green
                      : widget.answered &&
                          widget.item.id != widget.correctItem.id
                      ? Colors.red
                      : Colors.grey[300]!,
              width: widget.answered ? 0.5.w : 0.3.w,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(2.w),
            child: Image.asset(
              widget.item.imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(
                    Icons.broken_image,
                    size: 8.w,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
