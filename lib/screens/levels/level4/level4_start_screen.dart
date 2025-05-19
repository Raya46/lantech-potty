import 'package:flutter/material.dart';
import 'package:toilet_training/screens/levels/level4/level4_play_screen.dart';
import 'package:toilet_training/screens/menus/level_start_screen.dart';

class LevelFourStartScreen extends StatefulWidget {
  const LevelFourStartScreen({super.key});

  @override
  State<LevelFourStartScreen> createState() => _LevelFourStartScreenState();
}

class _LevelFourStartScreenState extends State<LevelFourStartScreen> {
  
  @override
  Widget build(BuildContext context) {
     return LevelStartScreen(
      levelText: 'Level 4',
      levelDescription: 'Tentukan Benda yang Tepat',
      levelScreen: LevelFourPlayScreen(),
    );
  }
}
