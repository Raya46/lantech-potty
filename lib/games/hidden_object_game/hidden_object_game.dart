import 'dart:convert';
import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart'; // Untuk Size, Offset, Rect jika masih diperlukan sementara
import 'package:flutter/services.dart' show rootBundle;
import 'package:toilet_training/models/scene_object.dart';
import 'package:toilet_training/games/hidden_object_game/scene_object_component.dart';

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
          // Anda mungkin ingin strategi fallback di sini, misal menempatkan di tengah dengan paksa
          // atau mengurangi jumlah target jika penempatan gagal.
        }
      }

      // Kemudian tempatkan objek non-target hingga batas tertentu
      for (var objData in allObjectsData) {
        if (objData.isTarget) continue; // Lewati target karena sudah ditempatkan (atau coba ditempatkan)
        if (placedNonTargets >= maxNonTargetObjectsToPlace) break; // Batasi jumlah non-target

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
        } else {}
      }
    } catch (e) {
      print(e);
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
        // Panggil callback untuk UI Flutter
        onAllTargetsFound(wrongTaps);
      }
    }
  }

  void onWrongObjectTapped(SceneObjectData tappedObject) {
    wrongTaps++; // Increment kesalahan
    onShowFeedback("Itu bukan target, coba cari yang lain!");
  }

  Future<void> resetGame() async {
    await _initializeScene();
    onTargetsUpdated(targetObjectsData, foundTargetIds);
  }
}
