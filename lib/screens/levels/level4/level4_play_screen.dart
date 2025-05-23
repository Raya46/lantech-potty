import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:toilet_training/models/player.dart';
import 'package:toilet_training/models/step.dart';
import 'package:toilet_training/services/player_service.dart';
import 'package:toilet_training/widgets/background.dart';
import 'package:toilet_training/widgets/build_option_card.dart';
import 'package:toilet_training/widgets/build_step_card.dart';
import 'package:toilet_training/widgets/header.dart';
import 'package:toilet_training/widgets/modal_setting.dart';
import 'package:get/get.dart';
import 'package:toilet_training/screens/levels/level4/level4_start_screen.dart';
import 'package:toilet_training/widgets/modal_result.dart';
import 'package:confetti/confetti.dart';

class LevelFourPlayScreen extends StatefulWidget {
  const LevelFourPlayScreen({super.key});

  @override
  State<LevelFourPlayScreen> createState() => _LevelFourPlayScreenState();
}

class _LevelFourPlayScreenState extends State<LevelFourPlayScreen> {
  List<ToiletStep> _steps = [];
  int currentStepIndex = 0;
  ToiletStep? _droppedStepOnTarget;
  int _wrongAttempts = 0;

  Player? _player;
  bool _isLoadingPlayer = true;
  String? _selectedTypeForMale;
  bool _hasSelectedTypeForMale = false;
  bool _isChoosingMaleType = false;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _initializeScreen();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _initializeScreen() async {
    await _loadPlayerData();
    if (_player == null) {
      if (mounted) setState(() => _isLoadingPlayer = false);
      return;
    }
    _wrongAttempts = 0;
    _player!.level4Score ??= 0;

    if (_player!.gender == 'laki-laki' && !_hasSelectedTypeForMale) {
      if (mounted) {
        setState(() {
          _isChoosingMaleType = true;
        });
      }
    } else {
      await loadSteps();
    }
  }

  Future<void> _loadPlayerData() async {
    if (mounted) setState(() => _isLoadingPlayer = true);
    try {
      _player = await getPlayer();
      _player!.gender ??= 'laki-laki';
      _player!.isFocused ??= false;
      _player!.level4Score ??= 0;
    } catch (e) {
      _player =
          Player(null)
            ..gender = 'laki-laki'
            ..isFocused = false
            ..level4Score = 0;
      await savePlayer(_player!);
    }
    if (mounted) setState(() => _isLoadingPlayer = false);
  }

  Future<void> loadSteps() async {
    if (_player == null) {
      return;
    }
    if (_player!.gender == 'laki-laki' && _selectedTypeForMale == null) {
      if (mounted) setState(() => _isChoosingMaleType = true);
      return;
    }
    _wrongAttempts = 0;

    final String response = await rootBundle.loadString(
      'lib/models/static/step-static.json',
    );
    final List<dynamic> data = json.decode(response);
    if (mounted) {
      List<ToiletStep> filteredSteps =
          data.map((e) => ToiletStep.fromJson(e)).where((step) {
            bool genderMatch = step.gender == _player!.gender;
            bool focusMatch = step.focus == _player!.isFocused;
            bool typeMatch = true;
            if (_player!.gender == 'laki-laki') {
              typeMatch = step.type == _selectedTypeForMale;
            }
            return genderMatch && focusMatch && typeMatch;
          }).toList();

      filteredSteps.sort((a, b) => a.id.compareTo(b.id));

      setState(() {
        _steps = filteredSteps;
        currentStepIndex = 0;
        _droppedStepOnTarget = null;
        _isLoadingPlayer = false;
        _isChoosingMaleType = false;
        if (_player!.gender == 'laki-laki') {
          _hasSelectedTypeForMale = _selectedTypeForMale != null;
        } else {
          _hasSelectedTypeForMale = true;
        }
      });

      if (_steps.isEmpty) {}
    }
  }

  void _onMaleTypeSelected(String type) {
    if (mounted) {
      setState(() {
        _selectedTypeForMale = type;
        _isChoosingMaleType = false;
        _hasSelectedTypeForMale = true;
        _isLoadingPlayer = true;
        _wrongAttempts = 0;
      });
    }
    loadSteps();
  }

