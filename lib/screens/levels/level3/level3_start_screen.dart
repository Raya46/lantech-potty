import 'package:flutter/material.dart';
import 'package:toilet_training/screens/levels/level3/level3_play_screen.dart';
import 'package:toilet_training/screens/menus/level_start_screen.dart';

class LevelThreeStartScreen extends StatefulWidget {
  const LevelThreeStartScreen({super.key});

  @override
  State<LevelThreeStartScreen> createState() => _LevelThreeStartScreenState();
}

class _LevelThreeStartScreenState extends State<LevelThreeStartScreen> {
  @override
  Widget build(BuildContext context) {
    return LevelStartScreen(
      levelText: 'Level 3',
      levelDescription: 'Tentukan Benda yang Tepat',
      levelScreen: LevelThreePlayScreen(),
    );
  }
}
