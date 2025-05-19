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
  bool _showLeftArrow = false;
  bool _showRightArrow = true;

  @override
  void initState() {
    super.initState();
    _loadPlayerData();
    _scrollController.addListener(_scrollListener);

    // A small delay to allow the layout to settle before checking scroll extent.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scrollListener();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!mounted || !_scrollController.hasClients) return;

    final position = _scrollController.position;
    setState(() {
      _showLeftArrow = position.pixels > position.minScrollExtent;
      _showRightArrow = position.pixels < position.maxScrollExtent;
    });
    // If there's no scrollable content, hide both arrows
    if (position.maxScrollExtent == position.minScrollExtent) {
      setState(() {
        _showLeftArrow = false;
        _showRightArrow = false;
      });
    }
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
    if (_isLoadingPlayer) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Background(
        gender: _player?.gender as String,
        child: Column(
          children: [
            Header(
              onTapBack: () {
                Get.off(() => const ChooseGenderScreen());
              },
              title: "Pilih level",
            ),
            Expanded(
              // Added Expanded to ensure Stack takes available space
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GenderCard(
                            text: "Level 1",
                            gender: _player!.gender as String,
                            onTap: () {
                              Get.to(
                                () => LevelOneStartScreen(),
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
                            gender: _player!.gender as String,
                            onTap: () {
                              Get.to(
                                () => LevelTwoStartScreen(),
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
                            gender: _player!.gender as String,
                            onTap: () {
                              Get.to(
                                () => LevelThreeStartScreen(),
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
                            gender: _player!.gender as String,
                            onTap: () {
                              Get.to(
                                () => LevelFourStartScreen(),
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
                            gender: _player!.gender as String,
                            onTap: () {
                              Get.to(
                                () => LevelFiveStartScreen(),
                                transition: Transition.circularReveal,
                                duration: Duration(milliseconds: 1500),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_showLeftArrow)
                    Positioned(
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  if (_showRightArrow)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 20,
                        ),
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
