import 'dart:convert';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:toilet_training/models/player.dart';
import 'package:toilet_training/models/step.dart';
import 'package:toilet_training/screens/levels/level2_screen.dart';
import 'package:toilet_training/services/player_service.dart';
import 'package:toilet_training/widgets/background.dart';
import 'package:toilet_training/widgets/header.dart';
import 'package:toilet_training/widgets/modal_setting.dart';
// Import untuk Level 2 jika diperlukan saat navigasi "Lanjut"
// import 'package:toilet_training/screens/levels/level2_screen.dart';

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
        _player = Player(null);
        _player!.gender = 'perempuan';
        _player!.isFocused = false;
        await savePlayer(_player!);
      }
      _player!.gender ??= 'perempuan';
      _player!.isFocused ??= false; // Pastikan isFocused ada nilainya
    } catch (e) {
      print("Error loading player in LevelOneScreen: $e. Creating default.");
      _player = Player(null);
      _player!.gender = 'perempuan';
      _player!.isFocused = false;
      // await savePlayer(_player!); // Pertimbangkan jika perlu disimpan saat error
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

    final String characterImage =
        (_player?.gender == 'perempuan')
            ? 'assets/images/female-goto-toilet.png'
            : 'assets/images/male-goto-toilet.png';

    return Scaffold(
      body: Background(
        gender: _player?.gender ?? 'perempuan',
        child: Column(
          children: [
            Header(title: ""), // Title bisa disesuaikan
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 300, // Sesuaikan ukuran jika perlu
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Image.asset(characterImage, fit: BoxFit.contain),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
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
                              color: Color(
                                0xFF00FFFF,
                              ), // Warna bisa disesuaikan
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
                              color: Color(
                                0xFF00FFFF,
                              ), // Warna bisa disesuaikan
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
                              if (_player != null) {
                                Get.to(
                                  () =>
                                      LevelOneFocusScreen(), // Navigasi ke LevelOneFocusScreen
                                );
                              } else {
                                // Handle jika _player masih null
                                print(
                                  "Player data is not loaded yet for LevelOneFocusScreen navigation.",
                                );
                              }
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
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
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
      _player!.gender ??= 'perempuan';
      _player!.isFocused ??= false;
    } catch (e) {
      print("Error loading player in LevelOneFocus: $e. Using default player.");
      _player =
          Player(null)
            ..gender = 'perempuan'
            ..isFocused = false;
      // await savePlayer(_player!); // Simpan jika player baru dibuat karena error
    }
    await _determineImagePaths(); // Ini juga akan memanggil setState
    if (mounted) {
      setState(() {
        _isLoadingPlayer = false;
      });
    }
  }

  Future<void> _determineImagePaths() async {
    List<String> paths = [];
    if (_player == null) {
      print("Player is null in _determineImagePaths. Cannot load images.");
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

      if (paths.isEmpty) {
        print(
          "No images found in JSON for Gender: ${_player!.gender}, Focused: ${_player!.isFocused}",
        );
      }
    } catch (e) {
      print("Error loading steps from JSON for Level 1: $e");
      paths = [];
    }
    if (mounted) {
      setState(() {
        _imagePaths = paths;
      });
    }
  }

  Future<void> _showSettingsModal(BuildContext context) async {
    final currentContext = context; // Simpan context sebelum async gap
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
    // Setelah modal ditutup, muat ulang data pemain dan gambar
    // Pastikan _player diperbarui sebelum _determineImagePaths
    await _loadPlayerDataAndSetupImages();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingPlayer || _player == null) {
      return Scaffold(
        body: Background(
          gender:
              _player?.gender ?? 'perempuan', // Default jika _player masih null
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Scaffold(
      body: Background(
        gender: _player!.gender!, // _player dijamin tidak null di sini
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Header(
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
              SingleChildScrollView(
                // Mungkin perlu Expanded di sini jika konten bisa besar
                scrollDirection: Axis.horizontal,
                child: Padding(
                  // Tambahkan padding di sekitar Row
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center, // Pusatkan gambar jika sedikit
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
                                  fit:
                                      BoxFit
                                          .contain, // Ubah ke contain agar rasio aspek terjaga
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
              ),
            Padding(
              // Pindahkan tombol ke dalam Column dan gunakan Padding
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
  Player?
  _playerObject; // Ubah nama untuk menghindari kebingungan dengan variabel player lain
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
      _playerObject = await getPlayer();
      if (_playerObject != null) {
        _currentIsFocused = _playerObject!.isFocused ?? widget.isFocused;

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
            "No images for game after settings update. Gender: ${widget.gender}, Focused: $_currentIsFocused",
          );
        }
      } else {
        // Jika _playerObject null setelah getPlayer(), gunakan data widget awal
        _currentIsFocused = widget.isFocused;
        _currentImagePathsForGame = List.from(widget.imagePathsForGame);
        print(
          "Player object is null after getPlayer(). Using initial widget data for game.",
        );
      }
    } catch (e) {
      print(
        "Error loading player/steps in LevelOnePlayScreen: $e. Using initial focus and paths.",
      );
      _currentIsFocused = widget.isFocused; // Fallback ke widget.isFocused
      _currentImagePathsForGame = List.from(
        widget.imagePathsForGame,
      ); // Fallback
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
        _gameKey = UniqueKey();
      });
    }
  }

  Future<void> _showSettingsModal() async {
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

    if (_currentImagePathsForGame.isEmpty && !_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Susun Langkah Toilet"),
        ), // Placeholder AppBar
        body: Background(
          gender: widget.gender,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tidak ada gambar yang dapat dimuat untuk game saat ini.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.red.shade800),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Get.back(), // Kembali ke layar sebelumnya
                  child: Text("Kembali"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Background(
        gender: widget.gender,
        child: Column(
          children: [
            Header(
              title: "Susun Langkah Toilet",
              onTapSettings: _showSettingsModal,
            ),
            Expanded(
              child: GameWidget(
                key: _gameKey,
                game: ToiletSortGame(
                  context:
                      context, // Berikan BuildContext dari LevelOnePlayScreen
                  gender: widget.gender,
                  isFocused: _currentIsFocused,
                  imagePaths: List.from(_currentImagePathsForGame),
                ),
                overlayBuilderMap: {
                  'checkButton': (ctx, game) {
                    final toiletGame = game as ToiletSortGame;
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: ElevatedButton(
                          onPressed:
                              toiletGame.isLoading
                                  ? null
                                  : toiletGame
                                      .checkOrder, // Nonaktifkan jika game sedang loading
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                widget.gender == 'laki-laki'
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
                                widget.gender == 'laki-laki'
                                    ? const Color(0xFF52AACA)
                                    : const Color(0xFFFC9D99),
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
      print(
        "Error: imagePaths is empty for ToiletSortGame. Cannot initialize.",
      );
      setStateQuietly(() {
        isLoading = false;
      });
      // Mungkin tampilkan pesan error ke pengguna melalui Flutter widget
      // atau handle dengan cara lain agar game tidak crash.
      return;
    }

    // Memuat data ID dari JSON berdasarkan gender dan focus (seperti di LevelOneFocusScreen)
    // Ini penting agar kita punya pemetaan imagePath ke ID yang benar
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

    // Filter imagePaths yang diterima dari widget agar hanya mengandung yang ada di allStepsForContext
    // dan memiliki ID di imagePathToIdMap
    // List<String> validGameImagePaths =
    //     imagePaths.where((path) => imagePathToIdMap.containsKey(path)).toList();

    if (allStepsForContext.length < sequenceLength) {
      print(
        "Error: Not enough steps (${allStepsForContext.length}) in allStepsForContext for sequence length ($sequenceLength) | Gender: $gender, Fokus: $isFocused",
      );
      // Optional: Sesuaikan sequenceLength jika memungkinkan atau tampilkan pesan ke pengguna
      // if (allStepsForContext.isNotEmpty) {
      //   sequenceLength = allStepsForContext.length;
      // } else {
      //   setStateQuietly(() {
      //     isLoading = false;
      //   });
      //   // Tampilkan pesan error di UI melalui Flutter widget
      //   // Misalnya, dengan memanggil callback atau mengubah state yang diamati oleh widget
      //   // ScaffoldMessenger.of(context).showSnackBar(
      //   //   SnackBar(content: Text("Tidak cukup langkah untuk memulai permainan.")),
      //   // );
      //   return;
      // }
      setStateQuietly(() {
        isLoading = false;
      });
      // Penting: Beritahu pengguna melalui UI jika game tidak bisa dimulai.
      // Ini bisa dilakukan dengan mengubah state yang diobservasi oleh LevelOnePlayScreen
      // atau memanggil callback yang menampilkan dialog/snackbar.
      // Untuk sekarang, kita return agar tidak crash, tapi idealnya ada feedback ke user.
      // Contoh pemberitahuan (perlu disesuaikan dengan arsitektur):
      // if (context.mounted) { // Pastikan context masih valid
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text("Tidak cukup langkah untuk game ini (min: $sequenceLength). Coba ubah pengaturan.")),
      //     );
      //   });
      // }
      return;
    }

    // Pilih sequence secara acak dari allStepsForContext yang sudah berurutan
    final random = Random();
    int maxStartIndex = allStepsForContext.length - sequenceLength;
    int startIndex = 0;
    if (maxStartIndex > 0) {
      startIndex = random.nextInt(maxStartIndex + 1);
    } else {
      // Jika maxStartIndex adalah 0 atau negatif (misalnya allStepsForContext.length == sequenceLength)
      // maka startIndex harus 0.
      startIndex = 0;
    }

    List<ToiletStep> selectedSteps = allStepsForContext.sublist(
      startIndex,
      startIndex + sequenceLength,
    );

    correctImagePathSequence = selectedSteps.map((step) => step.image).toList();
    correctSequenceIds = selectedSteps.map((step) => step.id).toList();

    // Acak urutan untuk ditampilkan ke player
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
        print("Error loading sprite $spritePath in _initializeGame: $e");
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
      print("Level 1 score saved: $stars stars");
    } catch (e) {
      print("Error saving score for Level 1: $e");
    }
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
                Get.off(() => const LevelTwoScreen());
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
