import 'package:flutter/material.dart';
import 'package:toilet_training/screens/levels/level1_screen.dart';
import 'package:get/get.dart';
import 'package:toilet_training/screens/levels/level2_screen.dart';
import 'package:toilet_training/screens/levels/level3_screen.dart';
import 'package:toilet_training/widgets/background.dart';
import "package:toilet_training/widgets/card_gender.dart";
import "package:toilet_training/widgets/header.dart";

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
      body: Background(
        gender: 'female',
        child: Column(
          children: [
            Header(
              title: "Pilih level",
              onTapBack: () {
                Get.back();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GenderCard(
                  text: "Level 1",
                  gender: Gender.female,
                  onTap: () {
                    Get.to(
                      () => LevelOneScreen(),
                      transition: Transition.circularReveal,
                      duration: Duration(milliseconds: 1500),
                    );
                  },
                ),
                GenderCard(
                  text: "Level 2",
                  gender: Gender.female,
                  onTap: () {
                    Get.to(
                      () => LevelTwoScreen(),
                      transition: Transition.circularReveal,
                      duration: Duration(milliseconds: 1500),
                    );
                  },
                ),
                GenderCard(
                  gender: Gender.female,
                  text: "Level 3",
                  onTap: () {
                    Get.to(
                      () => LevelThreeScreen(),
                      transition: Transition.circularReveal,
                      duration: Duration(milliseconds: 1500),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
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
