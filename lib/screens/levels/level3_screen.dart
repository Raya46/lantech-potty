import 'package:flutter/material.dart';

class LevelThreeScreen extends StatefulWidget {
  const LevelThreeScreen({super.key});

  @override
  State<LevelThreeScreen> createState() => _LevelThreeScreenState();
}

class _LevelThreeScreenState extends State<LevelThreeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Image.network(
            "https://images.unsplash.com/photo-1484517586036-ed3db9e3749e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
            width: 200.0,
            height: 200.0,
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              Text("Level 1"),
              Text("Pengenalan Toilet"),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {},
                child: const Text("Play"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
