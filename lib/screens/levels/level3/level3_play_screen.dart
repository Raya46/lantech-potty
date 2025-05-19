import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toilet_training/games/hidden_object_game/hidden_object_game.dart';
import 'package:toilet_training/models/player.dart';
import 'package:toilet_training/models/scene_object.dart';
import 'package:toilet_training/services/player_service.dart';
import 'package:toilet_training/widgets/background.dart';
import 'package:toilet_training/widgets/header.dart';
import 'package:toilet_training/screens/levels/level4/level4_start_screen.dart';
import 'package:toilet_training/screens/levels/level3/level3_start_screen.dart';

class SceneObject {
  final dynamic id;
  final String name;
  final String imagePath;
  Offset position;
  Size size;
  bool isTarget;
  bool isFound;

  SceneObject({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.position,
    required this.size,
    this.isTarget = false,
    this.isFound = false,
  });

  factory SceneObject.fromJson(
    Map<String, dynamic> json,
    Offset defaultPosition,
    Size defaultSize,
  ) {
    return SceneObject(
      id: json['id'].toString(),
      name: json['name'],
      imagePath: json['image'],
      position: defaultPosition,
      size: defaultSize,
    );
  }
}

class LevelThreePlayScreen extends StatefulWidget {
  const LevelThreePlayScreen({super.key});

  @override
  State<LevelThreePlayScreen> createState() => _LevelThreePlayScreenState();
}

class _LevelThreePlayScreenState extends State<LevelThreePlayScreen> {
  late HiddenObjectGame _game;
  List<SceneObjectData> _currentTargets = [];
  Set<String> _currentFoundIds = {};
  bool _isLoadingGame = true;
  Player? _player;
  bool _isLoadingPlayer = true;

  @override
  void initState() {
    super.initState();
    _loadPlayerDataAndInitializeGame();
  }

  Future<void> _loadPlayerDataAndInitializeGame() async {
    setState(() {
      _isLoadingPlayer = true;
      _isLoadingGame = true;
    });
    try {
      _player = await getPlayer();
      _player?.level3Score ??= 0;
    } catch (e) {
      _player = Player(null)..level3Score = 0;
      await savePlayer(_player!);
    }
    _initializeGame();
    if (mounted) {
      setState(() {
        _isLoadingPlayer = false;
      });
    }
  }

  void _initializeGame() {
    _game = HiddenObjectGame(
      onTargetsUpdated: (targets, foundIds) {
        if (mounted) {
          setState(() {
            _currentTargets = List.from(targets);
            _currentFoundIds = Set.from(foundIds);
            if (_isLoadingGame) _isLoadingGame = false;
          });
        }
      },
      onAllTargetsFound: (int wrongTaps) {
        if (mounted) {
          int stars = _calculateStars(wrongTaps);
          _saveScore(stars);
          _showSuccessDialog(starsEarned: stars, wrongAttempts: wrongTaps);
        }
      },
      onShowFeedback: (message) {
        if (mounted && message.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: Duration(seconds: 1),
              backgroundColor: Colors.orange,
            ),
          );
        }
      },
    );
  }

  int _calculateStars(int wrongAttempts) {
    if (wrongAttempts == 0) return 3;
    if (wrongAttempts <= 3) return 2;
    return 1;
  }

  Future<void> _saveScore(int stars) async {
    if (_player == null) return;
    try {
      _player!.level3Score = stars;
      await updatePlayer(_player!);
    } catch (e) {}
  }

  void _resetLevel() {
    setState(() {
      _isLoadingGame = true;
      _currentTargets.clear();
      _currentFoundIds.clear();
    });
  }

  void _showSuccessDialog({
    required int starsEarned,
    required int wrongAttempts,
  }) {
    Widget starDisplay = Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Icon(
          index < starsEarned ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 30, // Ukuran bintang bisa disesuaikan
        );
      }),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        // Ganti nama context agar tidak bentrok
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFFFF0E1),
          title: Center(
            child: Text(
              "Yeayy!!! Kamu berhasil!", // Judul lebih umum
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFD98555),
                fontSize: 20,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Kamu menemukan semua benda dengan $wrongAttempts kesalahan.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Color(0xFF8B5A2B)),
              ),
              SizedBox(height: 15),
              starDisplay,
              SizedBox(height: 5),
              Text(
                "Kamu mendapatkan $starsEarned bintang!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF8B5A2B),
                ),
              ),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                alignment: WrapAlignment.center,
                children:
                    _currentTargets
                        .map(
                          (obj) => Chip(
                            label: Text(
                              obj.name,
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: _getChipColor(obj.name, true),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center, // Pusatkan tombol aksi
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF0AD4E),
              ), // Warna oranye untuk coba lagi
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 10.0,
                ),
                child: Text(
                  "Main Lagi",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _resetLevel();
              },
            ),
            SizedBox(width: 10), // Jarak antar tombol
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5C9A4A),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 10.0,
                ),
                child: Text(
                  "Lanjut Level 4",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Get.off(
                  () => const LevelFourStartScreen(),
                ); // Navigasi ke Level 4
              },
            ),
          ],
        );
      },
    );
  }

  Color _getChipColor(String name, bool found) {
    final colors = [
      Colors.amber[600]!,
      Colors.green[600]!,
      Colors.blue[600]!,
      Colors.redAccent[400]!,
      Colors.purple[600]!,
    ];
    final hash = name.hashCode % colors.length;
    Color baseColor = colors[hash];
    return found ? baseColor : baseColor.withOpacity(0.7);
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

    return Scaffold(
      body: Background(
        gender: _player!.gender!,
        child: Column(
          children: [
            Header(
              onTapBack: () {
                Get.off(() => const LevelThreeStartScreen());
              },
              title: "Level 3: Cari Benda",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                _currentFoundIds.length == _currentTargets.length &&
                        _currentTargets.isNotEmpty
                    ? "Semua Benda Ditemukan!"
                    : "Temukanlah benda berikut ini:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B5A2B),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (_isLoadingGame && _currentTargets.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              )
            else if (_currentTargets.isNotEmpty)
              Wrap(
                spacing: 8.0, // Mengurangi spacing sedikit
                runSpacing: 6.0,
                alignment: WrapAlignment.center,
                children:
                    _currentTargets.map((obj) {
                      bool isActuallyFound = _currentFoundIds.contains(
                        obj.id.toString(),
                      );
                      return Chip(
                        label: Text(
                          obj.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: _getChipColor(
                          obj.name,
                          isActuallyFound,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ), // Adjust padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            16,
                          ), // Adjust border radius
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.8),
                            width: 1,
                          ),
                        ),
                      );
                    }).toList(),
              )
            else if (!_isLoadingGame && _currentTargets.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Tidak ada target untuk ditemukan.",
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ),
            SizedBox(height: 15), // Memberi jarak sebelum GameWidget
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ), // Padding untuk GameWidget
                child: ClipRRect(
                  // Memberi border radius pada area game
                  borderRadius: BorderRadius.circular(12.0),
                  child: GameWidget(game: _game),
                ),
              ),
            ),
            SizedBox(height: 10), // Sedikit ruang di bawah game
          ],
        ),
      ),
    );
  }
}
