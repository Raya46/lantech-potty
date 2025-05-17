import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final String gender;
  final Widget child;

  const Background({super.key, required this.gender, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color:
                    gender == 'laki-laki'
                        ? const Color(0xFFC2E0FF)
                        : const Color(0xFFFFDDD2),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color:
                    gender == 'laki-laki'
                        ? const Color(0xFF52AACA)
                        : const Color(0xFFFC9D99),
              ),
            ),
          ],
        ),
        child,
      ],
    );
  }
}
