import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:toilet_training/games/hidden_object_game/hidden_object_game.dart';
import 'package:toilet_training/models/player.dart';
import 'package:toilet_training/models/scene_object.dart';
import 'package:toilet_training/screens/levels/level3/level3_start_screen.dart';
import 'package:toilet_training/services/player_service.dart';
import 'package:toilet_training/widgets/background.dart';
import 'package:toilet_training/widgets/header.dart';
import 'package:toilet_training/screens/levels/level4/level4_start_screen.dart';
import 'package:just_audio/just_audio.dart';

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
          _playSoundForResult(stars);
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

    _game.resetGame().then((_) {});
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
          size: 30,
        );
      }),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFFFF0E1),
          title: Center(
            child: Text(
              "Yeayy!!! Kamu berhasil!",
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
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF0AD4E),
              ),
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
            SizedBox(width: 10),
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
                Get.off(() => const LevelFourStartScreen());
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
      body: Container(
        color: Color(0xFFF7E4D5), // New color
        child: Column(
          children: [
            Header(
              onTapBack: () {
                Get.off(() => LevelThreeStartScreen());
              },
              title: "Level 3",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                _currentFoundIds.length == _currentTargets.length &&
                        _currentTargets.isNotEmpty
                    ? "Semua Benda Ditemukan!"
                    : "Temukanlah benda berikut ini:",
                style: TextStyle(
                  fontSize: 10.sp,
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
                spacing: 8.0,
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
                            fontSize: 10.sp,
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
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
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
            // SizedBox(height: 15),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFEEDD6C3), // EDD6C3 in hex
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: GameWidget(game: _game),
                  ),
                ),
              ),
            ),

            // SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
