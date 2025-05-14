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

class _ChooseGenderScreenState extends State<ChooseGenderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        gender: 'male',
        child: Column(
          children: [
            Header(title: "Pilih Gender"),
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
    );
  }
}
