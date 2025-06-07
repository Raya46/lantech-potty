import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:toilet_training/responsive.dart';

class PlayButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double? size;
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;
  final Color outlineColor;
  final double? outlineWidth;

  const PlayButton({
    super.key,
    required this.onPressed,
    this.size,
    this.backgroundColor = const Color(0xFF52AACA),
    this.iconColor = Colors.white,
    this.icon = Icons.play_arrow,
    this.outlineColor = Colors.black,
    this.outlineWidth,
  });

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  late bool isTablet;
  late double buttonSize;
  late double outlineWidth;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    isTablet = Responsive.isTablet(context);
    buttonSize = widget.size ??
        (isTablet ? 12.w : 10.w); // Slighly larger on tablet
    outlineWidth = widget.outlineWidth ?? (isTablet ? 0.8.w : 0.5.w);

    return GestureDetector(
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: buttonSize + (outlineWidth * 2),
          height: buttonSize + (outlineWidth * 2),
          padding: EdgeInsets.all(outlineWidth),
          decoration: BoxDecoration(
            color: widget.outlineColor,
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            radius: buttonSize / 2,
            backgroundColor: widget.backgroundColor,
            child: Icon(
              widget.icon,
              size: buttonSize * 0.65,
              color: widget.iconColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
