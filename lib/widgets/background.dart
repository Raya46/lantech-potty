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
          top: 1,
          right: 20,
          child: Image.asset(
            'assets/images/jendela.png',
            width: 100,
            height: 100,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          top: 1,
          left: 20,
          child: Image.asset(
            'assets/images/jendela.png',
            width: 150,
            height: 150,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.04,
          right: MediaQuery.of(context).size.width * 0.1 * -1.5,
          child: Image.asset(
            'assets/images/rak-buku.png',
            width: 250,
            height: 300,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.1 * -1,
          right: -80,
          child: Image.asset(
            'assets/images/tanaman2.png',
            width: 150,
            height: 200,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.1 * -1,
          left: MediaQuery.of(context).size.width * 0.1 * -1,
          child: Image.asset(
            'assets/images/tanaman2.png',
            width: 200,
            height: 300,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.16,
          right: MediaQuery.of(context).size.width * 0.51,
          child: Image.asset(
            'assets/images/tanaman1.png',
            width: 100,
            height: 100,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.05,
          right: MediaQuery.of(context).size.width * 0.2,
          child: Image.asset(
            'assets/images/karpet.png',
            width: 174,
            height: 66,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.05,
          right: MediaQuery.of(context).size.width * 0.15,
          child: Image.asset(
            'assets/images/kucing.png',
            width: 109,
            height: 164,
            fit: BoxFit.fill,
          ),
        ),
        child,
      ],
    );
  }
}
