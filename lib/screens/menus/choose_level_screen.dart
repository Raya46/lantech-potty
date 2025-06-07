import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:toilet_training/models/player.dart';
import 'package:toilet_training/screens/levels/level1/level1_start_screen.dart';
import 'package:toilet_training/screens/levels/level2/level2_start_screen.dart';
import 'package:toilet_training/screens/levels/level3/level3_start_screen.dart';
import 'package:toilet_training/screens/levels/level4/level4_start_screen.dart';
import 'package:toilet_training/screens/levels/level5/level5_start_screen.dart';
import 'package:toilet_training/services/player_service.dart';
import 'package:toilet_training/widgets/background.dart';
import "package:toilet_training/widgets/card_level.dart";
import "package:toilet_training/widgets/header.dart";
import 'package:toilet_training/screens/menus/choose_gender_screen.dart';

class ChooseLevelScreen extends StatefulWidget {
  const ChooseLevelScreen({super.key});

  @override
  State<ChooseLevelScreen> createState() => _ChooseLevelScreenState();
}

class _ChooseLevelScreenState extends State<ChooseLevelScreen> {
  Player? _player;
  bool _isLoadingPlayer = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadPlayerData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadPlayerData() async {
    setState(() {
      _isLoadingPlayer = true;
    });
    try {
      _player = await getPlayer();
      if (_player == null) {
        _player = Player(null);
        _player!.gender = 'perempuan';
        _player!.isFocused = false;
        await savePlayer(_player!);
      }
      _player!.gender ??= 'perempuan';
    } catch (e) {
      _player = Player(null);
      _player!.gender = 'perempuan';
      _player!.isFocused = false;
    }
    setState(() {
      _isLoadingPlayer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingPlayer || _player == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List<Map<String, dynamic>> levels = [
      {'text': "Urutan Toilet", 'screen': () => LevelOneStartScreen()},
      {'text': "Temukan Benda", 'screen': () => LevelTwoStartScreen()},
      {'text': "Detektif Cilik!", 'screen': () => LevelThreeStartScreen()},
      {'text': "Urutkan Aktivitas", 'screen': () => LevelFourStartScreen()},
      {'text': "Puzzle", 'screen': () => LevelFiveStartScreen()},
    ];

    return Scaffold(
      body: Background(
        gender: _player!.gender!,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Header(
                onTapBack: () {
                  Get.off(() => const ChooseGenderScreen());
                },
                title: "Pilih level",
              ),
            ),
            Expanded(
              flex: 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SingleChildScrollView(
                    controller: _scrollController,
                    padding: EdgeInsets.all(16),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          levels.asMap().entries.map((entry) {
                            int idx = entry.key;
                            Map<String, dynamic> levelData = entry.value;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: InkWell(
                                onTap: () {
                                  Get.to(
                                    levelData['screen'],
                                    transition: Transition.circularReveal,
                                    duration: const Duration(
                                      milliseconds: 1500,
                                    ),
                                  );
                                },
                                child: CardLevel(
                                  title: levelData['text'],
                                  gender: _player!.gender!,
                                  level: idx + 1,
                                  children: [],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        _scrollController.animateTo(
                          _scrollController.offset - 200,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        _scrollController.animateTo(
                          _scrollController.offset + 200,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
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
