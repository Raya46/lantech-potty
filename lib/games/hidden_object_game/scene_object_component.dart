import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart'; // Untuk Size, Offset, Rect jika masih diperlukan sementara
import 'package:toilet_training/games/hidden_object_game/hidden_object_game.dart';
import 'package:toilet_training/models/scene_object.dart';

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
      }
    } catch (e) {
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
    } else {
      gameRef.onWrongObjectTapped(data);
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