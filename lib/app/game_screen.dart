import 'package:flutter/material.dart';
import 'package:snowdash/app/assets.dart';
import 'package:snowdash/game/game.dart';
import 'package:snowdash/models/level_data.dart';

class GameScreen extends StatefulWidget {
  const GameScreen(this.images, this.levelData, {super.key});

  final ImageAssets images;
  final LevelData levelData;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final SnowDashGame game;

  @override
  void initState() {
    super.initState();
    game = SnowDashGame(
      levelData: widget.levelData,
    );
    game.init();
  }

  @override
  void dispose() {
    game.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Material(
        color: Colors.white,
        child: FittedBox(
          fit: BoxFit.contain,
          child: CustomPaint(
            painter: GamePainter(
              images: widget.images,
              levelData: widget.levelData,
            ),
            size: const Size(320, 256),
          ),
        ),
      ),
    );
  }
}

class GamePainter extends CustomPainter {
  GamePainter({
    required this.images,
    required this.levelData,
    super.repaint,
  });

  final ImageAssets images;
  final LevelData levelData;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Draw Background
    canvas.drawRect(rect, Paint()..color = Colors.black);
    final pos = Alignment.center.inscribe(
      const Size(16, 16),
      rect,
    );

    final tilePaint = Paint();
    final tileSize = Size(32, 32);
    final tileSet = images.getImage(ImageAsset.dashTileSet);
    final tileStride = (tileSet.width / tileSize.width).ceilToDouble();
    print('stride ${tileStride}');
    for (int layerIndex = 0; layerIndex < levelData.layers.length; layerIndex++) {
      final layer = levelData.layers[layerIndex];
      if (layer.id != 1) {
        continue;
      }
      print('layer ${layer.width} x ${layer.height}');
      for (int row = 0; row < layer.height; row++) {
        for (int col = 0; col < layer.width; col++) {
          int tileIndex = row * layer.width + col;
          int tileValue = layer.data[tileIndex];
          if (tileValue == 0) {
            continue;
          }
          print('$tileIndex: $tileValue');
          final srcOffset = Offset(
            (tileValue) % tileStride,
            (tileValue) / tileStride,
          );
          canvas.drawImageRect(
            tileSet,
            srcOffset & tileSize,
            Offset(col * 32, row * 32) & tileSize,
            tilePaint,
          );
        }
      }
    }

    // TODO: Draw Level Layer 0

    // Draw player
    canvas.drawImage(
      images.getImage(ImageAsset.dashStanding),
      pos.topLeft,
      Paint(),
    );

    // TODO: Draw Level Layer 1

    //
    // canvas.drawAtlas(
    //   atlas,
    //   transforms,
    //   rects,
    //   colors,
    //   blendMode,
    //   cullRect,
    //   paint,
    // );
  }

  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) {
    return images != oldDelegate.images;
  }
}
