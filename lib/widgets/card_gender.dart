import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:toilet_training/widgets/float_animated_widget.dart';
import 'package:toilet_training/responsive.dart';

class GenderCard extends StatelessWidget {
  final String gender;
  final String text;
  final VoidCallback? onTap;

  const GenderCard({
    super.key,
    required this.gender,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTablet = Responsive.isTablet(context);

    final Color cardColor =
        gender == 'perempuan' ? const Color(0xFFEA9077) : const Color(0xFF78C0E0);

    final String imageAssetPath =
        gender == 'perempuan'
            ? 'assets/images/female-goto-toilet.png'
            : 'assets/images/male-goto-toilet.png';

    final Color topBackgroundColor = const Color(0xFFFFF8E1);

    // Sizes using Sizer (mobile: ~180x250, tablet: slightly larger)
    final double cardWidth = isTablet ? 50.w : 40.w;
    final double cardHeight = isTablet ? 30.h : 30.h;
    final double fontSize = isTablet ? 12.sp : 10.sp;
    final double imagePadding = isTablet ? 2.w : 3.w;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: FloatAnimatedWidget(
        child: Container(
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            color: topBackgroundColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
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
              // Image section
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.all(imagePadding),
                  child: Image.asset(
                    imageAssetPath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Text section
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
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
