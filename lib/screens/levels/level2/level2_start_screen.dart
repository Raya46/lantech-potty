import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:toilet_training/screens/levels/level2/level2_play_screen.dart';
import 'package:toilet_training/screens/menus/level_start_screen.dart';

class LevelTwoStartScreen extends StatefulWidget {
  const LevelTwoStartScreen({super.key});

  @override
  State<LevelTwoStartScreen> createState() => _LevelTwoStartScreenState();
}

class _LevelTwoStartScreenState extends State<LevelTwoStartScreen> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playAudio();
  }

  Future<void> _playAudio() async {
    try {
      await _audioPlayer.setAsset('assets/sounds/level_2_pembuka.mp3');
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
      levelText: 'Level 2',
      levelDescription: 'Pilih Benda Yang Tepat',
      levelScreen: LevelTwoPlayScreen(),
    );
  }
}
