import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toilet_training/screens/menus/choose_level_screen.dart';
import "package:toilet_training/widgets/card_gender.dart";
import 'package:toilet_training/widgets/background.dart';
import "package:toilet_training/widgets/header.dart";
import 'package:toilet_training/services/player_service.dart';
import 'package:toilet_training/models/player.dart';
import 'package:toilet_training/screens/menus/start_screen.dart';

class ChooseGenderScreen extends StatefulWidget {
  const ChooseGenderScreen({super.key});

  @override
  State<ChooseGenderScreen> createState() => _ChooseGenderScreenState();
}

class _ChooseGenderScreenState extends State<ChooseGenderScreen> {
  Player? _player;

  @override
  void initState() {
    super.initState();
    _loadPlayerData();
  }

  Future<void> _loadPlayerData() async {
    try {
      Player player = await getPlayer();
      setState(() {
        _player = player;
      });
    } catch (e) {
      Player newPlayer = Player(null);
      newPlayer.isFocused = false;
      await savePlayer(newPlayer);
      setState(() {
        _player = newPlayer;
      });
    }
  }

  Future<void> _updateAndNavigate(String gender) async {
    if (_player != null) {
      _player!.gender = gender;
      await updatePlayer(_player!);
      Get.to(
        () => ChooseLevelScreen(),
        transition: Transition.leftToRight,
        duration: Duration(milliseconds: 1500),
      );
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        gender: _player?.gender ?? 'male',
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Header(
                onTapBack: () {
                  Get.off(() => const StartScreen());
                },
                title: "Pilih Gender",
              ),
            ),
            if (_player == null)
              Center(child: CircularProgressIndicator())
            else
              Expanded(
                flex: 5,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GenderCard(
                        text: "Perempuan",
                        gender: 'perempuan',
                        onTap: () {
                          _updateAndNavigate("perempuan");
                        },
                      ),
                      SizedBox(width: 40),
                      GenderCard(
                        text: "Laki-laki",
                        gender: 'laki-laki',
                        onTap: () {
                          _updateAndNavigate("laki-laki");
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
