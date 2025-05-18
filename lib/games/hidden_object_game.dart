import 'dart:convert';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart'; // Untuk Size, Offset, Rect jika masih diperlukan sementara
import 'package:flutter/services.dart' show rootBundle;

// Data class untuk objek scene, terpisah dari komponen Flame
class SceneObjectData {
  final String id;
  final String name;
  final String imagePath;
  bool isTarget;
  bool isFound;

  SceneObjectData({
    required this.id,
    required this.name,
    required this.imagePath,
    this.isTarget = false,
    this.isFound = false,
  });

  factory SceneObjectData.fromJson(Map<String, dynamic> json) {
    return SceneObjectData(
      id: json['id'].toString(),
      name: json['name'] ?? 'Unknown',
      imagePath: json['image'] ?? '',
    );
  }
}

// Komponen Flame untuk merepresentasikan objek di scene
class SceneObjectComponent extends SpriteComponent with TapCallbacks {
  final SceneObjectData data;
  final HiddenObjectGame gameRef; // Referensi ke game utama
  bool _isHighlighted = false;

  SceneObjectComponent(this.data, {required this.gameRef})
    : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    try {
      sprite = await Sprite.load(
        data.imagePath.replaceFirst('assets/images/', ''),
      );
      // Ukuran bisa diatur di sini berdasarkan kebutuhan atau gambar
      // Contoh: buat semua objek memiliki lebar/tinggi dasar dan skala dari sana
      double baseDimension = 80 + Random().nextDouble() * 50; // 80-130
      if (sprite != null) {
        if (sprite!.originalSize.x >= sprite!.originalSize.y) {
          width = baseDimension;
          height =
              sprite!.originalSize.y * (baseDimension / sprite!.originalSize.x);
        } else {
          height = baseDimension;
          width =
              sprite!.originalSize.x * (baseDimension / sprite!.originalSize.y);
        }
      } else {
        size = Vector2.all(baseDimension); // Fallback jika sprite gagal dimuat
        print("Sprite gagal dimuat untuk: ${data.imagePath}");
      }
    } catch (e) {
      print("Error loading sprite for ${data.imagePath}: $e");
      size = Vector2.all(100); // Fallback size
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (data.isFound) return;

    if (data.isTarget) {
      data.isFound = true;
      _isHighlighted = true; // Untuk efek visual sementara
      gameRef.onTargetFound(data);
      // Mungkin tambahkan efek visual atau suara
      print("Target ditemukan: ${data.name}");
    } else {
      gameRef.onWrongObjectTapped(data);
      print("Salah objek: ${data.name}");
      // Mungkin berikan feedback negatif
    }
    event.handled = true;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_isHighlighted && data.isFound) {
      // Gambar lingkaran hijau sebagai highlight
      final paint =
          Paint()
            ..color = Colors.green.withOpacity(0.5)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5;
      canvas.drawCircle(
        Offset(width / 2, height / 2),
        min(width, height) / 2,
        paint,
      );
    }
  }
}

// Game utama untuk Level 3
class HiddenObjectGame extends FlameGame {
  final int numberOfTargets = 3;
  List<SceneObjectData> allObjectsData = [];
  List<SceneObjectData> targetObjectsData = [];
  Set<String> foundTargetIds = {};
  int wrongTaps = 0; // Tambahkan untuk melacak tap yang salah

  final Function(List<SceneObjectData> targets, Set<String> foundIds)
  onTargetsUpdated;
  final Function(int wrongTaps)
  onAllTargetsFound; // Modifikasi untuk mengirim wrongTaps
  final Function(String message) onShowFeedback;

