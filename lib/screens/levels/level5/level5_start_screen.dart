import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:toilet_training/screens/levels/level5/level5_play_screen.dart';
import 'package:toilet_training/screens/menus/level_start_screen.dart';

class LevelFiveStartScreen extends StatefulWidget {
  const LevelFiveStartScreen({super.key});

  @override
  State<LevelFiveStartScreen> createState() => _LevelFiveStartScreenState();
}

class _LevelFiveStartScreenState extends State<LevelFiveStartScreen> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playAudio();
  }

  Future<void> _playAudio() async {
    try {
      await _audioPlayer.setAsset('assets/sounds/level_5_pembuka.mp3');
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
      levelText: 'Level 5',
      levelDescription: 'Tantangan Terakhir Nih! Susun Puzzle',
      levelScreen: LevelFivePlayScreen(),
    );
  }
}
