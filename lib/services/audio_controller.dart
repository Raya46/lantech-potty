import 'package:audioplayers/audioplayers.dart';

class AudioController {
  static final AudioController _instance = AudioController._internal();
  factory AudioController() => _instance;

  final AudioPlayer _player = AudioPlayer();
  bool isMusicOn = true;

  AudioController._internal() {
    _player.setReleaseMode(ReleaseMode.loop);
    _player.setVolume(0.4);
  }

  Future<void> startBackgroundMusic() async {
    if (isMusicOn) {
      await _player.play(AssetSource('sounds/background_music.mp3'));
    }
  }

  Future<void> toggleMusic() async {
    if (isMusicOn) {
      await stopMusic();
    } else {
      await resumeMusic();
    }
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  Future<void> stopMusic() async {
    await _player.stop();
    isMusicOn = false;
  }

  Future<void> pauseMusic() async {
    if (isMusicOn) {
      await _player.pause();
    }
  }

  Future<void> resumeMusic() async {
    await _player.resume();
    isMusicOn = true;
  }
}