  Widget _buildMaleTypeSelectionUI() {
    return Column(
      children: [
        Header(
          onTapBack: () => Get.off(() => const LevelFourStartScreen()),
          title: "Level 4",
          onTapSettings: () => _showSettingsModal(context),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Pilih jenis aktivitas:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B5A2B),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFA07A),
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    onPressed: () => _onMaleTypeSelected('bab'),
                    child: Text(
                      "Buang Air Besar (BAB)",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFA07A),
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    onPressed: () => _onMaleTypeSelected('bak'),
                    child: Text(
                      "Buang Air Kecil (BAK)",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  int _calculateStars(int wrongAttempts) {
    if (wrongAttempts == 0) {
      return 3;
    } else if (wrongAttempts <= 2) {
      return 2;
    } else {
      return 1;
    }
  }

  Future<void> _saveScore(int stars) async {
    if (_player == null) return;
    _player!.level4Score = stars;
    await updatePlayer(_player!);
  }

  Future<void> _playSoundForResult(int starsEarned) async {
    String? soundPath;
    if (starsEarned == 3) {
      soundPath = 'assets/sounds/3_bintang.mp3';
    } else if (starsEarned == 2) {
      soundPath = 'assets/sounds/2_bintang.mp3';
    } else if (starsEarned == 1) {
      soundPath = 'assets/sounds/belum_berhasil.mp3';
    }

    if (soundPath != null) {
      final audioPlayer = AudioPlayer();
      try {
        await audioPlayer.setAsset(soundPath);
        audioPlayer.play();
        audioPlayer.processingStateStream.listen((state) {
          if (state == ProcessingState.completed) {
            audioPlayer.dispose();
          }
        });
      } catch (e) {
        audioPlayer.dispose();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingPlayer || _player == null) {
      return Scaffold(
        body: Background(
          gender: _player?.gender ?? 'laki-laki',
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_isChoosingMaleType) {
      return Scaffold(
        body: Background(
          gender: _player!.gender!,
          child: _buildMaleTypeSelectionUI(),
        ),
      );
    }

    if (_steps.isEmpty &&
        (_hasSelectedTypeForMale || _player!.gender != 'laki-laki')) {
      return Scaffold(
        body: Background(
          gender: _player!.gender!,
          child: Column(
            children: [
              Header(
                onTapBack: () {
                  Get.off(() => const LevelFourStartScreen());
                },
                title: "Level 4",
                onTapSettings: () => _showSettingsModal(context),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Tidak ada langkah yang sesuai dengan pilihanmu.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF8B5A2B),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Gender: ${_player!.gender}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF8B5A2B),
                        ),
                      ),
                      Text(
                        "Mode Fokus: ${_player!.isFocused == true ? 'Aktif' : 'Nonaktif'}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF8B5A2B),
                        ),
                      ),
                      if (_player!.gender == 'laki-laki')
                        Text(
                          "Tipe: ${_selectedTypeForMale?.toUpperCase() ?? 'N/A'}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF8B5A2B),
                          ),
                        ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              _isLoadingPlayer = true;
                              _hasSelectedTypeForMale = false;
                              _selectedTypeForMale = null;
                              _steps.clear();
                              _wrongAttempts = 0;
                            });
                          }
                          _initializeScreen();
                        },
                        child: Text("Coba Lagi / Ganti Pengaturan"),
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
    if (_steps.isEmpty && !_isLoadingPlayer) {
      return Scaffold(
        body: Background(
          gender: _player!.gender!,
          child: Center(
            child: CircularProgressIndicator(
              semanticsLabel: "Memuat langkah...",
            ),
          ),
        ),
      );
    }

    final currentStep = _steps[currentStepIndex];
    final nextStep =
        (currentStepIndex + 1 < _steps.length)
            ? _steps[currentStepIndex + 1]
            : null;

    List<ToiletStep> options = [];
    if (nextStep != null) {
      options.add(nextStep);
      final others =
          _steps
              .where((s) => s.id != nextStep.id && s.id != currentStep.id)
              .toList();
      others.shuffle();
      options.addAll(others.take(2));
      while (options.length > 3) {
        options.removeLast();
      }
      options.shuffle();
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
                    Get.off(() => const LevelFourStartScreen());
                  },
                  title: "Level 4",
                  onTapSettings: () => _showSettingsModal(context),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Apa Langkah Selanjutnya?",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B5A2B),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BuildStepCard(step: currentStep),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30.0,
                              ),
                              child: Icon(
                                Icons.arrow_forward,
                                color: Color(0xFFF9A6A6),
                                size: 60,
                              ),
                            ),
                            DragTarget<ToiletStep>(
                              builder: (context, candidateData, rejectedData) {
                                if (_droppedStepOnTarget != null) {
                                  return BuildStepCard(
                                    step: _droppedStepOnTarget!,
                                  );
                                }
                                return Container(
                                  width: 100,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color:
                                        candidateData.isNotEmpty
                                            ? Color(0xFFFFF6E6).withOpacity(0.7)
                                            : Color(0xFFFFF6E6),
                                    border: Border.all(
                                      color:
                                          candidateData.isNotEmpty
                                              ? Color(0xFFF9A6A6)
                                              : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Ayo tarik\njawaban mu\nkesini",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4A2C2A),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              onWillAccept: (data) {
                                return _droppedStepOnTarget == null;
                              },
                              onAccept: (droppedStep) {
                                if (nextStep != null &&
                                    droppedStep.id == nextStep.id) {
                                  setState(() {
                                    _droppedStepOnTarget = droppedStep;
                                  });

                                  bool isFinalStepInSequenceDropped =
                                      (currentStepIndex + 1 ==
                                          _steps.length - 1);

                                  if (isFinalStepInSequenceDropped) {
                                    Future.delayed(Duration(seconds: 1), () {
                                      if (mounted) {
                                        setState(() {
                                          currentStepIndex++;
                                        });
                                        _saveScore(
                                          _calculateStars(_wrongAttempts),
                                        );
                                        _showCompletionDialog(
                                          "Level 4 Selesai!",
                                        );
                                      }
                                    });
                                  } else {
                                    Future.delayed(Duration(seconds: 1), () {
                                      if (mounted) {
                                        setState(() {
                                          currentStepIndex++;
                                          _droppedStepOnTarget = null;
                                        });
                                      }
                                    });
                                  }
                                } else {
                                  if (mounted) {
                                    setState(() {
                                      _wrongAttempts++;
                                    });
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Bukan itu langkahnya, coba lagi!",
                                      ),
                                      backgroundColor: Colors.orange,
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        if (nextStep != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                options
                                    .map(
                                      (step) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: BuildOptionCard(step: step),
                                      ),
                                    )
                                    .toList(),
                          )
                        else if (_steps.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _steps.isNotEmpty &&
                                      currentStepIndex >= _steps.length - 1 &&
                                      _droppedStepOnTarget != null
                                  ? "Kerja Bagus!"
                                  : "Pilih langkah yang benar!",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF8B5A2B),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
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

  void _showSettingsModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SettingsModalContent(
            onClose: () async {
              Navigator.of(dialogContext).pop();

              await Future.delayed(const Duration(milliseconds: 300));

              if (!mounted) return;

              setState(() {
                _isLoadingPlayer = true;
              });
              _initializeScreen();
            },
          ),
        );
      },
    );
  }

  void _showCompletionDialog(String message) {
    int starsEarned = _calculateStars(_wrongAttempts);

    String completionMessage =
        _wrongAttempts > 0
            ? "Kamu menyelesaikan dengan $_wrongAttempts kesalahan."
            : "Kamu hebat! Semua langkah sudah benar.";

    _playSoundForResult(starsEarned);

    ModalResult.show(
      context: context,
      title: "Selamat!",
      message: "$message\n$completionMessage",
      starsEarned: starsEarned,
      isSuccess: true,
      playerGender: _player?.gender,
      primaryActionText: "OK",
      confettiController: _confettiController,
      onPrimaryAction: () {
        if (_player?.gender == 'laki-laki') {
          if (mounted) {
            setState(() {
              _isLoadingPlayer = true;
              _hasSelectedTypeForMale = false;
              _selectedTypeForMale = null;
              _steps.clear();
              currentStepIndex = 0;
              _droppedStepOnTarget = null;
              _wrongAttempts = 0;
            });
          }
          _initializeScreen();
        } else {
          Get.off(() => const LevelFourStartScreen());
        }
      },
    );
  }
}
