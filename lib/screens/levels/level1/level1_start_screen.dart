import 'package:flutter/material.dart';
import 'package:toilet_training/screens/levels/level1/level1_focus_screen.dart';
import 'package:toilet_training/screens/menus/level_start_screen.dart';

class LevelOneStartScreen extends StatefulWidget {
  const LevelOneStartScreen({super.key});

  @override
  State<LevelOneStartScreen> createState() => _LevelOneStartScreenState();
}

class _LevelOneStartScreenState extends State<LevelOneStartScreen> {
  @override
  Widget build(BuildContext context) {
    return LevelStartScreen(
      levelText: 'Level 1',
      levelDescription: 'Tentukan Benda yang Tepat',
      levelScreen: LevelOneFocusScreen(),
    );
  }
}
