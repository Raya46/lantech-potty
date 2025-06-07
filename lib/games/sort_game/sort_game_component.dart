import 'package:flame/components.dart';
import 'package:flame/effects.dart';
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
  final ToiletSortGame gameRef;
  final double animationDelay;
  Vector2? previousPosition;

  ImageSprite({
    required Sprite? sprite,
    required this.imagePath,
    required this.imageIdentifier,
    required Vector2 centerPosition,
    required Vector2 size,
    required this.gameRef,
    this.animationDelay = 0.0,
  }) : super(sprite: sprite, position: centerPosition, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    anchor = Anchor.center;

    if (sprite != null) {
      final originalAspectRatio =
          sprite!.originalSize.x / sprite!.originalSize.y;
      final boundingBox = size.clone();

      if (originalAspectRatio > 1) {
        size.x = boundingBox.x;
        size.y = boundingBox.x / originalAspectRatio;
      } else {
        size.y = boundingBox.y;
        size.x = boundingBox.y * originalAspectRatio;
      }
    }

    scale = Vector2.zero();

    final appearSequence = SequenceEffect([
      ScaleEffect.to(
        Vector2.all(1.1),
        EffectController(duration: 0.6, curve: Curves.elasticOut),
      ),
      ScaleEffect.to(
        Vector2.all(1.0),
        EffectController(duration: 0.4, curve: Curves.easeOut),
      ),
    ]);

    if (animationDelay > 0) {
      Future.delayed(
        Duration(milliseconds: (animationDelay * 1000).round()),
        () {
          if (isMounted) {
            add(appearSequence);
          }
        },
      );
    } else {
      add(appearSequence);
    }
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    priority = 10;
    previousPosition = position.clone();
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
