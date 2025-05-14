import 'package:flutter/material.dart';
import 'package:toilet_training/widgets/background.dart'; // Impor Background widget
import 'package:get/get.dart';

class LevelTwoScreen extends StatefulWidget {
  const LevelTwoScreen({super.key});

  @override
  State<LevelTwoScreen> createState() => _LevelTwoScreenState();
}

class _LevelTwoScreenState extends State<LevelTwoScreen> {
  final String currentGender = 'female'; // Sesuai dengan gambar dan desain

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        gender: currentGender,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2, // Sesuaikan flex untuk proporsi
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Image.asset(
                    'assets/images/female-happy.png', // Pastikan path ini benar
                    fit: BoxFit.contain, // Atau BoxFit.cover sesuai kebutuhan
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3, // Sesuaikan flex untuk proporsi
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Pusatkan teks dan tombol
                  children: [
                    Stack(
                      children: [
                        Text(
                          "Level 2",
                          textAlign: TextAlign.center,
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
                          "Level 2",
                          textAlign: TextAlign.center,

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
                          "Tentukan Benda yang Tepat",
                          textAlign: TextAlign.center,

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
                          "Tentukan Benda yang Tepat",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFA07A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(right: 100.0),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(
                              () => const LevelTwoFocusScreen(),
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

class LevelTwoFocusScreen extends StatefulWidget {
  const LevelTwoFocusScreen({super.key});

  @override
  State<LevelTwoFocusScreen> createState() => _LevelTwoFocusScreenState();
}

class _LevelTwoFocusScreenState extends State<LevelTwoFocusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard"), actions: const []),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: []),
      ),
    );
  }
}
