import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toilet_training/models/player.dart';
import 'package:toilet_training/screens/levels/level1/level1_start_screen.dart';
import 'package:toilet_training/screens/levels/level2/level2_start_screen.dart';
import 'package:toilet_training/screens/levels/level3/level3_start_screen.dart';
import 'package:toilet_training/screens/levels/level4/level4_start_screen.dart';
import 'package:toilet_training/screens/levels/level5/level5_start_screen.dart';
import 'package:toilet_training/services/player_service.dart';
import 'package:toilet_training/widgets/background.dart';
import "package:toilet_training/widgets/card_gender.dart";
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
      {'text': "Level 1", 'screen': () => LevelOneStartScreen()},
      {'text': "Level 2", 'screen': () => LevelTwoStartScreen()},
      {'text': "Level 3", 'screen': () => LevelThreeStartScreen()},
      {'text': "Level 4", 'screen': () => LevelFourStartScreen()},
      {'text': "Level 5", 'screen': () => LevelFiveStartScreen()},
    ];

    return Scaffold(
      body: Background(
        gender: _player!.gender!,
        child: Column(
          children: [
            Header(
              onTapBack: () {
                Get.off(() => const ChooseGenderScreen());
              },
              title: "Pilih level",
            ),
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        spacing: 16.0,
                        children:
                            levels.map((levelData) {
                              return GenderCard(
                                text: levelData['text'],
                                gender: _player!.gender!,
                                onTap: () {
                                  Get.to(
                                    levelData['screen'],
                                    transition: Transition.circularReveal,
                                    duration: Duration(milliseconds: 1500),
                                  );
                                },
                              );
                            }).toList(),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          _scrollController.animateTo(
                            _scrollController.offset - 200,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          _scrollController.animateTo(
                            _scrollController.offset + 200,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        },
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
