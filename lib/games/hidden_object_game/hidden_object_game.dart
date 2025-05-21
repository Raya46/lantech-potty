import 'dart:convert';
import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter/services.dart' show rootBundle;
import 'package:toilet_training/models/scene_object.dart';
import 'package:toilet_training/games/hidden_object_game/scene_object_component.dart';

class HiddenObjectGame extends FlameGame {
  final int numberOfTargets = 3;
  List<SceneObjectData> allObjectsData = [];
  List<SceneObjectData> targetObjectsData = [];
  Set<String> foundTargetIds = {};
  int wrongTaps = 0; 

  final Function(List<SceneObjectData> targets, Set<String> foundIds)
  onTargetsUpdated;
  final Function(int wrongTaps)
  onAllTargetsFound; 
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
    onTargetsUpdated(targetObjectsData, foundTargetIds);
  }

  @override
  Color backgroundColor() => Colors.transparent;

  Future<void> _initializeScene() async {
    allObjectsData.clear();
    targetObjectsData.clear();
    foundTargetIds.clear();
    wrongTaps = 0; 
    children.whereType<SceneObjectComponent>().forEach(remove);

   
      final String response = await rootBundle.loadString(
        'lib/models/static/random-things-static.json',
      );
      final List<dynamic> jsonData = json.decode(response);

      List<SceneObjectData> tempLoadedData =
          jsonData
              .map((itemJson) => SceneObjectData.fromJson(itemJson))
              .toList();

      List<SceneObjectData> potentialTargets =
          tempLoadedData.where((obj) {
            int? id = int.tryParse(obj.id.toString());
            return id != null && id >= 1 && id <= 9; 
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
      } 

      allObjectsData.addAll(tempLoadedData);
      allObjectsData.shuffle(Random());

      final List<Rect> occupiedRects = [];
      const double edgePadding = 20.0; 
      const int maxPlacementAttempts = 50;
      const int maxNonTargetObjectsToPlace =
          15; 
      int placedNonTargets = 0;

      for (var targetData in targetObjectsData) {
        final component = SceneObjectComponent(targetData, gameRef: this);
        await component.onLoad();
      }

      for (var objData in allObjectsData) {
        if (objData.isTarget) continue; 
        if (placedNonTargets >= maxNonTargetObjectsToPlace) break; 

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
        } 
    } 
  }

  bool _placeComponent(
    SceneObjectComponent component,
    List<Rect> occupiedRects,
    Random random,
    double edgePadding,
    int maxPlacementAttempts,
  ) {
    if (component.width == 0 || component.height == 0) {
      return false; 
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
      ); 
      posY = max(
        edgePadding + component.height / 2,
        posY,
      ); 

      posX = min(posX, size.x - edgePadding - component.width / 2);
      posY = min(posY, size.y - edgePadding - component.height / 2);

      if (posX.isNaN || posY.isNaN) {
        attempts++;
        continue; 
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
      onTargetsUpdated(targetObjectsData, foundTargetIds);

      if (foundTargetIds.length == targetObjectsData.length &&
          targetObjectsData.isNotEmpty) {
        onAllTargetsFound(wrongTaps);
      }
    }
  }

  void onWrongObjectTapped(SceneObjectData tappedObject) {
    wrongTaps++; 
    onShowFeedback("Itu bukan target, coba cari yang lain!");
  }

  Future<void> resetGame() async {
    await _initializeScene();
    onTargetsUpdated(targetObjectsData, foundTargetIds);
  }
}