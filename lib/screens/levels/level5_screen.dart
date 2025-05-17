import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toilet_training/games/puzzle/puzzle_game.dart';
import 'package:toilet_training/widgets/background.dart';
import 'package:toilet_training/widgets/header.dart';

class LevelFiveScreen extends StatefulWidget {
  const LevelFiveScreen({super.key});

  @override
  State<LevelFiveScreen> createState() => _LevelFiveScreenState();
}

class _LevelFiveScreenState extends State<LevelFiveScreen> {
  PuzzleGame? _puzzleGame;
  String? _initializationError;

  @override
  void initState() {
    super.initState();
    try {
      print("Attempting to initialize PuzzleGame...");
      _puzzleGame = PuzzleGame(onPuzzleSolved: _showPuzzleSolvedDialog);
      print("PuzzleGame instance created.");
    } catch (e, s) {
      print("Error during PuzzleGame instance creation: $e");
      print(s);
      setState(() {
        _initializationError = e.toString();
      });
    }
  }

  void _showPuzzleSolvedDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selamat!'),
          content: const Text('Anda berhasil menyelesaikan puzzle!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Main Lagi'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                // Game akan direset otomatis oleh logic di dalam PuzzleGame
                // Jika tidak, panggil _puzzleGame?.resetGame(); jika perlu
              },
            ),
            TextButton(
              child: const Text('Kembali'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop(); // Kembali ke layar sebelumnya
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
            Header(title: 'Level 5'),
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GameWidget(game: _puzzleGame!),
            )),
          ],
        ),
      ),
    );
  }
}
