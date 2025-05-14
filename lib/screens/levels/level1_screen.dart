import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toilet_training/widgets/background.dart';
import 'package:toilet_training/widgets/header.dart';

class LevelOneScreen extends StatefulWidget {
  const LevelOneScreen({super.key});

  @override
  State<LevelOneScreen> createState() => _LevelOneScreenState();
}

class _LevelOneScreenState extends State<LevelOneScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        gender: 'male',
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.only(bottom: 0),
                child: Image.asset(
                  'assets/images/male-goto-toilet.png',
                  fit: BoxFit.contain,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Text(
                          "Ayo Belajar Tahapan",
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
                          "Ayo Belajar Tahapan",
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFA07A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      children: [
                        Text(
                          "Buang Air Besar dan",
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
                          "Buang Air Besar dan",
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00FFFF),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Text(
                          "Buang Air Kecil",
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
                          "Buang Air Kecil",
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00FFFF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(right: 100.0),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(
                              () => const LevelOneFocusScreen(),
                              transition: Transition.circularReveal,
                              duration: Duration(milliseconds: 1500),
                            );
                          },
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: const Color(0xFF52AACA),
                            child: const Icon(
                              Icons.play_arrow,
                              size: 45,
                              color: Colors.white,
                            ),
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
    );
  }
}

class LevelOneFocusScreen extends StatefulWidget {
  const LevelOneFocusScreen({super.key});

  @override
  State<LevelOneFocusScreen> createState() => _LevelOneFocusScreenState();
}

class _LevelOneFocusScreenState extends State<LevelOneFocusScreen> {
  String currentGender = 'male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        gender: currentGender,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Header(title: "Latih Fokusmu !"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 76; i <= 88; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Image.asset(
                        "assets/images/$i.png",
                        width: 150.0,
                        height: 200.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFC2E0FF),
                  foregroundColor: Color(0xFF52AACA),
                ),
                onPressed: () {
                  Get.to(() => const LevelOnePlayScreen());
                },
                child: const Text("Selanjutnya"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LevelOnePlayScreen extends StatelessWidget {
  const LevelOnePlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String currentGender = 'male';

    return Scaffold(
      body: Background(
        gender: currentGender,
        child: Column(
          children: [
            Header(title: "Susun Langkah Toilet"),
            Expanded(
              child: GameWidget(
                game: ToiletSortGame(context: context),
                overlayBuilderMap: {
                  'checkButton': (context, game) {
                    final toiletGame = game as ToiletSortGame;
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: ElevatedButton(
                          onPressed: toiletGame.checkOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF52AACA),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text("Periksa Urutan"),
                        ),
                      ),
                    );
                  },
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ToiletSortGame extends FlameGame {
  final BuildContext context;
  List<int> correctSequenceNumbers = [];
  List<ImageSprite> currentImageSprites = [];
  bool isLoading = true;

  final int minImageNum = 76;
  final int maxImageNum = 88;
  final int sequenceLength = 3;
  final double imageSize = 160.0;
  final double placeholderPadding = 5.0;
  final double placeholderSize = 160.0 + 2 * 5.0;
  final double spacing = 15.0;
  double yPosition = 0;

  List<PlaceholderSlot> placeholderSlots = [];

  ToiletSortGame({required this.context});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.backdrop = Component();

    overlays.add('checkButton');
    await _initializeGame();
  }

  Future<void> _initializeGame() async {
    isLoading = true;
    for (var sprite in currentImageSprites) {
      remove(sprite);
    }
    currentImageSprites.clear();
    for (var slot in placeholderSlots) {
      remove(slot);
    }
    placeholderSlots.clear();

    final random = Random();
    int numPossibleSequences =
        (maxImageNum - sequenceLength + 1) - minImageNum + 1;
    if (numPossibleSequences <= 0) numPossibleSequences = 1;

    int startNum = minImageNum + random.nextInt(numPossibleSequences);
    correctSequenceNumbers = List.generate(
      sequenceLength,
      (index) => startNum + index,
    );

    List<int> tempOrderNumbers = List.from(correctSequenceNumbers);

    if (sequenceLength > 1) {
      bool areEqual;
      int safetyBreak = 0;
      do {
        tempOrderNumbers.shuffle(random);
        areEqual = _areListsEqual(tempOrderNumbers, correctSequenceNumbers);
        safetyBreak++;
      } while (areEqual && safetyBreak < 10);
    }

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
      placeholderSlots.add(placeholder);
      add(placeholder);
    }

    for (int i = 0; i < tempOrderNumbers.length; i++) {
      final number = tempOrderNumbers[i];
      final placeholderForThisImage = placeholderSlots[i];

      final sprite = await Sprite.load(
        '$number.png',
        srcSize: Vector2(1200, 1200),
      );
      final imageComponent = ImageSprite(
        sprite: sprite,
        imageNumber: number,
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
      currentImageSprites.add(imageComponent);
      add(imageComponent);
    }
    isLoading = false;
  }

  bool _areListsEqual(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  List<int> getCurrentOrderNumbers() {
    currentImageSprites.sort((a, b) => a.position.x.compareTo(b.position.x));
    return currentImageSprites.map((sprite) => sprite.imageNumber).toList();
  }

  void checkOrder() {
    if (isLoading) return;

    List<int> displayedOrder = getCurrentOrderNumbers();
    bool isCorrect = _areListsEqual(displayedOrder, correctSequenceNumbers);

    Get.dialog(
      AlertDialog(
        title: Text(
          isCorrect ? "Benar Sekali!" : "Oops, Coba Lagi!",
          style: TextStyle(
            color: isCorrect ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isCorrect
                  ? "Kamu berhasil menyusunnya dengan benar."
                  : "Susunannya belum tepat. Ayo coba lagi!",
            ),
            if (!isCorrect)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Urutanmu: ${displayedOrder.join(' - ')}",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Urutan yang benar: ${correctSequenceNumbers.join(' - ')}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("OK", style: TextStyle(color: Color(0xFF52AACA))),
            onPressed: () {
              Get.back();
              if (isCorrect) {
                _initializeGame();
              }
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
  Color backgroundColor() {
    return const Color(0xFFC2E0FF);
  }
}

class PlaceholderSlot extends PositionComponent {
  PlaceholderSlot({super.position, super.size});

  final Paint _paint =
      Paint()
        ..color = Colors.blueGrey.withOpacity(0.2)
        ..style = PaintingStyle.fill;

  final Paint _borderPaint =
      Paint()
        ..color = Colors.blueGrey.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final rrect = RRect.fromRectAndRadius(
      size.toRect(),
      const Radius.circular(12),
    );
    canvas.drawRRect(rrect, _paint);
    canvas.drawRRect(rrect, _borderPaint);
  }
}

class ImageSprite extends SpriteComponent with DragCallbacks {
  final int imageNumber;
  Vector2 initialPosition;
  Vector2 dragOffset = Vector2.zero();
  final ToiletSortGame gameRef;

  ImageSprite({
    required Sprite? sprite,
    required this.imageNumber,
    required this.initialPosition,
    required Vector2 size,
    required this.gameRef,
  }) : super(sprite: sprite, position: initialPosition, size: size) {
    anchor = Anchor.topLeft;
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    priority = 10;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    position += event.localDelta;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    priority = 0;
    gameRef.onImageDrop(this, position);
  }
}
