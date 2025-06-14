import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:toilet_training/screens/menus/start_screen.dart';
import 'package:toilet_training/services/audio_controller.dart';
import 'package:toilet_training/services/player_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AudioController().startBackgroundMusic();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersive,
    overlays: [SystemUiOverlay.bottom],
  );

  db = openDB();
  await db;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'Toilet Training',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: const StartScreen(),
        );
      },
    );
  }
}
