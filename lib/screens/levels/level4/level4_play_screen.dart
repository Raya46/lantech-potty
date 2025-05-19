import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toilet_training/models/player.dart';
import 'package:toilet_training/models/step.dart';
import 'package:toilet_training/services/player_service.dart';
import 'package:toilet_training/widgets/background.dart';
import 'package:toilet_training/widgets/header.dart';
import 'package:toilet_training/widgets/modal_setting.dart';
import 'package:get/get.dart';
import 'package:toilet_training/screens/levels/level4/level4_start_screen.dart';

class LevelFourPlayScreen extends StatefulWidget {
  const LevelFourPlayScreen({super.key});

  @override
  State<LevelFourPlayScreen> createState() => _LevelFourPlayScreenState();
}

class _LevelFourPlayScreenState extends State<LevelFourPlayScreen> {
  List<ToiletStep> _steps = [];
  int currentStepIndex = 0;
  ToiletStep? _droppedStepOnTarget;
  int _wrongAttempts = 0; // Variabel untuk melacak kesalahan

  Player? _player;
  bool _isLoadingPlayer = true;
  String? _selectedTypeForMale;
  bool _hasSelectedTypeForMale = false;
  bool _isChoosingMaleType = false;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    await _loadPlayerData();
    if (_player == null) {
      if (mounted) setState(() => _isLoadingPlayer = false);
      return;
    }
    _wrongAttempts = 0; // Reset kesalahan
    _player!.level4Score ??= 0; // Inisialisasi skor jika null

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
      _player!.level4Score ??= 0; // Inisialisasi skor level 4 jika null
    } catch (e) {
      _player =
          Player(null)
            ..gender = 'laki-laki'
            ..isFocused = false
            ..level4Score = 0; // Set skor default
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
    _wrongAttempts = 0; // Reset kesalahan setiap kali langkah baru dimuat

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

      if (_steps.isEmpty) {
      }
    }
  }

  void _onMaleTypeSelected(String type) {
    if (mounted) {
      setState(() {
        _selectedTypeForMale = type;
        _isChoosingMaleType = false;
        _hasSelectedTypeForMale = true;
        _isLoadingPlayer = true;
        _wrongAttempts = 0; // Reset kesalahan saat tipe baru dipilih
      });
    }
    loadSteps();
  }

  Widget _buildMaleTypeSelectionUI() {
    return Center(
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
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
    );
  }

  // Fungsi untuk menghitung bintang
  int _calculateStars(int wrongAttempts) {
    if (wrongAttempts == 0) {
      return 3; // Sempurna
    } else if (wrongAttempts <= 2) {
      // Misal, 1-2 kesalahan
      return 2;
    } else {
      // Lebih dari 2 kesalahan
      return 1;
    }
  }

  // Fungsi untuk menyimpan skor
  Future<void> _saveScore(int stars) async {
    if (_player == null) return;
    try {
      _player!.level4Score = stars; // Simpan skor untuk Level 4
      await updatePlayer(_player!);
    } catch (e) {
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
      // Jika steps masih kosong setelah loading selesai
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
      while (options.length > 3) options.removeLast();
      options.shuffle();
    }

    return Scaffold(
      body: Background(
        gender: _player!.gender!,
        child: Column(
          children: [
            Header(
              onTapBack: (){
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
                      "Apa Langkah Selanjutnya?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B5A2B),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStepCard(currentStep),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Color(0xFFF9A6A6),
                            size: 60,
                          ),
                        ),
                        DragTarget<ToiletStep>(
                          builder: (context, candidateData, rejectedData) {
                            if (_droppedStepOnTarget != null) {
                              return _buildStepCard(_droppedStepOnTarget!);
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
                              // Correct drop
                              setState(() {
                                _droppedStepOnTarget =
                                    droppedStep; // Show the dropped step in the target
                              });

                              // Check if the step just dropped was the very last step of the sequence
                              // currentStepIndex points to the item on the left.
                              // nextStep (which is droppedStep) is _steps[currentStepIndex + 1].
                              // So, if _steps[currentStepIndex + 1] is the last item, its index is _steps.length - 1.
                              // This means currentStepIndex + 1 == _steps.length - 1.
                              bool isFinalStepInSequenceDropped =
                                  (currentStepIndex + 1 == _steps.length - 1);

                              if (isFinalStepInSequenceDropped) {
                                Future.delayed(Duration(seconds: 1), () {
                                  if (mounted) {
                                    setState(() {
                                      // Advance currentStepIndex to the last item, so the left card updates.
                                      currentStepIndex++; // Now currentStepIndex == _steps.length - 1
                                      // _droppedStepOnTarget remains showing the correctly dropped final item.
                                    });
                                    _saveScore(_calculateStars(_wrongAttempts));
                                    _showCompletionDialog("Level 4 Selesai!");
                                  }
                                });
                              } else {
                                // Not the final step, so advance to display the next pair.
                                Future.delayed(Duration(seconds: 1), () {
                                  if (mounted) {
                                    setState(() {
                                      currentStepIndex++;
                                      _droppedStepOnTarget =
                                          null; // Clear the target for the next interaction
                                    });
                                  }
                                });
                              }
                            } else {
                              // Incorrect drop
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
                                    child: _buildOptionCard(step),
                                  ),
                                )
                                .toList(),
                      )
                    else if (_steps
                        .isNotEmpty) // Hanya tampilkan jika steps ada dan sudah selesai
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
    showDialog(
      context: context,
      barrierDismissible: false, // User harus menekan tombol
      builder: (ctx) {
        int starsEarned = _calculateStars(_wrongAttempts);
        Widget starDisplay = Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Icon(
              index < starsEarned ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 30, // Ukuran bintang bisa disesuaikan
            );
          }),
        );

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFFFF0E1),
          title: Center(
            child: Text(
              "Selamat!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFD98555),
                fontSize: 22,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                message, // "Level 4 Selesai!"
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Color(0xFFD98555)),
              ),
              SizedBox(height: 15),
              Text(
                // Tambahkan informasi kesalahan jika ada, atau pesan umum jika tidak ada kesalahan
                _wrongAttempts > 0
                    ? "Kamu menyelesaikan dengan $_wrongAttempts kesalahan."
                    : "Kamu hebat! Semua langkah sudah benar.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Color(0xFF8B5A2B)),
              ),
              SizedBox(height: 10),
              starDisplay, // Tampilkan bintang
              SizedBox(height: 5),
              Text(
                "Kamu mendapatkan $starsEarned bintang!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF8B5A2B),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5C9A4A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                ),
                child: Text(
                  "OK",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  // Kembali ke pemilihan level atau reset level ini dengan tipe lain jika laki-laki
                  if (_player?.gender == 'laki-laki') {
                    setState(() {
                      _isLoadingPlayer = true; // Untuk memicu loading
                      _hasSelectedTypeForMale =
                          false; // Kembali ke pemilihan tipe BAB/BAK
                      _selectedTypeForMale = null;
                      _steps.clear();
                      currentStepIndex = 0;
                      _droppedStepOnTarget = null;
                    });
                    _initializeScreen(); // Mulai lagi dari pemilihan tipe
                  } else {
                    Navigator.of(
                      context,
                    ).pop(); // Kembali ke layar sebelumnya (ChooseLevelScreen)
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStepCard(ToiletStep step) {
    return Center(
      child: SizedBox(
        width: 100,
        height: 140,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(step.image, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildFeedbackCard(ToiletStep step) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: 100,
        height: 140,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(step.image, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildOptionCard(ToiletStep step) {
    return Draggable<ToiletStep>(
      data: step,
      feedback: _buildFeedbackCard(step),
      childWhenDragging: SizedBox(width: 100, height: 140),
      child: SizedBox(
        width: 100,
        height: 140,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(step.image, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
