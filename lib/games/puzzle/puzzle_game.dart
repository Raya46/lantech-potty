import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:toilet_training/models/puzzle_item.dart';
import 'package:toilet_training/models/piece_shape.dart';

class PuzzleGame extends FlameGame with PanDetector, HasGameReference {
  late List<PuzzleItem> _puzzleItems;
  PuzzleItem? _selectedItem;
  List<PuzzlePieceComponent> _pieces = [];
  PuzzleBoardComponent? _board;
  ui.Image? _fullUiImage;

  static const int gridSize = 2;
  double pieceCoreSize = 0;
  late double tabSize;
  Vector2 gameSize = Vector2.zero();
  double _cumulativeAnimationDelayMs = 0.0;
  final double _pieceDelayIncrementMs = 150.0;

  final VoidCallback? onPuzzleSolved;

  List<List<PieceShape>> _pieceShapes = [];

  PuzzleGame({this.onPuzzleSolved});

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    gameSize = size;
    final double referenceDimension = math.min(gameSize.x, gameSize.y);
    pieceCoreSize = (referenceDimension * 0.5) / gridSize;
    tabSize = pieceCoreSize * 0.25;
    _cumulativeAnimationDelayMs = 0.0;

    _generatePieceShapes();

    await _loadPuzzleItems();
    _selectRandomItem();
    if (_selectedItem != null) {
      await _loadUiImage(_selectedItem!.image);
      if (_fullUiImage != null) {
        _createPuzzlePieces();
        _createBoard();
      }
    }
  }

  void _generatePieceShapes() {
    _pieceShapes = List.generate(
      gridSize,
      (r) => List.generate(gridSize, (c) => PieceShape()),
    );
    final random = math.Random();

    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (r < gridSize - 1) {
          int tabType = random.nextBool() ? 1 : -1;
          _pieceShapes[r][c].bottomTab = tabType;
          _pieceShapes[r + 1][c].topTab = -tabType;
        }
        if (c < gridSize - 1) {
          int tabType = random.nextBool() ? 1 : -1;
          _pieceShapes[r][c].rightTab = tabType;
          _pieceShapes[r][c + 1].leftTab = -tabType;
        }
      }
    }
  }

  Future<void> _loadUiImage(String imagePath) async {
    final ByteData data = await rootBundle.load(imagePath);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    _fullUiImage = frameInfo.image;
  }

  Future<void> _loadPuzzleItems() async {
    final String response = await rootBundle.loadString(
      'lib/models/static/bathroom-data-static.json',
    );
    final List<dynamic> data = json.decode(response) as List<dynamic>;
    _puzzleItems =
        data
            .map((item) => PuzzleItem.fromJson(item as Map<String, dynamic>))
            .toList();
  }

  void _selectRandomItem() {
    if (_puzzleItems.isNotEmpty) {
      final random = math.Random();
      _selectedItem = _puzzleItems[random.nextInt(_puzzleItems.length)];
    }
  }

  void _createPuzzlePieces() {
    if (_fullUiImage == null || _selectedItem == null) return;

    final imageWidth = _fullUiImage!.width.toDouble();
    final imageHeight = _fullUiImage!.height.toDouble();
    final singlePieceImageWidth = imageWidth / gridSize;
    final singlePieceImageHeight = imageHeight / gridSize;

    _pieces.clear();
    _cumulativeAnimationDelayMs = 0.0;

    final double boardMarginX = gameSize.x * 0.1;
    final double boardMarginY = gameSize.y * 0.1;

    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        final currentShape = _pieceShapes[r][c];

        final coreImageRect = Rect.fromLTWH(
          c * singlePieceImageWidth,
          r * singlePieceImageHeight,
          singlePieceImageWidth,
          singlePieceImageHeight,
        );

        final piece = PuzzlePieceComponent(
          fullImage: _fullUiImage!,
          shape: currentShape,
          coreImageRect: coreImageRect,
          corePieceSize: pieceCoreSize,
          tabSize: tabSize,
          correctGridPosition: Vector2(c.toDouble(), r.toDouble()),
          boardTopLeft: Vector2(boardMarginX, boardMarginY),
          animationDelay: Duration(
            milliseconds: _cumulativeAnimationDelayMs.toInt(),
          ),
        );
        _cumulativeAnimationDelayMs += _pieceDelayIncrementMs;

        _pieces.add(piece);
      }
    }

    final random = math.Random();
    _pieces.shuffle(random);

    final double pieceLayoutSpacing = 5.0;
    final double areaMargin = 20.0;
    final double boardDimension =
        pieceCoreSize * gridSize + (gridSize - 1) * tabSize * 0.5;

    double initialPiecesAreaStartX;
    double initialPiecesAreaStartY;

    if (gameSize.x > gameSize.y) {
      initialPiecesAreaStartX = boardMarginX + boardDimension + areaMargin;
      initialPiecesAreaStartY = boardMarginY;
    } else {
      initialPiecesAreaStartX = boardMarginX;
      initialPiecesAreaStartY = boardMarginY + boardDimension + areaMargin;
    }

    for (int i = 0; i < _pieces.length; i++) {
      final piece = _pieces[i];
      final int col = i % gridSize;
      final int row = i ~/ gridSize;

      double xPos =
          initialPiecesAreaStartX +
          col * (pieceCoreSize + tabSize + pieceLayoutSpacing);
      double yPos =
          initialPiecesAreaStartY +
          row * (pieceCoreSize + tabSize + pieceLayoutSpacing);

      piece.position = Vector2(xPos, yPos);
      piece.initialPosition = piece.position.clone();
      add(piece);
    }
  }

  void _createBoard() {
    final double boardMarginX = gameSize.x * 0.1;
    final double boardMarginY = gameSize.y * 0.1;
    _board = PuzzleBoardComponent(
      position: Vector2(boardMarginX, boardMarginY),
      size: Vector2.all(pieceCoreSize * gridSize),
      pieceSize: pieceCoreSize,
      gridSize: gridSize,
    );
    add(_board!);
  }

  void checkWinCondition() {
    if (_pieces.every((piece) => piece.isCorrectlyPlaced)) {
      Future.delayed(const Duration(seconds: 1), () {
        onPuzzleSolved?.call();
        resetGame();
      });
    }
  }

  void resetGame() {
    for (var piece in _pieces) {
      remove(piece);
    }
    if (_board != null) {
      remove(_board!);
    }
    _pieces.clear();
    _board = null;
    _fullUiImage = null;
    _cumulativeAnimationDelayMs = 0.0;

    _selectRandomItem();
    if (_selectedItem != null) {
      _loadUiImage(_selectedItem!.image).then((_) {
        if (_fullUiImage != null) {
          _createPuzzlePieces();
          _createBoard();
        }
      });
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}

class PuzzleBoardComponent extends PositionComponent {
  final double pieceSize;
  final int gridSize;

  PuzzleBoardComponent({
    required Vector2 position,
    required Vector2 size,
    required this.pieceSize,
    required this.gridSize,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        canvas.drawRect(
          Rect.fromLTWH(j * pieceSize, i * pieceSize, pieceSize, pieceSize),
          paint,
        );
      }
    }
  }
}

