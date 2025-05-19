import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toilet_training/games/puzzle/puzzle_game.dart';
import 'package:toilet_training/widgets/background.dart';
import 'package:toilet_training/widgets/header.dart';
import 'package:toilet_training/screens/levels/level5/level5_start_screen.dart';
import 'package:get/get.dart';

class LevelFivePlayScreen extends StatefulWidget {
  const LevelFivePlayScreen({super.key});

  @override
  State<LevelFivePlayScreen> createState() => _LevelFivePlayScreenState();
}

class _LevelFivePlayScreenState extends State<LevelFivePlayScreen> {
  PuzzleGame? _puzzleGame;
  String? _initializationError;

  @override
  void initState() {
    super.initState();
    try {
      _puzzleGame = PuzzleGame(onPuzzleSolved: _showPuzzleSolvedDialog);
    } catch (e) {
      setState(() {
        _initializationError = e.toString();
      });
    }
  }

  void _showPuzzleSolvedDialog() {
    if (!mounted) return;

    const int starsEarned = 3;
    Widget starDisplay = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
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
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selamat!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Anda berhasil menyelesaikan puzzle!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              starDisplay,
              const SizedBox(height: 5),
              Text(
                "Kamu mendapatkan $starsEarned bintang!",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Main Lagi'),
              onPressed: () {
                Navigator.of(context).pop(); 
              },
            ),
            TextButton(
              child: const Text('Kembali'),
              onPressed: () {
                Navigator.of(context).pop(); 
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
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
      // Ini seharusnya tidak terjadi jika tidak ada error,
      // tapi sebagai fallback jika initState belum selesai atau ada kondisi aneh
      return Scaffold(body: const Center(child: CircularProgressIndicator()));
    }

    // Jika _puzzleGame berhasil diinisialisasi
    return Scaffold(
      body: Background(
        gender: 'perempuan',
        child: Column(
          children: [
            Header(
              onTapBack: (){
                Get.off(() => const LevelFiveStartScreen());
              },
              title: 'Level 5'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GameWidget(game: _puzzleGame!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
