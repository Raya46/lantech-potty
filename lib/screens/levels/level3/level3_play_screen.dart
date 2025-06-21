import 'dart:convert';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sizer/sizer.dart';
import 'package:toilet_training/models/player.dart';
import 'package:toilet_training/models/scene_object.dart';
import 'package:toilet_training/screens/levels/level3/level3_start_screen.dart';
import 'package:toilet_training/screens/levels/level4/level4_start_screen.dart';
import 'package:toilet_training/services/player_service.dart';
import 'package:toilet_training/widgets/background.dart';
import 'package:toilet_training/widgets/header.dart';
import 'package:toilet_training/widgets/modal_result.dart';
import 'package:toilet_training/widgets/scene_object_guess_card.dart';

class LevelThreePlayScreen extends StatefulWidget {
  const LevelThreePlayScreen({super.key});

  @override
  State<LevelThreePlayScreen> createState() => _LevelThreePlayScreenState();
}

class _LevelThreePlayScreenState extends State<LevelThreePlayScreen> {
  Player? _player;
  List<SceneObjectData> _allItems = [];
  List<SceneObjectData> _correctItems = [];
  List<SceneObjectData> _currentChoices = [];
  Set<String> _foundItemIds = {};
  bool _isLoading = true;
  String _feedbackMessage = "";
  bool _levelFinished = false;
  late ConfettiController _confettiController;
  int _wrongAttemptsInQuestion = 0;
  final _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    await _loadPlayer();
    await _loadItems();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadPlayer() async {
    try {
      Player playerData = await getPlayer();
      if (mounted) {
        setState(() {
          _player = playerData;
          _player?.level3Score ??= 0;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _player = Player(null)..level3Score = 0;
        });
      }
    }
  }

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final String response = await rootBundle.loadString(
        'lib/models/static/random-things-static.json',
      );
      final List<dynamic> data = json.decode(response);
      if (mounted) {
        setState(() {
          _allItems =
              data.map((item) => SceneObjectData.fromJson(item)).toList();
          _isLoading = false;
          _setupNewQuestion();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _feedbackMessage = "Gagal memuat data permainan.";
        });
      }
    }
  }

  void _setupNewQuestion() {
    if (_allItems.isEmpty) return;
    if (mounted) {
      setState(() {
        _levelFinished = false;
        _feedbackMessage = "";
        _wrongAttemptsInQuestion = 0;
        _correctItems.clear();
        _foundItemIds.clear();

        final random = Random();
        const bathroomItemIds = {1, 2, 4, 5, 6, 8, 9};

        final bathroomItems =
            _allItems
                .where(
                  (item) =>
                      bathroomItemIds.contains(int.tryParse(item.id) ?? -1),
                )
                .toList();
        final distractors =
            _allItems
                .where(
                  (item) =>
                      !bathroomItemIds.contains(int.tryParse(item.id) ?? -1),
                )
                .toList();

        bathroomItems.shuffle(random);
        distractors.shuffle(random);

        _correctItems = bathroomItems.take(3).toList();

        final currentDistractors = distractors.take(5).toList();

        _currentChoices = [..._correctItems, ...currentDistractors];
        _currentChoices.shuffle(random);
      });
    }
  }

  int _calculateStars(int wrongAttempts) {
    if (wrongAttempts <= 1) return 3;
    if (wrongAttempts <= 4) return 2;
    return 1;
  }

  Future<void> _saveScore(int stars) async {
    if (_player == null) return;
    try {
      _player!.level3Score = stars;
      await updatePlayer(_player!);
    } catch (e) {}
  }

  Future<void> _playSound(String soundPath) async {
    if (_audioPlayer.playing) {
      await _audioPlayer.stop();
    }
    try {
      await _audioPlayer.setAsset(soundPath);
      _audioPlayer.play();
    } catch (e) {}
  }

  void _checkAnswer(SceneObjectData selectedItem) {
    if (_levelFinished || _foundItemIds.contains(selectedItem.id)) return;

    final bool isCorrect = _correctItems.any(
      (item) => item.id == selectedItem.id,
    );

    if (isCorrect) {
      setState(() {
        _foundItemIds.add(selectedItem.id);
      });

      if (_foundItemIds.length == _correctItems.length) {
        setState(() {
          _levelFinished = true;
        });
        _feedbackMessage = "Hebat! Kamu menemukan semua benda.";
        _confettiController.play();
        int starsEarned = _calculateStars(_wrongAttemptsInQuestion);
        _saveScore(starsEarned);
        if (starsEarned >= 2) {
          _playSound(
            starsEarned == 3
                ? 'assets/sounds/3_bintang.mp3'
                : 'assets/sounds/2_bintang.mp3',
          );
        }

        ModalResult.show(
          context: context,
          title: "Luar Biasa! 🎉",
          message: _feedbackMessage,
          starsEarned: starsEarned,
          isSuccess: true,
          playerGender: _player?.gender,
          primaryActionText: "Main Lagi",
          onPrimaryAction: _setupNewQuestion,
          secondaryActionText: "Lanjut Level 4",
          onSecondaryAction: () {
            Get.off(() => const LevelFourStartScreen());
          },
        );
      }
    } else {
      _wrongAttemptsInQuestion++;
      _feedbackMessage =
          "Oops, itu bukan salah satu target. Coba perhatikan lagi!";
      _playSound('assets/sounds/wrong-answer.mp3');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_feedbackMessage),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_player == null || _isLoading) {
      return Scaffold(
        body: Background(
          gender: _player?.gender ?? 'laki-laki',
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Background(
            gender: _player!.gender!,
            child: Column(
              children: [
                Header(
                  onTapBack: () {
                    Get.off(() => const LevelThreeStartScreen());
                  },
                  title: "Level 3",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Temukan 3 benda berikut:",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF8B5A2B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_correctItems.isNotEmpty)
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          alignment: WrapAlignment.center,
                          children:
                              _correctItems.map((item) {
                                final isFound = _foundItemIds.contains(item.id);
                                return Chip(
                                  label: Text(
                                    item.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      decoration:
                                          isFound
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                    ),
                                  ),
                                  backgroundColor:
                                      isFound ? Colors.green : Colors.blueGrey,
                                );
                              }).toList(),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child:
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _allItems.isEmpty && !_isLoading
                          ? Center(
                            child: Text(
                              _feedbackMessage.isNotEmpty
                                  ? _feedbackMessage
                                  : "Tidak ada data permainan.",
                            ),
                          )
                          : _correctItems.isEmpty
                          ? const Center(child: Text("Memuat pertanyaan..."))
                          : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 2,
                                  ),
                              itemCount: _currentChoices.length,
                              itemBuilder: (context, index) {
                                final item = _currentChoices[index];
                                final isCorrect = _correctItems.any(
                                  (c) => c.id == item.id,
                                );
                                return SceneObjectGuessCard(
                                  onTap: () => _checkAnswer(item),
                                  answered:
                                      _levelFinished ||
                                      _foundItemIds.contains(item.id),
                                  item: item,
                                  correctItem:
                                      isCorrect ? item : _correctItems.first,
                                );
                              },
                            ),
                          ),
                ),
              ],
            ),
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
    );
  }
}
