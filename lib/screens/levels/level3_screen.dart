import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:toilet_training/games/hidden_object_game.dart';
import 'package:toilet_training/widgets/background.dart';
import 'package:toilet_training/widgets/header.dart'; // Import game Flame baru

class SceneObject {
  final dynamic id;
  final String name;
  final String imagePath;
  Offset position;
  Size size;
  bool isTarget;
  bool isFound;

  SceneObject({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.position,
    required this.size,
    this.isTarget = false,
    this.isFound = false,
  });

  factory SceneObject.fromJson(
    Map<String, dynamic> json,
    Offset defaultPosition,
    Size defaultSize,
  ) {
    return SceneObject(
      id: json['id'].toString(),
      name: json['name'],
      imagePath: json['image'],
      position: defaultPosition,
      size: defaultSize,
    );
  }
}

class LevelThreeScreen extends StatefulWidget {
  const LevelThreeScreen({super.key});

  @override
  State<LevelThreeScreen> createState() => _LevelThreeScreenState();
}

class _LevelThreeScreenState extends State<LevelThreeScreen> {
  late HiddenObjectGame _game;
  List<SceneObjectData> _currentTargets = [];
  Set<String> _currentFoundIds = {};
  bool _isLoadingGame = true; // Awalnya true sampai game selesai load

  final double sceneWidth = 800;
  final double sceneHeight = 500;
  final int numberOfTargets = 3;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _game = HiddenObjectGame(
      onTargetsUpdated: (targets, foundIds) {
        // Dipanggil oleh game ketika daftar target atau yang ditemukan berubah
        if (mounted) {
          // Pastikan widget masih ada di tree
          setState(() {
            _currentTargets = List.from(targets);
            _currentFoundIds = Set.from(foundIds);
            if (_isLoadingGame) _isLoadingGame = false; // Game sudah load
          });
        }
      },
      onAllTargetsFound: () {
        // Dipanggil oleh game ketika semua target ditemukan
        if (mounted) {
          _showSuccessDialog();
        }
      },
      onShowFeedback: (message) {
        if (mounted && message.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: Duration(seconds: 1),
              backgroundColor: Colors.orange,
            ),
          );
        }
      },
    );
    // Tidak perlu setState di sini karena GameWidget akan dibangun dengan _game ini
    // dan callback onTargetsUpdated akan menangani update UI awal.
  }

  void _resetLevel() {
    setState(() {
      _isLoadingGame = true; // Tampilkan loading saat game direset
      _currentTargets.clear();
      _currentFoundIds.clear();
    });
    _game.resetGame().then((_) {
      // Game akan memanggil onTargetsUpdated setelah reset selesai,
      // yang akan mengatur _isLoadingGame = false dan update UI.
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFFFF0E1),
          title: Center(
            child: Text(
              "Yeayy!!! Kamu berhasil menemukannya",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFD98555),
                fontSize: 20,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Selamat! kamu mendapatkan ${_currentTargets.length} ⭐",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Color(0xFFD98555)),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                alignment: WrapAlignment.center,
                children:
                    _currentTargets
                        .map(
                          (obj) => Chip(
                            label: Text(
                              obj.name,
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: _getChipColor(
                              obj.name,
                              true,
                            ), // Semua pasti sudah found
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5C9A4A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: Text(
                    "Lanjut!",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetLevel(); // Reset game untuk level berikutnya atau attempt baru
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getChipColor(String name, bool found) {
    final colors = [
      Colors.amber[600]!,
      Colors.green[600]!,
      Colors.blue[600]!,
      Colors.redAccent[400]!,
      Colors.purple[600]!,
    ];
    final hash = name.hashCode % colors.length;
    Color baseColor = colors[hash];
    return found ? baseColor : baseColor.withOpacity(0.7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        gender: 'laki-laki',
        child: Column(
          children: [
            Header(title: "level 3"),
            Text(
              _currentFoundIds.length == _currentTargets.length &&
                      _currentTargets.isNotEmpty
                  ? "Semua Benda Ditemukan!"
                  : "Temukanlah benda berikut ini!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B5A2B),
              ),
            ),
            SizedBox(height: 15),
            if (_isLoadingGame &&
                _currentTargets
                    .isEmpty) // Tampilkan loading hanya jika target belum ada
              CircularProgressIndicator()
            else if (_currentTargets.isNotEmpty)
              Wrap(
                spacing: 10.0,
                runSpacing: 8.0,
                alignment: WrapAlignment.center,
                children:
                    _currentTargets.map((obj) {
                      bool isActuallyFound = _currentFoundIds.contains(
                        obj.id.toString(),
                      );
                      return Chip(
                        label: Text(
                          obj.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: _getChipColor(
                          obj.name,
                          isActuallyFound,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.white, width: 1.5),
                        ),
                      );
                    }).toList(),
              )
            else if (!_isLoadingGame && _currentTargets.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Tidak ada target untuk ditemukan.",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            SizedBox(height: 20),
            Expanded(
              child: GameWidget(
                game: _game, // Berikan instance game ke GameWidget
                // InteractiveViewer bisa dipertimbangkan untuk ditambahkan sebagai parent dari GameWidget
                // atau fungsionalitas zoom/pan diimplementasikan dalam Flame game jika diperlukan.
              ),
            ),
          ],
        ),
      ),
    );
  }
}
