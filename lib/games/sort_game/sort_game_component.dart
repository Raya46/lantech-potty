import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:toilet_training/games/sort_game/sort_game.dart';

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
