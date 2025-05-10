import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toilet_training/screens/menus/choose_level_screen.dart';
import "package:toilet_training/widgets/card_gender.dart";
import 'package:toilet_training/widgets/background.dart';
import "package:toilet_training/widgets/header.dart";

class ChooseGenderScreen extends StatefulWidget {
  const ChooseGenderScreen({super.key});

  @override
  State<ChooseGenderScreen> createState() => _ChooseGenderScreenState();
}

class _ChooseGenderScreenState extends State<ChooseGenderScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
      upperBound: 1.3,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: Scaffold(
        body: Background(
          gender: 'male',
          child: Column(
            children: [
              Header(
                title: "Pilih Gender",
                onTapBack: () {
                  Get.back();
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GenderCard(
                    text: "Perempuan",
                    gender: Gender.female,
                    onTap: () {
                      Get.to(
                        () => ChooseLevelScreen(),
                        transition: Transition.leftToRight,
                        duration: Duration(milliseconds: 1500),
                      );
                    },
                  ),
                  SizedBox(width: 40),
                  GenderCard(
                    text: "Laki-laki",
                    gender: Gender.male,
                    onTap: () {
                      Get.to(
                        () => ChooseLevelScreen(),
                        transition: Transition.leftToRight,
                        duration: Duration(milliseconds: 1500),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      builder: (context, child) {
        return ClipPath(clipper: MyClipper(_controller.value), child: child);
      },
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
