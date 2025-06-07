import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:toilet_training/responsive.dart';

class Background extends StatelessWidget {
  final String gender;
  final Widget child;

  const Background({super.key, required this.gender, required this.child});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                color: gender == 'laki-laki'
                    ? const Color(0xFFC2E0FF)
                    : const Color(0xFFFFDDD2),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: gender == 'laki-laki'
                    ? const Color(0xFF52AACA)
                    : const Color(0xFFFC9D99),
              ),
            ),
          ],
        ),

        // Jendela kanan
        Positioned(
          top: 1.h,
          right: 5.w,
          child: Image.asset(
            'assets/images/jendela.png',
            width: isTablet ? 20.w : 20.w, 
            fit: BoxFit.fill,
          ),
        ),

        // Jendela kiri
        Positioned(
          top: 1.h,
          left: 5.w,
          child: Image.asset(
            'assets/images/jendela.png',
            width: isTablet ? 30.w : 25.w, 
            fit: BoxFit.fill,
          ),
        ),

        // Rak buku
        Positioned(
          bottom: 4.h,
          right: -15.w,
          child: Image.asset(
            'assets/images/rak-buku.png',
            width: isTablet ? 40.w : 35.w, // was 250
            fit: BoxFit.fill,
          ),
        ),

        // Tanaman kanan
        Positioned(
          bottom: -1.h,
          right: -12.w,
          child: Image.asset(
            'assets/images/tanaman2.png',
            width: isTablet ? 25.w : 25.w, // was 150
            fit: BoxFit.fill,
          ),
        ),

        // Tanaman kiri
        Positioned(
          bottom: -5.h,
          left: -10.w,
          child: Image.asset(
            'assets/images/tanaman2.png',
            width: isTablet ? 35.w : 30.w,  // was 200
            fit: BoxFit.fill,
          ),
        ),

        // Tanaman kecil tengah
        Positioned(
          bottom: 10.h,
          left: 64.w,
          child: Image.asset(
            'assets/images/tanaman1.png',
            width: isTablet ? 20.w : 20.w, // was 100
            fit: BoxFit.fill,
          ),
        ),

        // Karpet
        Positioned(
          bottom: 5.h,
          left: 100.w,
          child: Image.asset(
            'assets/images/karpet.png',
            width: isTablet ? 30.w : 35.w, // was 174
            fit: BoxFit.fill,
          ),
        ),

        // Kucing
        Positioned(
          bottom: 5.h,
          left: 110.w,
          child: Image.asset(
            'assets/images/kucing.png',
            width: isTablet ? 20.w : 20.w, // was 109
            fit: BoxFit.fill,
          ),
        ),

        // Main content
        child,
      ],
    );
  }
}
