import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:toilet_training/responsive.dart';
import 'package:toilet_training/widgets/modal_setting.dart';

class Header extends StatelessWidget {
  final VoidCallback? onTapSettings;
  final VoidCallback? onTapBack;
  final String title;
  final bool showInfoButton;
  final VoidCallback? onTapInfoButton;
  final IconData infoButtonIcon;

  const Header({
    Key? key,
    required this.onTapBack,
    this.onTapSettings,
    this.title = "Pilih Level!",
    this.showInfoButton = false,
    this.onTapInfoButton,
    this.infoButtonIcon = Icons.info_outline,
  }) : super(key: key);

  void _showSettingsModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SettingsModalContent(
            onClose: () {
              Get.back(canPop: false);
            },
            onTapSound: () {},
            onTapMusic: () {},
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color buttonBackgroundColor = Color(0xFF3498DB);
    const Color buttonOutlineColor = Color(0xFF2C3E50);
    const Color textFillColor = Color(0xFFFFA07A);
    const Color textOutlineColor = Color(0xFF808080);

    return Container(
      height: 50.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      color: Colors.transparent,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: onTapBack,
            customBorder: const CircleBorder(),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: buttonOutlineColor, width: 2.0),
                color: buttonBackgroundColor,
              ),
              padding: const EdgeInsets.all(8.0),
              child: const Icon(
                Icons.arrow_back,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),

          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                BorderedText(
                  strokeWidth: 4.0,
                  strokeColor: const Color(0xFF4A2C2A),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: Responsive.isTablet(context) ? 16.sp : 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFA07A),
                    ),
                  ),
                ),
              ],
            ),
          ),

          InkWell(
            onTap: () {
              if (showInfoButton && onTapInfoButton != null) {
                onTapInfoButton!();
              } else if (onTapSettings != null) {
                onTapSettings!();
              } else {
                _showSettingsModal(context);
              }
            },
            customBorder: const CircleBorder(),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: buttonOutlineColor, width: 2.0),
                color: buttonBackgroundColor,
              ),
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                showInfoButton ? infoButtonIcon : Icons.settings,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
