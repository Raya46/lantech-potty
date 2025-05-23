import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:toilet_training/screens/levels/level4/level4_play_screen.dart';
import 'package:toilet_training/screens/menus/level_start_screen.dart';

class LevelFourStartScreen extends StatefulWidget {
  const LevelFourStartScreen({super.key});

  @override
  State<LevelFourStartScreen> createState() => _LevelFourStartScreenState();
}

class _LevelFourStartScreenState extends State<LevelFourStartScreen> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playAudio();
  }

  Future<void> _playAudio() async {
    try {
      await _audioPlayer.setAsset('assets/sounds/level_4_pembuka.mp3');
      _audioPlayer.play();
    } catch (e) {}
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LevelStartScreen(
      levelText: 'Level 4',
      levelDescription: 'Kamu Sudah Ahli, Sekarang Tunjukkan Urutan Yang Benar',
      levelScreen: LevelFourPlayScreen(),
    );
  }
}
