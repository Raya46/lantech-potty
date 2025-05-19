import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toilet_training/models/player.dart';
import 'package:toilet_training/services/player_service.dart';
import 'package:toilet_training/widgets/background.dart';
import 'package:toilet_training/widgets/header.dart';
import 'package:toilet_training/screens/menus/choose_level_screen.dart';

class LevelStartScreen extends StatefulWidget {
  LevelStartScreen({
    super.key,
    required this.levelText,
    required this.levelDescription,
    required this.levelScreen,
    this.player,
    this.isLoadingPlayer = true,
  });
  final String levelText;
  final String levelDescription;
  final Widget levelScreen;
  Player? player;
  bool isLoadingPlayer;

  @override
  State<LevelStartScreen> createState() => _LevelStartScreenState();
}

class _LevelStartScreenState extends State<LevelStartScreen> {
  @override
  void initState() {
    super.initState();
    _loadPlayerData();
  }

  Future<void> _loadPlayerData() async {
    setState(() {
      widget.isLoadingPlayer = true;
    });
    try {
      widget.player = await getPlayer();
      widget.player?.gender ??= 'perempuan';
      widget.player?.isFocused ??= false;
      widget.player?.level1Score ??= 0;
      widget.player?.level2Score ??= 0;
      widget.player?.level3Score ??= 0;
      widget.player?.level4Score ??= 0;
      widget.player?.level5Score ??= 0;
    } catch (e) {
      widget.player =
          Player(null)
            ..gender = 'perempuan'
            ..isFocused = false
            ..level1Score = 0
            ..level2Score = 0
            ..level3Score = 0
            ..level4Score = 0
            ..level5Score = 0;
      await savePlayer(widget.player!);
    }
    setState(() {
      widget.isLoadingPlayer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoadingPlayer || widget.player == null) {
      return Scaffold(
        body: Background(
          gender: widget.player?.gender ?? 'perempuan',
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return Scaffold(
      body: Background(
        gender: widget.player!.gender!,
        child: Column(
          children: [
            Header(
              onTapBack: () {
                Get.off(() => const ChooseLevelScreen());
              },
              title: "",
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Image.asset(
                        widget.player!.gender == 'perempuan'
                            ? 'assets/images/female-happy.png'
                            : 'assets/images/male-happy.png',
                        fit: BoxFit.contain,
                      ),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Text(
                              widget.levelText,
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
                              widget.levelText,
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
                              widget.levelDescription,
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
                              widget.levelDescription,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFA07A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => widget.levelScreen,
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
          ],
        ),
      ),
    );
  }
}
