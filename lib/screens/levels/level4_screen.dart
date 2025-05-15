import 'package:flutter/material.dart';

class LevelFourScreen extends StatefulWidget {
  const LevelFourScreen({super.key});

  @override
  State<LevelFourScreen> createState() => _LevelFourScreenState();
}

class _LevelFourScreenState extends State<LevelFourScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: []),
      ),
    );
  }
}
