import 'package:flutter/material.dart';
import 'package:toilet_training/models/bathroom_item.dart';

class BathroomGuessCard extends StatefulWidget {
  const BathroomGuessCard({
    super.key,
    required this.onTap,
    required this.answered,
    required this.item,
    required this.correctItem,
  });
  final VoidCallback onTap;
  final bool answered;
  final BathroomItem item;
  final BathroomItem correctItem;

  @override
  State<BathroomGuessCard> createState() => _BathroomGuessCardState();
}

class _BathroomGuessCardState extends State<BathroomGuessCard>
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color:
                  widget.answered && widget.item.id == widget.correctItem.id
                      ? Colors.green
                      : widget.answered &&
                          widget.item.id != widget.correctItem.id
                      ? Colors.red
                      : Colors.grey[300]!,
              width: widget.answered ? 3 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset(
              widget.item.image,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
