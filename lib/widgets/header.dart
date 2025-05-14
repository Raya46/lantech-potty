import 'package:flutter/material.dart';
import 'package:toilet_training/widgets/modal_setting.dart';
import 'package:get/get.dart';

class Header extends StatelessWidget {
  final VoidCallback? onTapSettings;
  final String title;

  const Header({
    Key? key,
    this.onTapSettings,
    this.title = "Pilih Level!",
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
              Navigator.of(context).pop();
            },
            onTapSound: () {
              print("Sound Tapped");
            },
            onTapMusic: () {
              print("Music Tapped");
            },
            onTapColor: () {
              print("Color Tapped");
            },
          ),
        );
      },
    );
  }

  void onTapBack(){
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    const Color buttonBackgroundColor = Color(0xFF3498DB);
    const Color buttonOutlineColor = Color(0xFF2C3E50);
    const Color textFillColor = Color(0xFFFFA07A);
    const Color textOutlineColor = Color(0xFF808080);

    return Container(
      height: 80.0,
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
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    foreground:
                        Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2.0
                          ..color = textOutlineColor,
                  ),
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textFillColor,
                  ),
                ),
              ],
            ),
          ),

          InkWell(
            onTap: () {
              if (onTapSettings != null) {
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
              child: const Icon(Icons.settings, size: 24, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
