import 'package:flutter/material.dart';
import 'package:toilet_training/screens/levels/level2/level2_play_screen.dart';
import 'package:toilet_training/screens/menus/level_start_screen.dart';

class LevelTwoStartScreen extends StatefulWidget {
  const LevelTwoStartScreen({super.key});

  @override
  State<LevelTwoStartScreen> createState() => _LevelTwoStartScreenState();
}

class _LevelTwoStartScreenState extends State<LevelTwoStartScreen> {
  @override
  Widget build(BuildContext context) {
    return LevelStartScreen(
      levelText: 'Level 2',
      levelDescription: 'Tentukan Benda yang Tepat',
      levelScreen: LevelTwoPlayScreen(),
    );
  }
}
