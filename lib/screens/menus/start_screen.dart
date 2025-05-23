import 'package:flutter/material.dart';
import 'package:toilet_training/models/player.dart';
import 'package:toilet_training/screens/menus/choose_gender_screen.dart';
import 'package:toilet_training/services/player_service.dart';
import 'package:toilet_training/widgets/background.dart';
import 'package:get/get.dart';
import 'package:toilet_training/widgets/play_button.dart';
import 'package:toilet_training/widgets/float_animated_widget.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.only(bottom: 0),
                child: FloatAnimatedWidget(
                  child: Image.asset(
                    'assets/images/${_player?.gender == 'laki-laki' ? 'male-goto-toilet.png' : 'female-goto-toilet.png'}',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                        child: PlayButton(
                          onPressed: () {
                            Get.to(
                              () => const ChooseGenderScreen(),
                              transition: Transition.circularReveal,
                              duration: const Duration(milliseconds: 1500),
                            );
                          },
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
