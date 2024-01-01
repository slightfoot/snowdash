import 'dart:ui';

import 'package:snowdash/app/assets.dart';
import 'package:snowdash/game/game.dart';
import 'package:snowdash/models/level_data.dart';

class Renderer {
  Renderer({
    required this.level,
    required this.images,
  }) {
    tileSize = const Size(32, 32);
    tileSet = images.getImage(ImageAsset.dashTileSet);
    tileStride = tileSet.width ~/ tileSize.width;
  }

  final LevelData level;
  final ImageAssets images;

  late final Size tileSize;
  late final Image tileSet;
  late final int tileStride;

  void render(Canvas canvas, Size size, SnowDashGame game) {
    final rect = Offset.zero & size;

    // Draw Background
    canvas.drawRect(rect, Paint()..color = level.backgroundColor);

    // Draw Background Layers
    for (final layer in level.layers.where(
      (layer) => !layer.foreground && layer.visible,
    )) {
      renderLayer(canvas, size, layer);
    }

    // Draw Player and game entity
    game.render(canvas, size);

    // Draw Foreground Layers
    for (final layer in level.layers.where(
      (layer) => layer.foreground && layer.visible,
    )) {
      renderLayer(canvas, size, layer);
    }
  }

  void renderLayer(Canvas canvas, Size size, LevelLayer layer) {
    // TODO: optimize our tile rendering to use canvas.drawAtlas
    final tilePaint = Paint()
      ..isAntiAlias = false
      ..filterQuality = FilterQuality.none;
    for (int row = 0; row < layer.height; row++) {
      for (int col = 0; col < layer.width; col++) {
        int tileIndex = row * layer.width + col;
        int tileValue = layer.data[tileIndex] - 1;
        if (tileValue < 0) {
          continue;
        }
        final srcOffset = Offset(
          (tileValue % tileStride).truncateToDouble() * tileSize.width,
          (tileValue / tileStride).truncateToDouble() * tileSize.height,
        );
        final dstOffset = Offset(
          col * tileSize.width,
          row * tileSize.height,
        );
        canvas.drawImageRect(
          tileSet,
          srcOffset & tileSize,
          dstOffset & tileSize,
          tilePaint,
        );
      }
    }
  }
}
