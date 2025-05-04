import 'package:flutter/material.dart';
import 'package:toilet_training/screens/levels/level1_screen.dart';
import 'package:get/get.dart';

class ChooseLevelScreen extends StatefulWidget {
  const ChooseLevelScreen({super.key});

  @override
  State<ChooseLevelScreen> createState() => _ChooseLevelScreenState();
}

class _ChooseLevelScreenState extends State<ChooseLevelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: Column(
        children: [
          Text("Pilih Level"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Get.to(
                    () => LevelOneScreen(),
                    transition: Transition.circularReveal,
                    duration: Duration(milliseconds: 1500),
                  );
                },
                child: Column(
                  children: [
                    Image.network(
                      "https://images.unsplash.com/photo-1484517586036-ed3db9e3749e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                    Text("Level 1"),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(
                    () => LevelOneScreen(),
                    transition: Transition.circularReveal,
                    duration: Duration(milliseconds: 1500),
                  );
                },
                child: Column(
                  children: [
                    Image.network(
                      "https://images.unsplash.com/photo-1484517586036-ed3db9e3749e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                    Text("Level 2"),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(
                    () => LevelOneScreen(),
                    transition: Transition.circularReveal,
                    duration: Duration(milliseconds: 1500),
                  );
                },
                child: Column(
                  children: [
                    Image.network(
                      "https://images.unsplash.com/photo-1484517586036-ed3db9e3749e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                    Text("Level 3"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  MyClipper(this.value);
  final double value;

  @override
  Path getClip(Size size) {
    var path = Path();
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.height, size.height),
        radius: value * size.width,
      ),
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
