import 'dart:convert';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:toilet_training/models/player.dart';
import 'package:toilet_training/models/step.dart';
import 'package:toilet_training/screens/levels/level2/level2_start_screen.dart';
import 'package:toilet_training/services/player_service.dart';
import 'package:toilet_training/games/sort_game/sort_game_component.dart';

class ToiletSortGame extends FlameGame {
  final BuildContext context;
  List<int> correctSequenceIds = [];
  List<String> correctImagePathSequence = [];
  List<ImageSprite> currentImageSprites = [];
  bool isLoading = true;

  int sequenceLength =
      3; // Harus lebih kecil atau sama dengan jumlah gambar yang tersedia
  final double imageSize = 160.0;
  final double placeholderPadding = 5.0;
  final double placeholderSize = 160.0 + 2 * 5.0;
  final double spacing = 15.0;
  double yPosition = 0;

  List<PlaceholderSlot> placeholderSlots = [];
  final String gender;
  final bool isFocused;
  final List<String>
  imagePaths; // Daftar path gambar yang sudah difilter untuk game
  Map<String, int> imagePathToIdMap = {};
  int _wrongAttempts = 0;

  ToiletSortGame({
    required this.context, // Terima context dari Flutter
    required this.gender,
    required this.isFocused,
    required this.imagePaths,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.backdrop = Component();
    overlays.add('checkButton');
    await _initializeGame();
  }

  Future<void> _initializeGame() async {
    setStateQuietly(() {
      // Gunakan untuk update internal Flame tanpa memicu rebuild besar
      isLoading = true;
      _wrongAttempts = 0;
      currentImageSprites.forEach(remove);
      currentImageSprites.clear();
      placeholderSlots.forEach(remove);
      placeholderSlots.clear();
      imagePathToIdMap.clear();
      correctSequenceIds.clear();
      correctImagePathSequence.clear();
    });

    if (imagePaths.isEmpty) {
      setStateQuietly(() {
        isLoading = false;
      });

      return;
    }

    final String jsonResponse = await rootBundle.loadString(
      'lib/models/static/step-static.json',
    );
    final List<dynamic> jsonData = json.decode(jsonResponse);
    List<ToiletStep> allStepsForContext =
        jsonData
            .map((e) => ToiletStep.fromJson(e))
            .where(
              (step) =>
                  step.gender == this.gender && step.focus == this.isFocused,
            )
            .toList();
    allStepsForContext.sort((a, b) => a.id.compareTo(b.id));

    for (var step in allStepsForContext) {
      imagePathToIdMap[step.image] = step.id;
    }

    if (allStepsForContext.length < sequenceLength) {
      setStateQuietly(() {
        isLoading = false;
      });
      return;
    }

    final random = Random();
    int maxStartIndex = allStepsForContext.length - sequenceLength;
    int startIndex = 0;
    if (maxStartIndex > 0) {
      startIndex = random.nextInt(maxStartIndex + 1);
    } else {
      startIndex = 0;
    }

    List<ToiletStep> selectedSteps = allStepsForContext.sublist(
      startIndex,
      startIndex + sequenceLength,
    );

    correctImagePathSequence = selectedSteps.map((step) => step.image).toList();
    correctSequenceIds = selectedSteps.map((step) => step.id).toList();

    List<String> displayImagePaths = List.from(correctImagePathSequence);
    bool areEqual;
    int safetyBreak = 0;
    do {
      displayImagePaths.shuffle(random);
      areEqual = _arePathListsEqual(
        displayImagePaths,
        correctImagePathSequence,
      );
      safetyBreak++;
    } while (areEqual && displayImagePaths.length > 1 && safetyBreak < 20);

    double totalWidthOfPlaceholders =
        (placeholderSize * sequenceLength) + (spacing * (sequenceLength - 1));
    double startXPlaceholders = (size.x - totalWidthOfPlaceholders) / 2;
    yPosition = (size.y - placeholderSize - 100) / 2;
    if (yPosition < 20) yPosition = 20;

    for (int i = 0; i < sequenceLength; i++) {
      final placeholder = PlaceholderSlot(
        position: Vector2(
          startXPlaceholders + i * (placeholderSize + spacing),
          yPosition,
        ),
        size: Vector2(placeholderSize, placeholderSize),
      );
      add(placeholder); // Tambahkan slot ke game
      placeholderSlots.add(placeholder);
    }

    for (int i = 0; i < displayImagePaths.length; i++) {
      final path = displayImagePaths[i];
      final placeholderForThisImage =
          placeholderSlots[i]; // Asumsi urutan placeholder sesuai

      String spritePath = path;
      if (path.startsWith('assets/images/')) {
        spritePath = path.substring('assets/images/'.length);
      }

      try {
        final sprite = await Sprite.load(spritePath);
        final imageId =
            imagePathToIdMap[path]!; // Kita sudah pastikan path valid

        final imageComponent = ImageSprite(
          sprite: sprite,
          imagePath: path,
          imageIdentifier: imageId,
          initialPosition: Vector2(
            placeholderForThisImage.position.x +
                (placeholderSize - imageSize) / 2,
            placeholderForThisImage.position.y +
                (placeholderSize - imageSize) / 2,
          ),
          size: Vector2(imageSize, imageSize),
          gameRef: this,
        );
        imageComponent.priority = 1;
        add(imageComponent); // Tambahkan sprite ke game
        currentImageSprites.add(imageComponent);
      } catch (e) {
        // Handle error, misal dengan skip atau placeholder
      }
    }
    setStateQuietly(() {
      isLoading = false;
    });
  }

  void setStateQuietly(VoidCallback fn) {
    fn();
  }

  bool _areListsEqual(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  bool _arePathListsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  List<int> getCurrentOrderIds() {
    currentImageSprites.sort((a, b) => a.position.x.compareTo(b.position.x));
    return currentImageSprites.map((sprite) => sprite.imageIdentifier).toList();
  }

  int _calculateStars(int wrongAttempts) {
    if (wrongAttempts == 0) return 3;
    if (wrongAttempts <= 2) return 2; // Contoh: 1 atau 2 kesalahan = 2 bintang
    return 1; // Lebih dari 2 kesalahan = 1 bintang
  }

  Future<void> _saveScore(int stars) async {
    try {
      Player player = await getPlayer();
      player.level1Score = stars;
      await updatePlayer(player);
    } catch (e) {}
  }

  void checkOrder() {
    if (isLoading) return;

    List<int> displayedOrderIds = getCurrentOrderIds();
    bool isCorrect = _areListsEqual(displayedOrderIds, correctSequenceIds);

    String dialogTitle;
    String dialogContentText;
    int starsEarned = 0;

    if (isCorrect) {
      starsEarned = _calculateStars(_wrongAttempts);
      dialogTitle = "Benar Sekali!";
      dialogContentText = "Kamu berhasil menyusunnya dengan benar.";
      _saveScore(starsEarned);
    } else {
      _wrongAttempts++;
      dialogTitle = "Oops, Coba Lagi! ${correctSequenceIds}";
      dialogContentText =
          "Susunannya belum tepat. Ayo coba lagi! ${correctSequenceIds}";
    }

    Widget starDisplay = Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Icon(
          index < starsEarned ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 30,
        );
      }),
    );

    Get.dialog(
      AlertDialog(
        title: Text(
          dialogTitle,
          style: TextStyle(
            color: isCorrect ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(dialogContentText),
            if (isCorrect) ...[
              const SizedBox(height: 10),
              starDisplay,
              const SizedBox(height: 5),
              Text(
                "Kamu mendapatkan $starsEarned bintang!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Get.back();
              if (isCorrect) {
                _initializeGame(); // Main lagi
              }
            },
          ),
          if (isCorrect)
            TextButton(
              child: const Text("Lanjut Level"),
              onPressed: () {
                Get.off(() => const LevelTwoStartScreen());
              },
            ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void onImageDrop(ImageSprite droppedSprite, Vector2 dropPosition) {
    currentImageSprites.sort((a, b) => a.position.x.compareTo(b.position.x));
    for (int i = 0; i < currentImageSprites.length; i++) {
      final targetPlaceholder = placeholderSlots[i];
      currentImageSprites[i].position = Vector2(
        targetPlaceholder.position.x + (placeholderSize - imageSize) / 2,
        targetPlaceholder.position.y + (placeholderSize - imageSize) / 2,
      );
    }
  }

  @override
  Color backgroundColor() => Colors.transparent;
}
