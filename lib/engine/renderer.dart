import 'package:flutter/rendering.dart' show Alignment;
import 'package:snowdash/app/assets.dart';
import 'package:snowdash/game/game.dart';
import 'package:snowdash/game/player.dart';
import 'package:snowdash/models/level_data.dart';
import 'package:snowdash/util/extensions.dart';

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

    void drawBox(Aabb2 box, Color color) {
      canvas.drawRect(
        box.toRect(),
        Paint()
          ..color = color
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke,
      );
    }

    final player = game.findEntityById<Player>('player')!;

    final windowBox = Aabb2.minMax(
      Vector2.zero(),
      Vector2(size.width, size.height),
    );

    final levelBox = Aabb2.minMax(
      Vector2.zero(),
      Vector2(
        game.level.pixelWidth.toDouble(),
        game.level.pixelHeight.toDouble(),
      ),
    );

    // Draw Background
    canvas.drawRect(rect, Paint()..color = level.backgroundColor);

    drawBox(windowBox, Colors.cyanAccent);

    final playerCenterOffset = Vector2(
      player.position.x - (size.width / 2),
      player.position.y - (size.height / 2),
    );

    Alignment.center.inscribe(size, rect);

    drawBox(levelBox, Colors.red);

    // Draw Background Layers
    for (final layer in level.layers.where(
      (layer) => !layer.foreground && layer.visible,
    )) {
      renderLayer(playerCenterOffset, canvas, size, layer);
    }

    // Draw Player and game entity
    game.render(canvas, size);

    // Draw Foreground Layers
    for (final layer in level.layers.where(
      (layer) => layer.foreground && layer.visible,
    )) {
      renderLayer(playerCenterOffset, canvas, size, layer);
    }
  }

  void renderLayer(Vector2 offset, Canvas canvas, Size size, LevelLayer layer) {
    canvas.save();
    canvas.translate(-offset.x, -offset.y);
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
    canvas.restore();
  }
}
