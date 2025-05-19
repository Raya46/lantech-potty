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
import 'package:toilet_training/widgets/header.dart';
import 'package:toilet_training/screens/levels/level2/level2_start_screen.dart';

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
    _player = await getPlayer();
  }

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _loadPlayer();
    _loadItems();
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
    try {
      _player!.level2Score = stars;
      await updatePlayer(_player!);
    } catch (e) {}
  }

  void _checkAnswer(BathroomItem selectedItem) {
    if (_answered) return;

    bool isCorrect = selectedItem.id == _correctItem!.id;
    int starsEarned = 0;

    if (isCorrect) {
      _feedbackMessage = "Hebat!";
      _confettiController.play();
      starsEarned = _calculateStars(_wrongAttemptsInQuestion);
      _saveScore(starsEarned);
    } else {
      _wrongAttemptsInQuestion++;
      _feedbackMessage =
          "Oops, itu bukan ${_correctItem!.name}. Coba perhatikan lagi!";
    }

    if (mounted) {
      setState(() {
        _answered = true;
      });
    }

    Widget starDisplay = Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Icon(
          index < starsEarned ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 30,
        );
      }),
    );

    Get.defaultDialog(
      title: isCorrect ? "Luar Biasa! 🎉" : "Coba Lagi Yuk!",
      titleStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: isCorrect ? Colors.green : Colors.orange,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isCorrect)
            Image.asset(
              _player!.gender == 'perempuan'
                  ? 'assets/images/female-happy.png'
                  : 'assets/images/male-happy.png',
              height: 100,
            ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text(
                _feedbackMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              if (isCorrect) ...[
                Text(
                  _correctItem!.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                starDisplay,
              ],
            ],
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isCorrect ? Colors.green : Colors.orange,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Get.back();
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
          child: Text(isCorrect ? "Main Lagi" : "Ulangi"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isCorrect ? Colors.green : Colors.orange,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Get.off(() => const LevelThreeStartScreen());
          },
          child: Text("Lanjut Level 3"),
        ),
      ],
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                                      return GestureDetector(
                                        onTap: () => _checkAnswer(item),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            border: Border.all(
                                              color:
                                                  _answered &&
                                                          item.id ==
                                                              _correctItem?.id
                                                      ? Colors.green
                                                      : _answered &&
                                                          item.id !=
                                                              _correctItem?.id
                                                      ? Colors.red
                                                      : Colors.grey[300]!,
                                              width: _answered ? 3 : 1.5,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(
                                                  0.3,
                                                ),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Image.asset(
                                              item.image,
                                              fit: BoxFit.contain,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return const Center(
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    size: 40,
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
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
