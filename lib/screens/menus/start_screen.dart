import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:toilet_training/models/player.dart';
import 'package:toilet_training/screens/menus/choose_gender_screen.dart';
import 'package:toilet_training/services/player_service.dart';
import 'package:toilet_training/widgets/background.dart';
import 'package:get/get.dart';
import 'package:toilet_training/widgets/play_button.dart';
import 'package:toilet_training/widgets/float_animated_widget.dart';
import 'package:toilet_training/responsive.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Player? _player;
  bool _isLoadingPlayer = true;

  @override
  void initState() {
    super.initState();
    _loadPlayerData();
  }

  Future<void> _loadPlayerData() async {
    setState(() => _isLoadingPlayer = true);

    try {
      _player = await getPlayer();
      _player ??=
          Player(null)
            ..gender = 'perempuan'
            ..isFocused = false;
      _player!.gender ??= 'perempuan';
      await savePlayer(_player!);
    } catch (e) {
      _player =
          Player(null)
            ..gender = 'perempuan'
            ..isFocused = false;
    }

    setState(() => _isLoadingPlayer = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingPlayer) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Background(
        gender: _player?.gender ?? 'perempuan',
        child: SizedBox(
          height: 100.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left side image
              Expanded(
                flex: 2,
                child: Center(
                  child: FloatAnimatedWidget(
                    child: Image.asset(
                      'assets/images/${_player?.gender == 'laki-laki' ? 'male-goto-toilet.png' : 'female-goto-toilet.png'}',
                      height: Responsive.isTablet(context) ? 40.h : 50.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // Right side content
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.only(
                    right: Responsive.isTablet(context) ? 6.w : 8.w,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BorderedText(
                        strokeWidth: 8.0,
                        strokeColor: const Color(0xFF4A2C2A),
                        child: Text(
                          "APLIKASI INTERAKTIF",
                          style: TextStyle(
                            fontSize:
                                Responsive.isTablet(context) ? 24.sp : 20.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFFA07A),
                          ),
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      BorderedText(
                        strokeWidth: 8.0,
                        strokeColor: const Color.fromARGB(255, 3, 112, 112),
                        child: Text(
                          "POTTY FUN KID'S",
                          style: TextStyle(
                            fontSize:
                                Responsive.isTablet(context) ? 24.sp : 20.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF00FFFF),
                          ),
                        ),
                      ),
                      SizedBox(height: 1.h),

                      // Play Button
                      PlayButton(
                        onPressed: () {
                          Get.to(
                            () => const ChooseGenderScreen(),
                            transition: Transition.circularReveal,
                            duration: const Duration(milliseconds: 1500),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
