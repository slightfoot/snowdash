import 'package:snowdash/game/game_entity.dart';
import 'package:snowdash/models/level_data.dart';

class TileLayer extends SnowDashEntity {
  TileLayer({
    required ImageAssets images,
    required this.layer,
    Vector2? tileSize,
  }) {
    this.tileSize = tileSize ?? Vector2(32.0, 32.0);
    tileSet = images.getImage(ImageAsset.dashTileSet);
    tileStride = tileSet.width ~/ this.tileSize.x;
  }

  final LevelLayer layer;
  late final Vector2 tileSize;
  late final Image tileSet;
  late final int tileStride;

  @override
  String get id => 'layer${layer.id}';

  @override
  void render(Renderer renderer) {
    // TODO: optimize our tile rendering to use canvas.drawAtlas
    for (int row = 0; row < layer.height; row++) {
      for (int col = 0; col < layer.width; col++) {
        int tileIndex = row * layer.width + col;
        int tileValue = layer.data[tileIndex] - 1;
        if (tileValue < 0) {
          continue;
        }
        final sourceTopLeft = Vector2(
          (tileValue % tileStride).truncateToDouble(),
          (tileValue / tileStride).truncateToDouble(),
        )..multiply(tileSize);
        final destinationTopLeft = Vector2(
          col.toDouble(),
          row.toDouble(),
        )..multiply(tileSize);
        renderer.drawTile(
          tileSet,
          Aabb2.minMax(
            sourceTopLeft,
            sourceTopLeft + tileSize,
          ),
          Aabb2.minMax(
            destinationTopLeft,
            destinationTopLeft + tileSize,
          ),
        );
      }
    }
  }
}
