import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:toilet_training/models/player.dart';
import 'package:toilet_training/models/step.dart';
import 'package:toilet_training/services/player_service.dart';
import 'package:toilet_training/widgets/background.dart';
import 'package:toilet_training/widgets/header.dart';
import 'package:toilet_training/widgets/modal_setting.dart';
import 'package:toilet_training/screens/levels/level1/level1_play_screen.dart';
import 'package:toilet_training/screens/menus/choose_level_screen.dart';

class LevelOneFocusScreen extends StatefulWidget {
  const LevelOneFocusScreen({super.key});

  @override
  State<LevelOneFocusScreen> createState() => _LevelOneFocusScreenState();
}

class _LevelOneFocusScreenState extends State<LevelOneFocusScreen> {
  Player? _player;
  bool _isLoadingPlayer = true;
  List<String> _imagePaths = [];
  final ScrollController _scrollController = ScrollController();
  bool _showLeftArrow = false;
  bool _showRightArrow = true;

  @override
  void initState() {
    super.initState();
    _loadPlayerDataAndSetupImages();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scrollListener();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!mounted || !_scrollController.hasClients) return;

    final position = _scrollController.position;
    final hasScrollableContent =
        position.maxScrollExtent > position.minScrollExtent;

    setState(() {
      if (hasScrollableContent) {
        _showLeftArrow = position.pixels > position.minScrollExtent;
        _showRightArrow = position.pixels < position.maxScrollExtent;
      } else {
        _showLeftArrow = false;
        _showRightArrow = false;
      }
    });
  }

  Future<void> _loadPlayerDataAndSetupImages() async {
    setState(() {
      _isLoadingPlayer = true;
    });
    try {
      _player = await getPlayer();
      _player!.gender ??= 'perempuan';
      _player!.isFocused ??= false;
    } catch (e) {
      _player =
          Player(null)
            ..gender = 'perempuan'
            ..isFocused = false;
      await savePlayer(_player!);
    }
    await _determineImagePaths();
    if (mounted) {
      setState(() {
        _isLoadingPlayer = false;
      });
      // Call scroll listener after images are loaded and layout is updated
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _scrollListener();
        }
      });
    }
  }

  Future<void> _determineImagePaths() async {
    List<String> paths = [];
    if (_player == null) {
      if (mounted) {
        setState(() {
          _imagePaths = [];
        });
      }
      return;
    }
    try {
      final String response = await rootBundle.loadString(
        'lib/models/static/step-static.json',
      );
      final List<dynamic> data = json.decode(response);
      List<ToiletStep> steps =
          data.map((e) => ToiletStep.fromJson(e)).where((step) {
            return step.gender == _player!.gender &&
                step.focus == _player!.isFocused;
          }).toList();
      steps.sort((a, b) => a.id.compareTo(b.id));
      paths = steps.map((step) => step.image).toList();

      if (paths.isEmpty) {}
    } catch (e) {
      paths = [];
    }
    if (mounted) {
      setState(() {
        _imagePaths = paths;
      });
    }
  }

  Future<void> _showSettingsModal(BuildContext context) async {
    final currentContext = context;
    await showDialog(
      context: currentContext,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SettingsModalContent(
            onClose: () {
              Navigator.of(dialogContext).pop();
            },
          ),
        );
      },
    );
    await _loadPlayerDataAndSetupImages();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingPlayer || _player == null) {
      return Scaffold(
        body: Background(
          gender: _player?.gender ?? 'perempuan',
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Scaffold(
      body: Background(
        gender: _player!.gender!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Header(
              onTapBack: () {
                Get.off(() => const ChooseLevelScreen());
              },
              title: "Latih Fokusmu !",
              onTapSettings: () => _showSettingsModal(context),
            ),
            if (_imagePaths.isEmpty && !_isLoadingPlayer)
              Expanded(
                child: Center(
                  child: Text(
                    _player!.isFocused == true
                        ? "Tidak ada gambar fokus yang ditemukan untuk gender ini."
                        : "Tidak ada gambar non-fokus yang dikonfigurasi untuk gender ini.",
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else if (_imagePaths.isNotEmpty)
              Expanded(
                // Added Expanded to ensure Stack takes available space
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              _imagePaths
                                  .map(
                                    (path) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: Image.asset(
                                        path,
                                        width: 150.0,
                                        height: 200.0,
                                        fit: BoxFit.contain,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Container(
                                            width: 150,
                                            height: 200,
                                            color: Colors.grey[300],
                                            child: Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                color: Colors.grey[600],
                                                size: 50,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC2E0FF),
                    foregroundColor: const Color(0xFF52AACA),
                  ),
                  onPressed:
                      _isLoadingPlayer || _imagePaths.isEmpty
                          ? null
                          : () {
                            if (_player != null) {
                              Get.to(
                                () => LevelOnePlayScreen(
                                  gender: _player!.gender!,
                                  isFocused: _player!.isFocused!,
                                  imagePathsForGame: _imagePaths,
                                ),
                              );
                            }
                          },
                  child: const Text("Selanjutnya"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
