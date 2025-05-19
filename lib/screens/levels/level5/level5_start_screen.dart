import 'package:flutter/material.dart';
import 'package:toilet_training/screens/levels/level5/level5_play_screen.dart';
import 'package:toilet_training/screens/menus/level_start_screen.dart';

class LevelFiveStartScreen extends StatefulWidget {
  const LevelFiveStartScreen({super.key});

  @override
  State<LevelFiveStartScreen> createState() => _LevelFiveStartScreenState();
}

class _LevelFiveStartScreenState extends State<LevelFiveStartScreen> {
  @override
  Widget build(BuildContext context) {
    return LevelStartScreen(
      levelText: 'Level 5',
      levelDescription: 'Tentukan Benda yang Tepat',
      levelScreen: LevelFivePlayScreen(),
    );
  }
}
