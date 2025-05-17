import 'package:flutter/material.dart';
import 'package:toilet_training/models/step.dart';
import 'package:toilet_training/widgets/header.dart';
import 'package:toilet_training/widgets/background.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:toilet_training/models/player.dart';
import 'package:toilet_training/services/player_service.dart';
import 'package:toilet_training/widgets/modal_setting.dart';

class LevelFourScreen extends StatefulWidget {
  const LevelFourScreen({super.key});

  @override
  State<LevelFourScreen> createState() => _LevelFourScreenState();
}

class _LevelFourScreenState extends State<LevelFourScreen> {
  List<ToiletStep> _steps = [];
  int currentStepIndex = 0;
  ToiletStep? _droppedStepOnTarget;

  Player? _player;
  bool _isLoadingPlayer = true;
  String? _selectedTypeForMale; // 'bab' atau 'bak'
  bool _hasSelectedTypeForMale = false;
  bool _isChoosingMaleType = false; // Untuk menampilkan UI pemilihan tipe

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    await _loadPlayerData();
    if (_player?.gender == 'laki-laki' && !_hasSelectedTypeForMale) {
      setState(() {
        _isChoosingMaleType = true; // Tampilkan UI pemilihan tipe
      });
      // loadSteps akan dipanggil setelah tipe dipilih
    } else {
      await loadSteps();
    }
  }

  Future<void> _loadPlayerData() async {
    setState(() {
      _isLoadingPlayer = true;
    });
    try {
      _player = await getPlayer();
      // Jika gender null (misalnya dari player lama sebelum ada field gender),
      // set default atau arahkan kembali ke pemilihan gender.
      // Untuk sekarang, asumsikan gender sudah ada jika player ada.
      if (_player?.gender == null) {
        // Sebaiknya ada penanganan lebih baik, misal kembali ke choose gender screen
        print("Player gender is null, defaulting to laki-laki for now.");
        _player!.gender = 'laki-laki';
      }
      if (_player?.isFocused == null) {
        _player!.isFocused = false;
      }
    } catch (e) {
      print("Error loading player for Level 4: $e. Creating new player.");
      _player = Player(null);
      _player!.gender = 'laki-laki'; // Default
      _player!.isFocused = false;
      await savePlayer(_player!);
    }
    setState(() {
      _isLoadingPlayer = false;
    });
  }

  Future<void> loadSteps() async {
    if (_player == null) {
      print("Player data not loaded yet. Cannot load steps.");
      return;
    }
    if (_player!.gender == 'laki-laki' && _selectedTypeForMale == null) {
      print(
        "Male gender selected, but type (BAB/BAK) not chosen. Cannot load steps.",
      );
      return;
    }

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

      // Urutkan berdasarkan ID untuk memastikan urutan yang benar
      filteredSteps.sort((a, b) => a.id.compareTo(b.id));

      setState(() {
        _steps = filteredSteps;
        currentStepIndex = 0;
        _droppedStepOnTarget = null;
        _isLoadingPlayer =
            false; // Pastikan loading selesai setelah steps dimuat
        _isChoosingMaleType = false; // Sembunyikan UI pemilihan tipe
        if (_player?.gender == 'laki-laki') {
          _hasSelectedTypeForMale = _selectedTypeForMale != null;
        } else {
          _hasSelectedTypeForMale =
              true; // Untuk perempuan, anggap tipe sudah "terpilih"
        }
      });

      if (_steps.isEmpty) {
        print(
          "No steps found for gender: ${_player!.gender}, focus: ${_player!.isFocused}, type: ${_selectedTypeForMale}",
        );
        // Tampilkan pesan ke pengguna bahwa tidak ada langkah yang sesuai
      }
    }
  }

  void _onMaleTypeSelected(String type) {
    setState(() {
      _selectedTypeForMale = type;
      _isChoosingMaleType = false;
      _hasSelectedTypeForMale = true;
      _isLoadingPlayer = true; // Set loading true sementara loadSteps berjalan
    });
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

  @override
  Widget build(BuildContext context) {
    if (_isLoadingPlayer) {
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

    if (_steps.isEmpty && _hasSelectedTypeForMale) {
      // Jika sudah memilih tipe (atau bukan gender laki-laki) dan steps masih kosong
      return Scaffold(
        body: Background(
          gender: _player?.gender ?? 'laki-laki',
          child: Column(
            children: [
              Header(
                title: "Level 4",
                onTapSettings: () => _showSettingsModal(context),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Tidak ada langkah yang sesuai dengan:",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF8B5A2B),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Gender: ${_player?.gender}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF8B5A2B),
                        ),
                      ),
                      Text(
                        "Mode Fokus: ${_player?.isFocused == true ? 'Aktif' : 'Nonaktif'}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF8B5A2B),
                        ),
                      ),
                      if (_player?.gender == 'laki-laki')
                        Text(
                          "Tipe: ${_selectedTypeForMale?.toUpperCase() ?? 'Belum Dipilih'}",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF8B5A2B),
                          ),
                        ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Reset dan coba lagi atau kembali
                          setState(() {
                            _isLoadingPlayer = true;
                            _hasSelectedTypeForMale = false;
                            _selectedTypeForMale = null; // Reset pilihan tipe
                          });
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

    if (_steps.isEmpty &&
        !_hasSelectedTypeForMale &&
        _player?.gender != 'laki-laki') {
      // Kondisi khusus jika _steps kosong, bukan karena filter tidak menemukan,
      // tapi karena loadSteps belum terpanggil dengan benar (misal untuk perempuan pertama kali load)
      return Scaffold(
        body: Background(
          gender: _player?.gender ?? 'perempuan',
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
      options.shuffle();
    }

    return Scaffold(
      body: Background(
        gender: _player!.gender!,
        child: Column(
          children: [
            Header(
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
                              setState(() {
                                _droppedStepOnTarget = droppedStep;
                              });
                              Future.delayed(Duration(seconds: 1), () {
                                if (mounted) {
                                  if (currentStepIndex + 1 < _steps.length) {
                                    setState(() {
                                      currentStepIndex++;
                                      _droppedStepOnTarget = null;
                                    });
                                  } else {
                                    _showCompletionDialog("Level 4 Selesai!");
                                  }
                                }
                              });
                            } else {
                              // Feedback salah
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
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SettingsModalContent(
            onClose: () {
              Navigator.of(context).pop();
              // Reload data player dan steps jika ada perubahan di modal
              setState(() {
                _isLoadingPlayer = true;
              });
              _initializeScreen();
            },
            // onTapSound dan onTapMusic bisa ditambahkan jika ada state management untuknya
          ),
        );
      },
    );
  }

  void _showCompletionDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // User harus menekan tombol
      builder:
          (ctx) => AlertDialog(
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
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Color(0xFFD98555)),
                ),
                SizedBox(height: 20),
                Text(
                  "Kamu hebat! Semua langkah sudah benar.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xFF8B5A2B)),
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
          ),
    );
  }

  Widget _buildStepCard(ToiletStep step) {
    return Center(
      child: SizedBox(
        width: 100,
        height: 140,
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(step.image, fit: BoxFit.contain),
          ),
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
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(step.image, fit: BoxFit.contain),
          ),
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
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(step.image, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
