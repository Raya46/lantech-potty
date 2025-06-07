import 'package:audioplayers/audioplayers.dart';

class AudioController {
  static final AudioController _instance = AudioController._internal();
  factory AudioController() => _instance;

  final AudioPlayer _player = AudioPlayer();

  AudioController._internal() {
    _player.setReleaseMode(ReleaseMode.loop); 
    _player.setVolume(0.4); 
  }

  Future<void> startBackgroundMusic() async {
    try {
      await _player.play(AssetSource('sounds/backgound_music.mp3'));
    } catch (e) {
      print('❌ Failed to play music: $e');
    }
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume); 
  }

  Future<void> stopMusic() async {
    await _player.stop();
  }

  Future<void> pauseMusic() async {
    await _player.pause();
  }

  Future<void> resumeMusic() async {
    await _player.resume();
  }
}
