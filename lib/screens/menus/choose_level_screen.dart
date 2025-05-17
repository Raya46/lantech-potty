import 'package:flutter/material.dart';
import 'package:toilet_training/screens/levels/level1_screen.dart';
import 'package:get/get.dart';
import 'package:toilet_training/screens/levels/level2_screen.dart';
import 'package:toilet_training/screens/levels/level3_screen.dart';
import 'package:toilet_training/screens/levels/level4_screen.dart';
import 'package:toilet_training/screens/levels/level5_screen.dart';
import 'package:toilet_training/widgets/background.dart';
import "package:toilet_training/widgets/card_gender.dart";
import "package:toilet_training/widgets/header.dart";
import 'package:toilet_training/models/player.dart';
import 'package:toilet_training/services/player_service.dart';

class ChooseLevelScreen extends StatefulWidget {
  const ChooseLevelScreen({super.key});

  @override
  State<ChooseLevelScreen> createState() => _ChooseLevelScreenState();
}

class _ChooseLevelScreenState extends State<ChooseLevelScreen> {
  Player? _player;
  bool _isLoadingPlayer = true;

  @override
  void initState() {
    super.initState();
    _loadPlayerData();
  }

  Future<void> _loadPlayerData() async {
    setState(() {
      _isLoadingPlayer = true;
    });
    try {
      _player = await getPlayer();
      if (_player == null) {
        print("Player data not found in ChooseLevelScreen! Creating default.");
        _player = Player(null);
        _player!.gender = 'perempuan'; // Default gender
        _player!.isFocused = false; // Default focus state
        await savePlayer(_player!);
      }
      _player!.gender ??= 'perempuan'; // Ensure gender is not null
    } catch (e) {
      print("Error loading player in ChooseLevelScreen: $e. Creating default.");
      _player = Player(null);
      _player!.gender = 'perempuan';
      _player!.isFocused = false;
      // await savePlayer(_player!); // Consider if saving here is appropriate
    }
    setState(() {
      _isLoadingPlayer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingPlayer) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Background(
        gender: _player?.gender as String,
        child: Column(
          children: [
            Header(title: "Pilih level"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GenderCard(
                      text: "Level 1",
                      gender: Gender.female,
                      onTap: () {
                        Get.to(
                          () => LevelOneScreen(),
                          transition: Transition.circularReveal,
                          duration: Duration(milliseconds: 1500),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GenderCard(
                      text: "Level 2",
                      gender: Gender.female,
                      onTap: () {
                        Get.to(
                          () => LevelTwoScreen(),
                          transition: Transition.circularReveal,
                          duration: Duration(milliseconds: 1500),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GenderCard(
                      text: "Level 3",
                      gender: Gender.female,
                      onTap: () {
                        Get.to(
                          () => LevelThreeScreen(),
                          transition: Transition.circularReveal,
                          duration: Duration(milliseconds: 1500),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GenderCard(
                      text: "Level 4",
                      gender: Gender.female,
                      onTap: () {
                        Get.to(
                          () => LevelFourScreen(),
                          transition: Transition.circularReveal,
                          duration: Duration(milliseconds: 1500),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GenderCard(
                      text: "Level 5",
                      gender: Gender.female,
                      onTap: () {
                        Get.to(
                          () => LevelFiveScreen(),
                          transition: Transition.circularReveal,
                          duration: Duration(milliseconds: 1500),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  MyClipper(this.value);
  final double value;

  @override
  Path getClip(Size size) {
    var path = Path();
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.height, size.height),
        radius: value * size.width,
      ),
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
