import 'package:flutter/material.dart';


class GenderCard extends StatelessWidget {
  final String gender;
  final String text;
  final VoidCallback? onTap;

  const GenderCard({
    Key? key,
    required this.gender,
    required this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color cardColor =
        gender == 'perempuan'
            ? const Color(0xFFEA9077)
            : const Color(0xFF78C0E0);

    final String imageAssetPath =
        gender == 'perempuan'
            ? 'assets/images/female-goto-toilet.png'
            : 'assets/images/male-goto-toilet.png';

    final Color topBackgroundColor = const Color(0xFFFFF8E1);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 180,
        height: 250,
        decoration: BoxDecoration(
          color: topBackgroundColor,
          borderRadius: BorderRadius.circular(20),
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
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(imageAssetPath, fit: BoxFit.contain),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  text,
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
      ),
    );
  }
}
