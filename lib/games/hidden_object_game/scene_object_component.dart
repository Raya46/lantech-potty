import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart'; 
import 'package:toilet_training/games/hidden_object_game/hidden_object_game.dart';
import 'package:toilet_training/models/scene_object.dart';

class SceneObjectComponent extends SpriteComponent with TapCallbacks {
  final SceneObjectData data;
  final HiddenObjectGame gameRef; 
  bool _isHighlighted = false;

  SceneObjectComponent(this.data, {required this.gameRef})
    : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    try {
      sprite = await Sprite.load(
        data.imagePath.replaceFirst('assets/images/', ''),
      );
      double baseDimension = 80 + Random().nextDouble() * 50; 
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
        size = Vector2.all(baseDimension); 
      }
    } catch (e) {
      size = Vector2.all(100); 
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (data.isFound) return;

    if (data.isTarget) {
      data.isFound = true;
      _isHighlighted = true; 
      gameRef.onTargetFound(data);
    } else {
      gameRef.onWrongObjectTapped(data);
    }
    event.handled = true;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_isHighlighted && data.isFound) {
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