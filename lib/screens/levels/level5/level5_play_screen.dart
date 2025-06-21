import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:toilet_training/games/puzzle/puzzle_game.dart';
import 'package:toilet_training/models/player.dart';
import 'package:toilet_training/services/player_service.dart';
import 'package:toilet_training/widgets/background.dart';
import 'package:toilet_training/widgets/header.dart';
import 'package:toilet_training/screens/levels/level5/level5_start_screen.dart';
import 'package:get/get.dart';
import 'package:confetti/confetti.dart';
import 'package:toilet_training/widgets/modal_result.dart';

class LevelFivePlayScreen extends StatefulWidget {
  const LevelFivePlayScreen({super.key});

  @override
  State<LevelFivePlayScreen> createState() => _LevelFivePlayScreenState();
}

class _LevelFivePlayScreenState extends State<LevelFivePlayScreen> {
  PuzzleGame? _puzzleGame;
  String? _initializationError;
  late ConfettiController _confettiController;
  Player? _player;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _loadPlayerAndInitializeGame();
  }

  Future<void> _loadPlayerAndInitializeGame() async {
    try {
      _player = await getPlayer();
      _puzzleGame = PuzzleGame(onPuzzleSolved: _onPuzzleSolved);
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        setState(() {
          _initializationError = e.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
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

  Future<void> _onPuzzleSolved() async {
    if (!mounted || _player == null) return;

    const int starsEarned = 3;
    _player!.level5Score = starsEarned;
    await updatePlayer(_player!);

    if (_player!.level1Score != null &&
        _player!.level2Score != null &&
        _player!.level3Score != null &&
        _player!.level4Score != null &&
        _player!.accumulatedScore == null) {
      final scores = [
        _player!.level1Score!,
        _player!.level2Score!,
        _player!.level3Score!,
        _player!.level4Score!,
        _player!.level5Score!,
      ];
      final double avgScore = scores.reduce((a, b) => a + b) / scores.length;
      _player!.accumulatedScore = avgScore;
      await updatePlayer(_player!);

      _showAccumulatedScoreDialog(avgScore);
    } else {
      _showPuzzleSolvedDialog(starsEarned);
    }
  }

  void _showAccumulatedScoreDialog(double accumulatedScore) {
    if (!mounted) return;
    _confettiController.play();
    ModalResult.show(
      context: context,
      title: "Semua Level Selesai!",
      message:
          "Selamat! Kamu telah menyelesaikan semua level.\nSkor rata-ratamu adalah: ${accumulatedScore.toStringAsFixed(2)}",
      starsEarned: 3,
      isSuccess: true,
      confettiController: _confettiController,
      primaryActionText: "Kembali ke Awal",
      onPrimaryAction: () {
        Get.off(() => const LevelFiveStartScreen());
      },
    );
  }

  void _showPuzzleSolvedDialog(int starsEarned) {
    if (!mounted) return;

    _playSoundForResult(starsEarned);

    ModalResult.show(
      context: context,
      title: "Selamat!",
      message: "Anda berhasil menyelesaikan puzzle!",
      starsEarned: starsEarned,
      isSuccess: true,
      confettiController: _confettiController,
      primaryActionText: "Main Lagi",
      onPrimaryAction: () {
        if (_puzzleGame != null) {
          setState(() {
            _initializationError = null;
            _puzzleGame = PuzzleGame(onPuzzleSolved: _onPuzzleSolved);
          });
        }
      },
      secondaryActionText: "Kembali",
      onSecondaryAction: () {
        Get.off(() => const LevelFiveStartScreen());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_initializationError != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Gagal memuat game: $_initializationError"),
          ),
        ),
      );
    }

    if (_puzzleGame == null || _player == null) {
      return Scaffold(body: const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          Background(
            gender: _player?.gender ?? 'perempuan',
            child: Column(
              children: [
                Header(
                  onTapBack: () {
                    Get.off(() => const LevelFiveStartScreen());
                  },
                  title: 'Level 5',
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child:
                        _puzzleGame != null
                            ? GameWidget(game: _puzzleGame!)
                            : Center(child: Text("Memuat puzzle...")),
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
