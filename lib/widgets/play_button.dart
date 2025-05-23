import 'package:flutter/material.dart';

class PlayButton extends StatefulWidget {
  final VoidCallback onPressed;
  final double size;
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;
  final Color outlineColor;
  final double outlineWidth;

  const PlayButton({
    super.key,
    required this.onPressed,
    this.size = 70.0,
    this.backgroundColor = const Color(0xFF52AACA),
    this.iconColor = Colors.white,
    this.icon = Icons.play_arrow,
    this.outlineColor = Colors.black,
    this.outlineWidth = 3.0,
  });

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.size + (widget.outlineWidth * 2),
          height: widget.size + (widget.outlineWidth * 2),
          padding: EdgeInsets.all(widget.outlineWidth),
          decoration: BoxDecoration(
            color: widget.outlineColor,
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            radius: widget.size / 2,
            backgroundColor: widget.backgroundColor,
            child: Icon(
              widget.icon,
              size: widget.size * 0.65,
              color: widget.iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
