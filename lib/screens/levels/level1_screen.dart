import 'dart:math';
import 'dart:convert';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toilet_training/widgets/background.dart';
import 'package:toilet_training/widgets/header.dart';
import 'package:toilet_training/models/player.dart';
import 'package:toilet_training/services/player_service.dart';
import 'package:toilet_training/widgets/modal_setting.dart';
import 'package:flutter/services.dart';
import 'package:toilet_training/models/step.dart';

class LevelOneScreen extends StatefulWidget {
  const LevelOneScreen({super.key});

  @override
  State<LevelOneScreen> createState() => _LevelOneScreenState();
}

class _LevelOneScreenState extends State<LevelOneScreen> {
  Player? _player;
  bool _isLoadingPlayer = true;

  @override
  void initState() {
    super.initState();
    _loadPlayerData();
  }

  Future<void> _loadPlayerData() async {
    setState(() {
      _isLoadingPlayer = true;
    });
    try {
      _player = await getPlayer();
      if (_player == null) {
        print("Player data not found in LevelOneScreen! Creating default.");
        _player = Player(null); // Assuming ID is nullable or auto-generated
        _player!.gender = 'perempuan'; // Default gender
        _player!.isFocused = false;
        await savePlayer(_player!);
      }
      // Ensure gender is not null, provide a default if necessary
      _player!.gender ??= 'perempuan';
    } catch (e) {
      print("Error loading player in LevelOneScreen: $e. Creating default.");
      _player = Player(null);
      _player!.gender = 'perempuan';
      _player!.isFocused = false;
      // It's good practice to save the default player if one was created due to an error
      // await savePlayer(_player!); // Consider if saving here is appropriate for all error types
    }
    setState(() {
      _isLoadingPlayer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingPlayer) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Determine image based on player's gender, default to male if null for image path
    final String characterImage =
        (_player?.gender == 'perempuan')
            ? 'assets/images/female-goto-toilet.png'
            : 'assets/images/male-goto-toilet.png';

    return Scaffold(
      body: Background(
        gender:
            _player?.gender ??
            'perempuan', // Use loaded gender, default if null
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.only(bottom: 0),
                child: Image.asset(characterImage, fit: BoxFit.contain),
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
  Player? _player;
  bool _isLoadingPlayer = true;
  List<String> _imagePaths = [];

  @override
  void initState() {
    super.initState();
    _loadPlayerDataAndSetupImages();
  }

  Future<void> _loadPlayerDataAndSetupImages() async {
    setState(() {
      _isLoadingPlayer = true;
    });
    try {
      _player = await getPlayer();
      if (_player == null) {
        print("Player data not found in LevelOneFocus! Creating default.");
        _player = Player(null);
        _player!.gender = 'perempuan';
        _player!.isFocused = false;
        await savePlayer(_player!);
      }
      _player!.gender ??= 'perempuan';
      _player!.isFocused ??= false;
    } catch (e) {
      print("Error loading player in LevelOneFocus: $e. Creating default.");
      _player = Player(null);
      _player!.gender = 'perempuan';
      _player!.isFocused = false;
      await savePlayer(_player!);
    }
    await _determineImagePaths();
    setState(() {
      _isLoadingPlayer = false;
    });
  }

  Future<void> _determineImagePaths() async {
    List<String> paths = [];
    try {
      final String response = await rootBundle.loadString(
        'lib/models/static/step-static.json',
      );
      final List<dynamic> data = json.decode(response);
      List<ToiletStep> steps =
          data.map((e) => ToiletStep.fromJson(e)).where((step) {
            return step.gender == _player?.gender &&
                step.focus == _player?.isFocused;
          }).toList();
      steps.sort((a, b) => a.id.compareTo(b.id));
      paths = steps.map((step) => step.image).toList();

      if (paths.isEmpty) {
        print(
          "No images found in JSON for Gender: ${_player?.gender}, Focused: ${_player?.isFocused}",
        );
      }
    } catch (e) {
      print("Error loading steps from JSON for Level 1: $e");
      paths = [];
    }

    setState(() {
      _imagePaths = paths;
    });

    print(
      "Player Gender: ${_player?.gender}, Is Focused: ${_player?.isFocused}",
    );
    print("Displaying images in FocusScreen: ${_imagePaths.join(', ')}");
  }

  Future<void> _showSettingsModal(BuildContext context) async {
    await showDialog(
      context: context,
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
    _loadPlayerDataAndSetupImages();
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

    final List<String> currentImagePaths = _imagePaths ?? [];

    return Scaffold(
      body: Background(
        gender: _player?.gender ?? 'perempuan',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Header(
              title: "Latih Fokusmu !",
              onTapSettings: () => _showSettingsModal(context),
            ),
            if (currentImagePaths.isEmpty && !_isLoadingPlayer)
              Expanded(
                child: Center(
                  child: Text(
                    _player!.isFocused == true
                        ? "Tidak ada gambar fokus yang ditemukan di JSON untuk gender ini."
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
            else if (currentImagePaths.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      currentImagePaths
                          .map(
                            (path) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Image.asset(
                                path,
                                width: 150.0,
                                height: 200.0,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) {
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
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC2E0FF),
                    foregroundColor: Color(0xFF52AACA),
                  ),
                  onPressed:
                      _isLoadingPlayer || currentImagePaths.isEmpty
                          ? null
                          : () {
                            Get.to(
                              () => LevelOnePlayScreen(
                                gender: _player!.gender!,
                                isFocused: _player!.isFocused!,
                                imagePathsForGame: currentImagePaths,
                              ),
                            );
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

class LevelOnePlayScreen extends StatefulWidget {
  final String gender;
  final bool isFocused;
  final List<String> imagePathsForGame;

  const LevelOnePlayScreen({
    super.key,
    required this.gender,
    required this.isFocused,
    required this.imagePathsForGame,
  });

  @override
  State<LevelOnePlayScreen> createState() => _LevelOnePlayScreenState();
}

class _LevelOnePlayScreenState extends State<LevelOnePlayScreen> {
  late bool _currentIsFocused;
  late List<String> _currentImagePathsForGame;
  Player? _player;
  bool _isLoading = true;
  UniqueKey _gameKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _currentIsFocused = widget.isFocused;
    _currentImagePathsForGame = List.from(widget.imagePathsForGame);
    _loadPlayerStatusAndUpdateGame();
  }

  Future<void> _loadPlayerStatusAndUpdateGame() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _player = await getPlayer();
      if (_player != null) {
        _currentIsFocused = _player!.isFocused ?? widget.isFocused;

        // Memuat ulang dan memfilter imagePathsForGame berdasarkan _currentIsFocused yang baru
        final String response = await rootBundle.loadString(
          'lib/models/static/step-static.json',
        );
        final List<dynamic> data = json.decode(response);
        List<ToiletStep> steps =
            data.map((e) => ToiletStep.fromJson(e)).where((step) {
              return step.gender == widget.gender &&
                  step.focus == _currentIsFocused;
            }).toList();
        steps.sort((a, b) => a.id.compareTo(b.id));
        _currentImagePathsForGame = steps.map((step) => step.image).toList();

        if (_currentImagePathsForGame.isEmpty) {
          print(
            "No images found for game after settings update. Gender: ${widget.gender}, Focused: $_currentIsFocused",
          );
        }
        print(
          "Updated _currentImagePathsForGame for game: ${_currentImagePathsForGame.join(', ')}",
        );
      } else {
        _currentIsFocused = widget.isFocused;
        // Jika player tidak ada, _currentImagePathsForGame tetap menggunakan nilai dari widget.
        // Atau, Anda bisa memutuskan untuk mengosongkannya atau memuat default.
        _currentImagePathsForGame = List.from(widget.imagePathsForGame);
      }
    } catch (e) {
      print(
        "Error loading player/steps in LevelOnePlayScreen: $e. Using initial focus and paths.",
      );
      _currentIsFocused = widget.isFocused;
      _currentImagePathsForGame = List.from(widget.imagePathsForGame);
    }

    setState(() {
      _isLoading = false;
      _gameKey =
          UniqueKey(); // Ganti key untuk memaksa GameWidget membuat ulang game
    });
  }

  Future<void> _showSettingsModal() async {
    await showDialog(
      context: context,
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
    // Setelah modal ditutup, muat ulang status pemain dan perbarui game
    await _loadPlayerStatusAndUpdateGame();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Background(
          gender: widget.gender,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Scaffold(
      body: Background(
        gender:
            widget.gender, // Gender tetap dari widget, tidak berubah di sini
        child: Column(
          children: [
            Header(
              title: "Susun Langkah Toilet",
              onTapSettings:
                  _showSettingsModal, // Panggil method untuk menampilkan modal & update
            ),
            Expanded(
              child: GameWidget(
                key: _gameKey, // Gunakan UniqueKey di sini
                game: ToiletSortGame(
                  context: context,
                  gender: widget.gender,
                  isFocused:
                      _currentIsFocused, // Gunakan status fokus yang terbaru
                  imagePaths: List.from(_currentImagePathsForGame),
                ),
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
                            backgroundColor:
                                widget.gender ==
                                        'laki-laki' // Gunakan widget.gender untuk style
                                    ? const Color(0xFFC2E0FF)
                                    : const Color(0xFFFFDDD2),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 15,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            foregroundColor:
                                widget.gender ==
                                        'laki-laki' // Gunakan widget.gender untuk style
                                    ? Color(0xFF52AACA)
                                    : Color(0xFFFC9D99),
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
  List<int> correctSequenceIds = [];
  List<String> correctImagePathSequence = [];
  List<ImageSprite> currentImageSprites = [];
  bool isLoading = true;

  int minImageNum = 0;
  int maxImageNum = 0;
  int sequenceLength = 3;
  final double imageSize = 160.0;
  final double placeholderPadding = 5.0;
  final double placeholderSize = 160.0 + 2 * 5.0;
  final double spacing = 15.0;
  double yPosition = 0;

  List<PlaceholderSlot> placeholderSlots = [];
  final String gender;
  final bool isFocused;
  final List<String> imagePaths;
  Map<String, int> imagePathToIdMap = {};

  ToiletSortGame({
    required this.context,
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
    isLoading = true;
    for (var sprite in currentImageSprites) {
      remove(sprite);
    }
    currentImageSprites.clear();
    for (var slot in placeholderSlots) {
      remove(slot);
    }
    placeholderSlots.clear();
    imagePathToIdMap.clear();
    correctSequenceIds.clear();
    correctImagePathSequence.clear();

    List<String> gameImagePaths = [];

    if (imagePaths.length < sequenceLength) {
      print(
        "Error: Tidak cukup gambar yang di-pass (${imagePaths.length}) untuk sequence length ($sequenceLength) | Gender: $gender, Fokus: $isFocused",
      );
      isLoading = false;
      return;
    }

    final String response = await rootBundle.loadString(
      'lib/models/static/step-static.json',
    );
    final List<dynamic> jsonData = json.decode(response);
    List<ToiletStep> allRelevantStepsForGame =
        jsonData.map((e) => ToiletStep.fromJson(e)).where((step) {
          return step.gender == this.gender && step.focus == this.isFocused;
        }).toList();
    allRelevantStepsForGame.sort((a, b) => a.id.compareTo(b.id));

    for (var step in allRelevantStepsForGame) {
      imagePathToIdMap[step.image] = step.id;
    }

    List<ToiletStep> stepsForSequenceSelection =
        allRelevantStepsForGame
            .where((step) => this.imagePaths.contains(step.image))
            .toList();

    if (stepsForSequenceSelection.length >= sequenceLength) {
      final random = Random();
      int startIndex = 0;
      if (stepsForSequenceSelection.length - sequenceLength > 0) {
        startIndex = random.nextInt(
          stepsForSequenceSelection.length - sequenceLength + 1,
        );
      }
      for (int i = 0; i < sequenceLength; i++) {
        if (startIndex + i < stepsForSequenceSelection.length) {
          ToiletStep step = stepsForSequenceSelection[startIndex + i];
          correctSequenceIds.add(step.id);
          correctImagePathSequence.add(step.image);
        } else {
          print(
            "Warning: StartIndex + i out of bounds in game initialization.",
          );
          break;
        }
      }
      if (correctImagePathSequence.length == sequenceLength) {
        gameImagePaths.addAll(correctImagePathSequence);
        List<String> tempShuffledPaths = List.from(correctImagePathSequence);
        bool areEqual;
        int safetyBreak = 0;
        do {
          tempShuffledPaths.shuffle(random);
          areEqual = _arePathListsEqual(
            tempShuffledPaths,
            correctImagePathSequence,
          );
          safetyBreak++;
        } while (areEqual && tempShuffledPaths.length > 1 && safetyBreak < 20);
        gameImagePaths = tempShuffledPaths;
      } else {
        print("Tidak dapat membentuk sequence lengkap dari step yang relevan.");
        isLoading = false;
        return;
      }
    } else {
      print(
        "Tidak cukup step (${stepsForSequenceSelection.length}) yang cocok dengan imagePaths dari JSON untuk membentuk sequence ($sequenceLength).",
      );
      isLoading = false;
      return;
    }

    if (gameImagePaths.length < sequenceLength) {
      print("Tidak cukup gambar untuk memulai game setelah pemrosesan.");
      isLoading = false;
      return;
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

    List<String> imagesToDisplayInGame = List.from(gameImagePaths);

    for (int i = 0; i < imagesToDisplayInGame.length; i++) {
      final path = imagesToDisplayInGame[i];
      final placeholderForThisImage = placeholderSlots[i];

      String spritePath = path;
      if (path.startsWith('assets/images/')) {
        spritePath = path.substring('assets/images/'.length);
      }
      final sprite = await Sprite.load(spritePath);

      int imageIdentifier = imagePathToIdMap[path] ?? 0;
      if (imageIdentifier == 0 && path.isNotEmpty) {
        print(
          "Warning: ID tidak ditemukan untuk path gambar '$path' saat membuat ImageSprite.",
        );
      }

      final imageComponent = ImageSprite(
        sprite: sprite,
        imagePath: path,
        imageIdentifier: imageIdentifier,
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

  void checkOrder() {
    if (isLoading) return;

    List<int> displayedOrderIds = getCurrentOrderIds();
    bool isCorrect = _areListsEqual(displayedOrderIds, correctSequenceIds);

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
  Color backgroundColor() => Colors.transparent;
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
  final String imagePath;
  final int imageIdentifier;
  Vector2 initialPosition;
  Vector2 dragOffset = Vector2.zero();
  final ToiletSortGame gameRef;

  ImageSprite({
    required Sprite? sprite,
    required this.imagePath,
    required this.imageIdentifier,
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
