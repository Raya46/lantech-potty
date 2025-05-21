import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModalResult {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    required int starsEarned,
    required VoidCallback onPrimaryAction,
    required String primaryActionText,
    VoidCallback? onSecondaryAction,
    String? secondaryActionText,
    required bool isSuccess,
    Widget? child,
    String? playerGender,
    ConfettiController? confettiController,
  }) {
    Widget starDisplay = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Icon(
          index < starsEarned ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 30,
        );
      }),
    );

    Color titleColor = isSuccess ? Colors.green : Colors.red;
    Color primaryButtonColor = isSuccess ? Color(0xFF5C9A4A) : Colors.orange;
    if (primaryActionText.toLowerCase() == "ok" && isSuccess) {
      primaryButtonColor = Color(0xFF5C9A4A);
    }

    if (isSuccess && confettiController != null) {
      confettiController.play();
    }

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFFFF0E1),
        title: Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: titleColor,
              fontSize: 22,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isSuccess && playerGender != null) ...[
              Image.asset(
                playerGender == 'perempuan'
                    ? 'assets/images/female-happy.png'
                    : 'assets/images/male-happy.png',
                height: 80,
              ),
              const SizedBox(height: 10),
            ],
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Color(0xFF8B5A2B)),
            ),
            if (starsEarned > 0 || isSuccess) ...[starDisplay],
            if (child != null) ...[const SizedBox(height: 15), child],
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            ),
            onPressed: () {
              Get.back();
              onPrimaryAction();
            },
            child: Text(
              primaryActionText,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          if (onSecondaryAction != null && secondaryActionText != null) ...[
            SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5C9A4A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              ),
              onPressed: () {
                Get.back();
                onSecondaryAction();
              },
              child: Text(
                secondaryActionText,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ],
      ),
      barrierDismissible: false,
    );
  }
}