class PuzzlePieceComponent extends PositionComponent with DragCallbacks {
  final ui.Image fullImage;
  final PieceShape shape;
  final Rect coreImageRect;
  final double corePieceSize;
  final double tabSize;
  final Vector2 correctGridPosition;
  final Vector2 boardTopLeft;
  final Duration animationDelay;

  late Vector2 initialPosition;
  bool isDragging = false;
  bool isCorrectlyPlaced = false;
  late Path _piecePath;
  late Rect _boundingRect;

  Vector2 get correctPositionOnBoard {
    return Vector2(
      boardTopLeft.x + correctGridPosition.x * corePieceSize,
      boardTopLeft.y + correctGridPosition.y * corePieceSize,
    );
  }

  PuzzlePieceComponent({
    required this.fullImage,
    required this.shape,
    required this.coreImageRect,
    required this.corePieceSize,
    required this.tabSize,
    required this.correctGridPosition,
    required this.boardTopLeft,
    this.animationDelay = Duration.zero,
  }) {
    _buildPathAndBoundingBox();
    size = Vector2(_boundingRect.width, _boundingRect.height);
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    this.scale = Vector2.zero();

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

    if (animationDelay > Duration.zero) {
      Future.delayed(animationDelay, () {
        if (isMounted) {
          add(appearSequence);
        }
      });
    } else {
      add(appearSequence);
    }
  }

