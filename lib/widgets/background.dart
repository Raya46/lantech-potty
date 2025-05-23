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
        Positioned(
          top: 20,
          right: 20,
          child: Image.asset(
            'assets/images/sun.png',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.04,
          right: 1,
          child: Image.asset(
            'assets/images/perosotan.png',
            width: 250,
            height: 250,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.13,
          right: -80,
          child: Image.asset(
            'assets/images/bush.png',
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          child: Image.asset(
            'assets/images/cloud.png',
            width: 200,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width * 0.4,
          top: 10,
          child: Image.asset(
            'assets/images/cloud.png',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.05,
          left: -10,
          child: Image.asset(
            'assets/images/bush.png',
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.07 * -1,
          right: MediaQuery.of(context).size.width * 0.3,
          child: Image.asset(
            'assets/images/bush.png',
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        child,
      ],
    );
  }
}
