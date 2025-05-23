import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:toilet_training/screens/levels/level3/level3_play_screen.dart';
import 'package:toilet_training/screens/menus/level_start_screen.dart';

class LevelThreeStartScreen extends StatefulWidget {
  const LevelThreeStartScreen({super.key});

  @override
  State<LevelThreeStartScreen> createState() => _LevelThreeStartScreenState();
}

class _LevelThreeStartScreenState extends State<LevelThreeStartScreen> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playAudio();
  }

  Future<void> _playAudio() async {
    try {
      await _audioPlayer.setAsset('assets/sounds/level_3_pembuka.mp3');
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
      levelText: 'Level 3',
      levelDescription: 'Ayo Jadi Detektif Cilik',
      levelScreen: LevelThreePlayScreen(),
    );
  }
}