  void _buildPathAndBoundingBox() {
    _piecePath = Path();
    double leftBound = 0;
    double topBound = 0;
    double rightBound = corePieceSize;
    double bottomBound = corePieceSize;

    double xOffset = (shape.leftTab != 0) ? tabSize : 0;
    double yOffset = (shape.topTab != 0) ? tabSize : 0;

    _piecePath.moveTo(xOffset, yOffset);

    if (shape.topTab == 0) {
      _piecePath.lineTo(xOffset + corePieceSize, yOffset);
    } else {
      _piecePath.lineTo(xOffset + corePieceSize / 2 - tabSize / 2, yOffset);
      _piecePath.relativeQuadraticBezierTo(
        tabSize / 4,
        -tabSize * shape.topTab,
        tabSize / 2,
        -tabSize * shape.topTab,
      );
      _piecePath.relativeQuadraticBezierTo(
        tabSize / 4,
        0,
        tabSize / 2,
        tabSize * shape.topTab,
      );
      _piecePath.lineTo(xOffset + corePieceSize, yOffset);
      if (shape.topTab != 0) topBound -= tabSize;
    }

    if (shape.rightTab == 0) {
      _piecePath.lineTo(xOffset + corePieceSize, yOffset + corePieceSize);
    } else {
      _piecePath.lineTo(
        xOffset + corePieceSize,
        yOffset + corePieceSize / 2 - tabSize / 2,
      );
      _piecePath.relativeQuadraticBezierTo(
        tabSize * shape.rightTab,
        tabSize / 4,
        tabSize * shape.rightTab,
        tabSize / 2,
      );
      _piecePath.relativeQuadraticBezierTo(
        0,
        tabSize / 4,
        -tabSize * shape.rightTab,
        tabSize / 2,
      );
      _piecePath.lineTo(xOffset + corePieceSize, yOffset + corePieceSize);
      if (shape.rightTab != 0) rightBound += tabSize;
    }

    if (shape.bottomTab == 0) {
      _piecePath.lineTo(xOffset, yOffset + corePieceSize);
    } else {
      _piecePath.lineTo(
        xOffset + corePieceSize / 2 + tabSize / 2,
        yOffset + corePieceSize,
      );
      _piecePath.relativeQuadraticBezierTo(
        -tabSize / 4,
        tabSize * shape.bottomTab,
        -tabSize / 2,
        tabSize * shape.bottomTab,
      );
      _piecePath.relativeQuadraticBezierTo(
        -tabSize / 4,
        0,
        -tabSize / 2,
        -tabSize * shape.bottomTab,
      );
      _piecePath.lineTo(xOffset, yOffset + corePieceSize);
      if (shape.bottomTab != 0) bottomBound += tabSize;
    }

    if (shape.leftTab == 0) {
      _piecePath.close();
    } else {
      _piecePath.lineTo(xOffset, yOffset + corePieceSize / 2 + tabSize / 2);
      _piecePath.relativeQuadraticBezierTo(
        -tabSize * shape.leftTab,
        -tabSize / 4,
        -tabSize * shape.leftTab,
        -tabSize / 2,
      );
      _piecePath.relativeQuadraticBezierTo(
        0,
        -tabSize / 4,
        tabSize * shape.leftTab,
        -tabSize / 2,
      );
      _piecePath.close();
      if (shape.leftTab != 0) leftBound -= tabSize;
    }

    _boundingRect = Rect.fromLTRB(leftBound, topBound, rightBound, bottomBound);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final backgroundPaint = Paint()..color = Colors.white;
    canvas.drawPath(_piecePath, backgroundPaint);

    canvas.save();
    canvas.clipPath(_piecePath);

    double srcRectX =
        coreImageRect.left -
        (shape.leftTab != 0
            ? (tabSize / corePieceSize * coreImageRect.width)
            : 0);
    double srcRectY =
        coreImageRect.top -
        (shape.topTab != 0
            ? (tabSize / corePieceSize * coreImageRect.height)
            : 0);
    double srcRectWidth =
        coreImageRect.width +
        (shape.leftTab != 0
            ? (tabSize / corePieceSize * coreImageRect.width)
            : 0) +
        (shape.rightTab != 0
            ? (tabSize / corePieceSize * coreImageRect.width)
            : 0);
    double srcRectHeight =
        coreImageRect.height +
        (shape.topTab != 0
            ? (tabSize / corePieceSize * coreImageRect.height)
            : 0) +
        (shape.bottomTab != 0
            ? (tabSize / corePieceSize * coreImageRect.height)
            : 0);

    Rect actualSrcRect = Rect.fromLTWH(
      srcRectX,
      srcRectY,
      srcRectWidth,
      srcRectHeight,
    );

    Rect destRect = Rect.fromLTWH(0, 0, size.x, size.y);

    canvas.drawImageRect(fullImage, actualSrcRect, destRect, Paint());
    canvas.restore();

    final borderPaint =
        Paint()
          ..color = isCorrectlyPlaced ? Colors.green : Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = isCorrectlyPlaced ? 3 : 1.5;
    canvas.drawPath(_piecePath, borderPaint);
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (isCorrectlyPlaced) return;
    super.onDragStart(event);
    isDragging = true;
    priority = 10;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!isDragging || isCorrectlyPlaced) return;
    position += event.localDelta;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (!isDragging) return;
    isDragging = false;
    priority = 0;

    final game = parent! as PuzzleGame;

    final targetBoardPos = correctPositionOnBoard;

    double currentCoreX = position.x + ((shape.leftTab != 0) ? tabSize : 0);
    double currentCoreY = position.y + ((shape.topTab != 0) ? tabSize : 0);
    Vector2 currentCorePosition = Vector2(currentCoreX, currentCoreY);

    final distanceToCorrect = currentCorePosition.distanceTo(targetBoardPos);
    final snapThreshold = corePieceSize * 0.4;

    if (distanceToCorrect < snapThreshold) {
      position.x = targetBoardPos.x - ((shape.leftTab != 0) ? tabSize : 0);
      position.y = targetBoardPos.y - ((shape.topTab != 0) ? tabSize : 0);
      isCorrectlyPlaced = true;
      game.checkWinCondition();
    } else {
      position = initialPosition.clone();
    }
  }
}
