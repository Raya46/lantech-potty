import 'dart:convert';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:toilet_training/models/player.dart';
import 'package:toilet_training/models/step.dart';
import 'package:toilet_training/services/player_service.dart';
import 'package:toilet_training/widgets/background.dart';
import 'package:toilet_training/widgets/header.dart';
import 'package:toilet_training/widgets/modal_setting.dart';
import 'package:toilet_training/games/sort_game/sort_game.dart';
import 'package:toilet_training/screens/levels/level1/level1_start_screen.dart';
import 'package:confetti/confetti.dart';

class LevelOnePlayScreen extends StatefulWidget {
  final String gender;
  final bool isFocused;
  final List<String> imagePathsForGame;

  const LevelOnePlayScreen({
    super.key,
    required this.gender,
    required this.isFocused,
    required this.imagePathsForGame,
  });

  @override
  State<LevelOnePlayScreen> createState() => _LevelOnePlayScreenState();
}

class _LevelOnePlayScreenState extends State<LevelOnePlayScreen> {
  late bool _currentIsFocused;
  late List<String> _currentImagePathsForGame;
  Player? _playerObject;
  bool _isLoading = true;
  UniqueKey _gameKey = UniqueKey();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _currentIsFocused = widget.isFocused;
    _currentImagePathsForGame = List.from(widget.imagePathsForGame);
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _loadPlayerStatusAndUpdateGame();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _loadPlayerStatusAndUpdateGame() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _playerObject = await getPlayer();
      if (_playerObject != null) {
        _currentIsFocused = _playerObject!.isFocused ?? widget.isFocused;

        final String response = await rootBundle.loadString(
          'lib/models/static/step-static.json',
        );
        final List<dynamic> data = json.decode(response);
        List<ToiletStep> steps =
            data.map((e) => ToiletStep.fromJson(e)).where((step) {
              return step.gender == widget.gender &&
                  step.focus == _currentIsFocused;
            }).toList();
        steps.sort((a, b) => a.id.compareTo(b.id));
        _currentImagePathsForGame = steps.map((step) => step.image).toList();

        if (_currentImagePathsForGame.isEmpty) {}
      } else {
        _currentIsFocused = widget.isFocused;
        _currentImagePathsForGame = List.from(widget.imagePathsForGame);
      }
    } catch (e) {
      _currentIsFocused = widget.isFocused; 
      _currentImagePathsForGame = List.from(
        widget.imagePathsForGame,
      ); 
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
        _gameKey = UniqueKey();
      });
    }
  }

  Future<void> _showSettingsModal() async {
    final currentContext = context;
    await showDialog(
      context: currentContext,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SettingsModalContent(
            onClose: () {
              Navigator.of(dialogContext).pop();
            },
          ),
        );
      },
    );
    await _loadPlayerStatusAndUpdateGame();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Background(
          gender: widget.gender,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_currentImagePathsForGame.isEmpty && !_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Susun Langkah Toilet")),
        body: Background(
          gender: widget.gender,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tidak ada gambar yang dapat dimuat untuk game saat ini.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.red.shade800),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: Text("Kembali"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Background(
        gender: widget.gender,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Header(
                    onTapBack: () {
                      Get.off(() => const LevelOneStartScreen());
                    },
                    title: "Susun Langkah Toilet",
                    onTapSettings: _showSettingsModal,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: GameWidget(
                    key: _gameKey,
                    game: ToiletSortGame(
                      context: context,
                      gender: widget.gender,
                      isFocused: _currentIsFocused,
                      imagePaths: List.from(_currentImagePathsForGame),
                      confettiController: _confettiController,
                    ),
                    overlayBuilderMap: {
                      'checkButton': (ctx, game) {
                        final toiletGame = game as ToiletSortGame;
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: ElevatedButton(
                              onPressed:
                                  toiletGame.isLoading
                                      ? null
                                      : toiletGame.checkOrder,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    widget.gender == 'laki-laki'
                                        ? const Color(0xFFC2E0FF)
                                        : const Color(0xFFFFDDD2),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 15,
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                foregroundColor:
                                    widget.gender == 'laki-laki'
                                        ? const Color(0xFF52AACA)
                                        : const Color(0xFFFC9D99),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: const Text("Periksa Urutan"),
                            ),
                          ),
                        );
                      },
                    },
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                ],
                gravity: 0.3,
                emissionFrequency: 0.05,
                numberOfParticles: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