  HiddenObjectGame({
    required this.onTargetsUpdated,
    required this.onAllTargetsFound,
    required this.onShowFeedback,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _initializeScene();
    // Panggil callback awal untuk UI
    onTargetsUpdated(targetObjectsData, foundTargetIds);
  }

  @override
  Color backgroundColor() => Colors.transparent;

  Future<void> _initializeScene() async {
    allObjectsData.clear();
    targetObjectsData.clear();
    foundTargetIds.clear();
    wrongTaps = 0; // Reset wrongTaps setiap game baru
    // Hapus komponen lama jika ada (untuk reset)
    children.whereType<SceneObjectComponent>().forEach(remove);

    try {
      final String response = await rootBundle.loadString(
        'lib/models/static/random-things-static.json',
      );
      final List<dynamic> jsonData = json.decode(response);

      List<SceneObjectData> tempLoadedData =
          jsonData
              .map((itemJson) => SceneObjectData.fromJson(itemJson))
              .toList();

      // Pilih target
      List<SceneObjectData> potentialTargets =
          tempLoadedData.where((obj) {
            int? id = int.tryParse(obj.id.toString());
            return id != null && id >= 1 && id <= 9; // Objek toilet
          }).toList();

      if (potentialTargets.isNotEmpty) {
        potentialTargets.shuffle();
        for (
          int i = 0;
          i < min(numberOfTargets, potentialTargets.length);
          i++
        ) {
          potentialTargets[i].isTarget = true;
          targetObjectsData.add(potentialTargets[i]);
        }
      } else {
        print("Tidak ada objek toilet (ID 1-9) untuk dijadikan target.");
        // Handle jika tidak ada target
      }

      allObjectsData.addAll(tempLoadedData);
      // Acak semua objek agar urutan penempatan bervariasi, tapi target tetap target.
      allObjectsData.shuffle(Random());

      // Logika penempatan objek
      final List<Rect> occupiedRects = [];
      const double edgePadding = 20.0; // Padding dari tepi layar game
      const int maxPlacementAttempts = 50;
      const int maxNonTargetObjectsToPlace =
          15; // Batasi jumlah objek non-target
      int placedNonTargets = 0;

      // Prioritaskan penempatan target
      for (var targetData in targetObjectsData) {
        final component = SceneObjectComponent(targetData, gameRef: this);
        // Pastikan data ini juga ada di allObjectsData untuk logika penempatan umum jika diperlukan,
        // atau tangani penempatannya secara terpisah di sini.
        // Untuk sekarang, kita asumsikan targetData adalah referensi ke objek di allObjectsData yang sudah ditandai.

        await component.onLoad();
        if (!_placeComponent(
          component,
          occupiedRects,
          Random(),
          edgePadding,
          maxPlacementAttempts,
        )) {
          print(
            "### KRITIS: Gagal menempatkan TARGET ${targetData.name} setelah $maxPlacementAttempts percobaan! ###",
          );
          // Anda mungkin ingin strategi fallback di sini, misal menempatkan di tengah dengan paksa
          // atau mengurangi jumlah target jika penempatan gagal.
        }
      }

      // Kemudian tempatkan objek non-target hingga batas tertentu
      for (var objData in allObjectsData) {
        if (objData.isTarget)
          continue; // Lewati target karena sudah ditempatkan (atau coba ditempatkan)
        if (placedNonTargets >= maxNonTargetObjectsToPlace)
          break; // Batasi jumlah non-target

        final component = SceneObjectComponent(objData, gameRef: this);
        await component.onLoad();

        if (_placeComponent(
          component,
          occupiedRects,
          Random(),
          edgePadding,
          maxPlacementAttempts,
        )) {
          placedNonTargets++;
        } else {
          print(
            "Info: Gagal menempatkan objek non-target ${objData.name} setelah $maxPlacementAttempts percobaan.",
          );
        }
      }
    } catch (e) {
      print("Error loading/processing scene objects in Flame: $e");
    }
  }

  // Helper function untuk menempatkan komponen
  bool _placeComponent(
    SceneObjectComponent component,
    List<Rect> occupiedRects,
    Random random,
    double edgePadding,
    int maxPlacementAttempts,
  ) {
    if (component.width == 0 || component.height == 0) {
      print(
        "Komponen ${component.data.name} memiliki ukuran nol, tidak dapat ditempatkan.",
      );
      return false; // Tidak bisa menempatkan komponen dengan ukuran nol
    }
    bool positionFound = false;
    int attempts = 0;

    do {
      double posX =
          edgePadding +
          random.nextDouble() * (size.x - component.width - 2 * edgePadding);
      double posY =
          edgePadding +
          random.nextDouble() * (size.y - component.height - 2 * edgePadding);

      posX = max(
        edgePadding + component.width / 2,
        posX,
      ); // Pastikan di dalam batas kiri
      posY = max(
        edgePadding + component.height / 2,
        posY,
      ); // Pastikan di dalam batas atas

      // Pastikan di dalam batas kanan dan bawah
      posX = min(posX, size.x - edgePadding - component.width / 2);
      posY = min(posY, size.y - edgePadding - component.height / 2);

      // Cek apakah posisi valid (tidak NaN)
      if (posX.isNaN || posY.isNaN) {
        print(
          "Posisi NaN untuk ${component.data.name}. Ukuran game: $size, Ukuran komponen: ${component.size}",
        );
        attempts++;
        continue; // Coba lagi jika posisi tidak valid
      }

      component.position = Vector2(posX, posY);

      final componentRect = Rect.fromCenter(
        center: Offset(component.position.x, component.position.y),
        width: component.width,
        height: component.height,
      );

      bool overlaps = false;
      for (Rect occupied in occupiedRects) {
        if (componentRect.overlaps(occupied.inflate(5))) {
          overlaps = true;
          break;
        }
      }

      if (!overlaps) {
        positionFound = true;
        occupiedRects.add(componentRect);
        add(component);
        return true;
      } else {
        attempts++;
      }
    } while (!positionFound && attempts < maxPlacementAttempts);
    return false;
  }

  void onTargetFound(SceneObjectData foundObject) {
    if (foundTargetIds.add(foundObject.id)) {
      // Panggil callback untuk update UI Flutter
      onTargetsUpdated(targetObjectsData, foundTargetIds);

      if (foundTargetIds.length == targetObjectsData.length &&
          targetObjectsData.isNotEmpty) {
        print("Semua target ditemukan! Kesalahan: $wrongTaps");
        // Panggil callback untuk UI Flutter
        onAllTargetsFound(wrongTaps);
      }
    }
  }

  void onWrongObjectTapped(SceneObjectData tappedObject) {
    wrongTaps++; // Increment kesalahan
    onShowFeedback("Itu bukan target, coba cari yang lain!");
    print("Salah tap. Total kesalahan: $wrongTaps");
  }

  Future<void> resetGame() async {
    await _initializeScene();
    onTargetsUpdated(targetObjectsData, foundTargetIds);
  }
}
