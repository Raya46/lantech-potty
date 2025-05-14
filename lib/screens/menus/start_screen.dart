import 'package:flutter/material.dart';
import 'package:toilet_training/screens/menus/choose_gender_screen.dart';
import 'package:toilet_training/widgets/background.dart';
import 'package:get/get.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        gender: 'male',
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.only(bottom: 0),
                child: Image.asset(
                  'assets/images/male-goto-toilet.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Text(
                          "APLIKASI INTERAKTIF",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            foreground:
                                Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1.5
                                  ..color = const Color(0xFF4A2C2A),
                          ),
                        ),
                        Text(
                          "APLIKASI INTERAKTIF",
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFA07A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      children: [
                        Text(
                          "POTTYFUN KID'S",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            foreground:
                                Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 1.5
                                  ..color = const Color(0xFF4A2C2A),
                          ),
                        ),
                        Text(
                          "POTTYFUN KID'S",
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00FFFF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(right: 100.0),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(
                              () => const ChooseGenderScreen(),
                              transition: Transition.circularReveal,
                              duration: Duration(milliseconds: 1500),
                            );
                          },
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: const Color(0xFF52AACA),
                            child: const Icon(
                              Icons.play_arrow,
                              size: 45,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
