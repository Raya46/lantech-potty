import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:toilet_training/games/puzzle/puzzle_game.dart';
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

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    try {
      _puzzleGame = PuzzleGame(onPuzzleSolved: _showPuzzleSolvedDialog);
    } catch (e) {
      setState(() {
        _initializationError = e.toString();
      });
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

  void _showPuzzleSolvedDialog() {
    if (!mounted) return;

    const int starsEarned = 3;
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
            _puzzleGame = PuzzleGame(onPuzzleSolved: _showPuzzleSolvedDialog);
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

    if (_puzzleGame == null) {
      return Scaffold(body: const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          Background(
            gender: 'perempuan',
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
