import 'package:flutter/material.dart';

class CardLevel extends StatelessWidget {
  const CardLevel({
    required this.children,
    super.key,
    this.title,
    this.subtitle,
    this.padding,
    this.actions = const [],
    this.footers = const [],
    this.expanded = false,
    required this.level,
    required this.gender,
  });
  final String? title;
  final String? subtitle;
  final EdgeInsetsGeometry? padding;
  final List<Widget> children;
  final List<Widget> actions;
  final List<Widget> footers;
  final bool expanded;
  final int level;
  final String gender;

  @override
  Widget build(BuildContext context) {
    String imagePath;
    switch (level) {
      case 1:
        imagePath = 'assets/images/level1.png';
        break;
      case 2:
        imagePath = 'assets/images/level2.png';
        break;
      case 3:
        imagePath = 'assets/images/level3.png';
        break;
      case 4:
        imagePath = 'assets/images/level4.png';
        break;
      case 5:
        imagePath = 'assets/images/level5.png';
        break;
      default:
        imagePath = 'assets/images/level2.png';
    }

    final Color cardColor =
        gender == 'perempuan'
            ? const Color(0xFFEA9077)
            : const Color(0xFF78C0E0);

    final Color topBackgroundColor = const Color(0xFFFFF8E1);

    return Container(
      width: 180,
      height: 250,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: topBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: cardColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                level.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              alignment: Alignment.center,
              child: Text(
                title ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
