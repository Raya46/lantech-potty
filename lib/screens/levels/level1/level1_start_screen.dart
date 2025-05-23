import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:toilet_training/screens/levels/level1/level1_focus_screen.dart';
import 'package:toilet_training/screens/menus/level_start_screen.dart';

class LevelOneStartScreen extends StatefulWidget {
  const LevelOneStartScreen({super.key});

  @override
  State<LevelOneStartScreen> createState() => _LevelOneStartScreenState();
}

class _LevelOneStartScreenState extends State<LevelOneStartScreen> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playAudio();
  }

  Future<void> _playAudio() async {
    try {
      await _audioPlayer.setAsset('assets/sounds/level_1_pembuka.mp3');
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
      levelText: 'Level 1',
      levelDescription: 'Yuk Pahami Urutan Toilet Training',
      levelScreen: LevelOneFocusScreen(),
    );
  }
}
