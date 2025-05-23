import 'dart:convert';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:toilet_training/models/bathroom_item.dart';
import 'package:toilet_training/models/player.dart';
import 'package:toilet_training/screens/levels/level3/level3_start_screen.dart';
import 'package:toilet_training/services/player_service.dart';
import 'package:toilet_training/widgets/background.dart';
import 'package:toilet_training/widgets/bathroom_guess_card.dart';
import 'package:toilet_training/widgets/header.dart';
import 'package:toilet_training/screens/levels/level2/level2_start_screen.dart';
import 'package:toilet_training/widgets/modal_result.dart';

class LevelTwoPlayScreen extends StatefulWidget {
  const LevelTwoPlayScreen({super.key});

  @override
  State<LevelTwoPlayScreen> createState() => _LevelTwoPlayScreenState();
}

class _LevelTwoPlayScreenState extends State<LevelTwoPlayScreen> {
  Player? _player;
  List<BathroomItem> _allItems = [];
  BathroomItem? _correctItem;
  List<BathroomItem> _currentChoices = [];
  bool _isLoading = true;
  String _feedbackMessage = "";
  bool _answered = false;
  late ConfettiController _confettiController;
  int _wrongAttemptsInQuestion = 0;

  Future<void> _loadPlayer() async {
    Player playerData = await getPlayer();
    if (mounted) {
      setState(() {
        _player = playerData;
      });
    }
  }

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
    super.dispose();
  }

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final String response = await rootBundle.loadString(
        'lib/models/static/bathroom-data-static.json',
      );
      final List<dynamic> data = json.decode(response);
      if (mounted) {
        setState(() {
          _allItems = data.map((item) => BathroomItem.fromJson(item)).toList();
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
    _answered = false;
    _feedbackMessage = "";
    _wrongAttemptsInQuestion = 0;
    final random = Random();

    _correctItem = _allItems[random.nextInt(_allItems.length)];

    List<BathroomItem> distractors = [];
    List<BathroomItem> tempList = List.from(_allItems);
    tempList.removeWhere((item) => item.id == _correctItem!.id);

    while (distractors.length < 2 && tempList.isNotEmpty) {
      final distractor = tempList.removeAt(random.nextInt(tempList.length));
      distractors.add(distractor);
    }

    while (distractors.length < 2 &&
        _allItems.length > distractors.length + 1) {
      BathroomItem potentialDistractor;
      do {
        potentialDistractor = _allItems[random.nextInt(_allItems.length)];
      } while (potentialDistractor.id == _correctItem!.id ||
          distractors.any((d) => d.id == potentialDistractor.id));
      distractors.add(potentialDistractor);
    }

    _currentChoices = [_correctItem!, ...distractors];
    _currentChoices.shuffle(random);
    if (mounted) {
      setState(() {});
    }
  }

  int _calculateStars(int wrongAttempts) {
    if (wrongAttempts == 0) return 3;
    if (wrongAttempts <= 2) return 2;
    return 1;
  }

  Future<void> _saveScore(int stars) async {
    _player!.level2Score = stars;
    await updatePlayer(_player!);
  }

  void _checkAnswer(BathroomItem selectedItem) {
    if (_answered) return;

    bool isCorrect = selectedItem.id == _correctItem!.id;
    int starsEarned = 0;
    String dialogTitle;
    String currentFeedbackMessage;

    if (isCorrect) {
      _feedbackMessage =
          "Hebat! Benda yang benar adalah ${_correctItem!.name}.";
      currentFeedbackMessage =
          "Hebat! Benda yang benar adalah ${_correctItem!.name}.";
      dialogTitle = "Luar Biasa! 🎉";
      _confettiController.play();
      starsEarned = _calculateStars(_wrongAttemptsInQuestion);
      _saveScore(starsEarned);
    } else {
      _wrongAttemptsInQuestion++;
      _feedbackMessage =
          "Oops, itu bukan ${_correctItem!.name}. Coba perhatikan lagi!";
      currentFeedbackMessage =
          "Oops, itu bukan ${_correctItem!.name}. Coba perhatikan lagi!";
      dialogTitle = "Coba Lagi Yuk!";
    }

    if (mounted) {
      setState(() {
        _answered = true;
      });
    }

    ModalResult.show(
      context: context,
      title: dialogTitle,
      message: currentFeedbackMessage,
      starsEarned: starsEarned,
      isSuccess: isCorrect,
      playerGender: _player?.gender,
      primaryActionText: isCorrect ? "Main Lagi" : "Ulangi",
      onPrimaryAction: () {
        if (isCorrect) {
          _setupNewQuestion();
        } else {
          if (mounted) {
            setState(() {
              _answered = false;
              _feedbackMessage = "";
            });
          }
        }
      },
      secondaryActionText: isCorrect ? "Lanjut Level 3" : null,
      onSecondaryAction:
          isCorrect
              ? () {
                Get.off(() => const LevelThreeStartScreen());
              }
              : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_player == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
                    Get.off(() => const LevelTwoStartScreen());
                  },
                  title: "Level 2: Kenali Benda",
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
                          : _correctItem == null
                          ? const Center(child: Text("Memuat pertanyaan..."))
                          : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Temukan gambar dari : ${_correctItem!.name}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF480A4),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 15,
                                          mainAxisSpacing: 15,
                                          childAspectRatio: 1,
                                        ),
                                    itemCount: _currentChoices.length,
                                    itemBuilder: (context, index) {
                                      final item = _currentChoices[index];
                                      return BathroomGuessCard(
                                        onTap: () => _checkAnswer(item),
                                        answered: _answered,
                                        item: item,
                                        correctItem: _correctItem!,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
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
