import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toilet_training/models/player.dart';
import 'package:toilet_training/services/player_service.dart';
import 'package:toilet_training/widgets/background.dart';
import 'package:toilet_training/widgets/header.dart';
import 'package:toilet_training/screens/menus/choose_level_screen.dart';
import 'package:toilet_training/widgets/play_button.dart';

class LevelStartScreen extends StatefulWidget {
  LevelStartScreen({
    super.key,
    required this.levelText,
    required this.levelDescription,
    required this.levelScreen,
    this.player,
    this.isLoadingPlayer = true,
  });
  final String levelText;
  final String levelDescription;
  final Widget levelScreen;
  Player? player;
  bool isLoadingPlayer;

  @override
  State<LevelStartScreen> createState() => _LevelStartScreenState();
}

class _LevelStartScreenState extends State<LevelStartScreen>
    with TickerProviderStateMixin {
  late AnimationController _imageFloatController;
  late Animation<Offset> _offsetAnimation;

  late AnimationController _elementsAppearController;
  late Animation<double> _characterScaleAnimation;
  late Animation<double> _levelTextScaleAnimation;
  late Animation<double> _descriptionTextScaleAnimation;
  late Animation<double> _playButtonScaleAnimation;

  bool _playerDataLoaded = false;

  @override
  void initState() {
    super.initState();

    _imageFloatController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -0.05),
    ).animate(
      CurvedAnimation(parent: _imageFloatController, curve: Curves.easeInOut),
    );

    _elementsAppearController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _characterScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _elementsAppearController,
        curve: Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );

    _levelTextScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _elementsAppearController,
        curve: Interval(0.2, 0.6, curve: Curves.elasticOut),
      ),
    );

    _descriptionTextScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _elementsAppearController,
        curve: Interval(0.4, 0.8, curve: Curves.elasticOut),
      ),
    );

    _playButtonScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _elementsAppearController,
        curve: Interval(0.6, 1.0, curve: Curves.elasticOut),
      ),
    );

    _loadPlayerData();
  }

  @override
  void dispose() {
    _imageFloatController.dispose();
    _elementsAppearController.dispose();
    super.dispose();
  }

  Future<void> _loadPlayerData() async {
    try {
      widget.player = await getPlayer();
      widget.player?.gender ??= 'perempuan';
      widget.player?.isFocused ??= false;
      widget.player?.level1Score ??= 0;
      widget.player?.level2Score ??= 0;
      widget.player?.level3Score ??= 0;
      widget.player?.level4Score ??= 0;
      widget.player?.level5Score ??= 0;
    } catch (e) {
      widget.player =
          Player(null)
            ..gender = 'perempuan'
            ..isFocused = false
            ..level1Score = 0
            ..level2Score = 0
            ..level3Score = 0
            ..level4Score = 0
            ..level5Score = 0;
      await savePlayer(widget.player!);
    }
    if (mounted) {
      setState(() {
        widget.isLoadingPlayer = false;
        _playerDataLoaded = true;
      });
      if (_playerDataLoaded && !_elementsAppearController.isAnimating) {
        _elementsAppearController.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoadingPlayer || widget.player == null) {
      return Scaffold(
        body: Background(
          gender: widget.player?.gender ?? 'perempuan',
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Scaffold(
      body: Background(
        gender: widget.player!.gender!,
        child: Column(
          children: [
            Header(
              onTapBack: () {
                Get.off(() => const ChooseLevelScreen());
              },
              title: "",
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: ScaleTransition(
                          scale: _characterScaleAnimation,
                          child: SlideTransition(
                            position: _offsetAnimation,
                            child: Image.asset(
                              widget.player!.gender == 'perempuan'
                                  ? 'assets/images/female-happy.png'
                                  : 'assets/images/male-happy.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ScaleTransition(
                            scale: _levelTextScaleAnimation,
                            child: Stack(
                              children: [
                                Text(
                                  widget.levelText,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    foreground:
                                        Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 1.5
                                          ..color = const Color(0xFF4A2C2A),
                                  ),
                                ),
                                Text(
                                  widget.levelText,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFA07A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          ScaleTransition(
                            scale: _descriptionTextScaleAnimation,
                            child: Stack(
                              children: [
                                Text(
                                  widget.levelDescription,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    foreground:
                                        Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 1.5
                                          ..color = const Color(0xFF4A2C2A),
                                  ),
                                ),
                                Text(
                                  widget.levelDescription,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFA07A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          ScaleTransition(
                            scale: _playButtonScaleAnimation,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Center(
                                child: PlayButton(
                                  onPressed: () {
                                    Get.off(
                                      () => widget.levelScreen,
                                      transition: Transition.circularReveal,
                                      duration: const Duration(
                                        milliseconds: 1500,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
