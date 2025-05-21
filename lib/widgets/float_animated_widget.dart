import 'package:flutter/material.dart';

class FloatAnimatedWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Offset beginOffset;
  final Offset endOffset;

  const FloatAnimatedWidget({
    Key? key,
    required this.child,
    this.duration = const Duration(seconds: 1),
    this.beginOffset = Offset.zero,
    this.endOffset = const Offset(0.0, -0.05),
  }) : super(key: key);

  @override
  State<FloatAnimatedWidget> createState() => _FloatAnimatedWidgetState();
}

class _FloatAnimatedWidgetState extends State<FloatAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _offsetAnimation = Tween<Offset>(
      begin: widget.beginOffset,
      end: widget.endOffset,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(position: _offsetAnimation, child: widget.child);
  }
}
