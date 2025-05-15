import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

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
      position:
          defaultPosition, 
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
  List<SceneObject> _sceneObjects = [];
  List<SceneObject> _targetObjects = [];
  final Set<String> _foundTargetIds = {};
  bool _allTargetsFound = false;
  bool _isLoading = true;

  final double sceneWidth = 800; 
  final double sceneHeight = 500; 
  final int numberOfTargets = 3;

  @override
  void initState() {
    super.initState();
    _initializeScene();
  }

  Future<void> _initializeScene() async {
    setState(() {
      _isLoading = true;
      _allTargetsFound = false;
      _foundTargetIds.clear();
      _targetObjects.clear();
      _sceneObjects.clear();
    });

    try {
      final String response = await rootBundle.loadString(
        'lib/models/static/random-things-static.json',
      );
      final List<dynamic> data = json.decode(response);

      final random = Random();
      List<SceneObject> loadedObjects = [];

      for (var itemJson in data) {
        double objWidth = 80 + random.nextDouble() * 50;
        double objHeight = 80 + random.nextDouble() * 50;

        double posX = random.nextDouble() * (sceneWidth - objWidth);
        double posY = random.nextDouble() * (sceneHeight - objHeight);

        loadedObjects.add(
          SceneObject.fromJson(
            itemJson,
            Offset(posX, posY),
            Size(objWidth, objHeight),
          ),
        );
      }

      _sceneObjects = List.from(loadedObjects);

      List<SceneObject> potentialTargets =
          loadedObjects.where((obj) {
            int? id = int.tryParse(obj.id.toString());
            return id != null && id >= 1 && id <= 9;
          }).toList();

      if (potentialTargets.isNotEmpty) {
        potentialTargets.shuffle(random);
        for (
          int i = 0;
          i < min(numberOfTargets, potentialTargets.length);
          i++
        ) {
          final targetId = potentialTargets[i].id;
          final sceneObjectTarget = _sceneObjects.firstWhere(
            (so) => so.id == targetId,
            orElse: () => potentialTargets[i],
          );

          sceneObjectTarget.isTarget = true;
          _targetObjects.add(sceneObjectTarget);
        }
      } else {
        print(
          "Tidak ada objek toilet (ID 1-9) yang ditemukan untuk dijadikan target.",
        );
      }

      _sceneObjects.shuffle(random);
    } catch (e) {
      print("Error loading or processing scene objects: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _onObjectTap(SceneObject tappedObject) {
    if (_allTargetsFound || tappedObject.isFound || _isLoading) return;

    if (!_isLoading) {
      if (tappedObject.isTarget) {
        setState(() {
          tappedObject.isFound = true;
          _foundTargetIds.add(tappedObject.id.toString());

          if (_foundTargetIds.length == _targetObjects.length) {
            _allTargetsFound = true;
            _showSuccessDialog();
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Itu bukan target, coba cari yang lain!"),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
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
                "Selamat! kamu mendapatkan ${_targetObjects.length} ⭐",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Color(0xFFD98555)),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                alignment: WrapAlignment.center,
                children:
                    _targetObjects
                        .map(
                          (obj) => Chip(
                            label: Text(
                              obj.name,
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: _getChipColor(obj.name, true),
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
                  _initializeScene();
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
      backgroundColor: const Color(0xFFFDF3E6),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  SizedBox(height: 40),
                  Text(
                    _allTargetsFound
                        ? "Semua Benda Ditemukan!"
                        : "Temukanlah benda berikut ini!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B5A2B),
                    ),
                  ),
                  SizedBox(height: 15),
                  if (_targetObjects.isNotEmpty)
                    Wrap(
                      spacing: 10.0,
                      runSpacing: 8.0,
                      alignment: WrapAlignment.center,
                      children:
                          _targetObjects.map((obj) {
                            bool isActuallyFound = _foundTargetIds.contains(
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
                                side: BorderSide(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                            );
                          }).toList(),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        "Tidak ada target untuk ditemukan.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  SizedBox(height: 20),
                  Expanded(
                    child: InteractiveViewer(
                      boundaryMargin: EdgeInsets.all(20.0),
                      minScale:
                          0.1,
                      maxScale: 3.0,
                      child: Container(
                        width: sceneWidth, 
                        height:
                            sceneHeight, 
                        child: Stack(
                          children:
                              _sceneObjects.map((obj) {
                                return Positioned(
                                  left: obj.position.dx,
                                  top: obj.position.dy,
                                  width: obj.size.width,
                                  height: obj.size.height,
                                  child: GestureDetector(
                                    onTap: () => _onObjectTap(obj),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.asset(
                                          obj.imagePath,
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (
                                                context,
                                                error,
                                                stackTrace,
                                              ) => Container(
                                                color: Colors.grey[200],
                                                child: Center(
                                                  child: Icon(
                                                    Icons.broken_image_outlined,
                                                    size: 30,
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                              ),
                                        ),
                                        if (obj.isTarget &&
                                            obj.isFound) 
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.green,
                                                width: 4,
                                              ),
                                              color: Colors.green.withOpacity(
                                                0.2,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
