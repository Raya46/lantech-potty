import 'dart:convert';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:toilet_training/screens/levels/level3_screen.dart';
import 'package:toilet_training/widgets/background.dart';
import 'package:toilet_training/widgets/header.dart';

class BathroomItem {
  final int id;
  final String name;
  final String image;

  BathroomItem({required this.id, required this.name, required this.image});

  factory BathroomItem.fromJson(Map<String, dynamic> json) {
    return BathroomItem(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}

class LevelTwoScreen extends StatefulWidget {
  const LevelTwoScreen({super.key});

  @override
  State<LevelTwoScreen> createState() => _LevelTwoScreenState();
}

class _LevelTwoScreenState extends State<LevelTwoScreen> {
  final String currentGender = 'female'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        gender: currentGender,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2, 
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Image.asset(
                    'assets/images/female-happy.png', 
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
                  crossAxisAlignment:
                      CrossAxisAlignment.center, 
                  children: [
                    Stack(
                      children: [
                        Text(
                          "Level 2",
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
                          "Level 2",
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
                          "Tentukan Benda yang Tepat",
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
                          "Tentukan Benda yang Tepat",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFA07A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(right: 100.0),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(
                              () => const LevelTwoFocusScreen(),
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
      ),
    );
  }
}

class LevelTwoFocusScreen extends StatefulWidget {
  const LevelTwoFocusScreen({super.key});

  @override
  State<LevelTwoFocusScreen> createState() => _LevelTwoFocusScreenState();
}

class _LevelTwoFocusScreenState extends State<LevelTwoFocusScreen> {
  List<BathroomItem> _allItems = [];
  BathroomItem? _correctItem;
  List<BathroomItem> _currentChoices = [];
  bool _isLoading = true;
  String _feedbackMessage = "";
  bool _answered = false;
  final String currentGender = 'female'; 
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _loadItems();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    try {
      final String response = await rootBundle.loadString(
        'lib/models/static/bathroom-data-static.json',
      );
      final List<dynamic> data = json.decode(response);
      setState(() {
        _allItems = data.map((item) => BathroomItem.fromJson(item)).toList();
        _isLoading = false;
        _setupNewQuestion();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _feedbackMessage = "Gagal memuat data permainan.";
      });
      print('Error loading bathroom items: $e');
    }
  }

  void _setupNewQuestion() {
    if (_allItems.isEmpty) return;
    _answered = false;
    _feedbackMessage = "";
    final random = Random();

    _correctItem = _allItems[random.nextInt(_allItems.length)];

    List<BathroomItem> distractors = [];
    List<BathroomItem> tempList = List.from(_allItems);
    tempList.removeWhere(
      (item) => item.id == _correctItem!.id,
    ); 

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

    setState(() {});
  }

  void _checkAnswer(BathroomItem selectedItem) {
    if (_answered) return; 

    setState(() {
      _answered = true;
      if (selectedItem.id == _correctItem!.id) {
        _feedbackMessage = "Hebat! Kamu Benar!";
        _confettiController.play(); 
        Get.defaultDialog(
          title: "Luar Biasa! 🎉",
          titleStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/female-happy.png',
                height: 100,
              ), 
              const SizedBox(height: 15),
              Text(
                _feedbackMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              Text(
                "Ini adalah ${_correctItem!.name}.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          confirm: Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Get.back();
                  _setupNewQuestion();
                },
                child: const Text("Ulangi level 2!"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Get.to(() => const LevelThreeScreen());
                },
                child: const Text("Lanjut Level 3!"),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      } else {
        _feedbackMessage =
            "Oops, itu bukan ${_correctItem!.name}. Coba perhatikan lagi!";
        Get.defaultDialog(
          title: "Coba Lagi Yuk!",
          titleStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
          middleText: _feedbackMessage,
          middleTextStyle: const TextStyle(fontSize: 18, color: Colors.black87),
          confirm: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Get.back();
                  setState(() {
                    _answered = false;
                    _feedbackMessage = "";
                  });
                },
                child: const Text("Ulangi"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Get.to(() => const LevelThreeScreen());
                },
                child: const Text("Lanjut level 3 aja!"),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(
            gender: currentGender,
            child: Column(
              children: [
                Header(
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
                          : Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Temukan gambar dari : ${_correctItem!.name}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF480A4),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                          0.1,
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
                                              borderRadius:
                                                  BorderRadius.circular(15),
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
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                20.0,
                                              ),
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
