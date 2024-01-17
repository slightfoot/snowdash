import 'package:snowdash/game/game_entity.dart';
import 'package:snowdash/models/level_data.dart';
import 'package:snowdash/util/extensions.dart';

class TileLayer extends SnowDashEntity {
  TileLayer(
    ImageAssets images,
    this.layer,
    this.tileSize,
  ) {
    tileSet = images.getImage(ImageAsset.dashTileSet);
    tileStride = tileSet.width ~/ tileSize.x;
  }

  final LevelLayer layer;
  late final Vector2 tileSize;
  late final Image tileSet;
  late final int tileStride;

  @override
  String get id => 'layer${layer.id}';

  @override
  void render(Renderer renderer) {
    final min = Vector2.zero(), max = Vector2.zero();
    Vector2.max(renderer.origin
      ..divide(tileSize)
      ..floor(), min, min);
    Vector2.min((renderer.origin + renderer.bounds.max)
      ..divide(tileSize)
      ..ceil(), layer.size, max);
    final tiles = <({int index, Aabb2 source, Aabb2 destination})>[];
    for (double row = min.y; row < max.y; row++) {
      for (double col = min.x; col < max.x; col++) {
        int tileIndex = (row * layer.width + col).floor();
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
        tiles.add((
          index: tileValue,
          source: Aabb2()
            ..min.xy = sourceTopLeft
            ..size = tileSize,
          destination: Aabb2()
            ..min.xy = destinationTopLeft
            ..size = tileSize,
        ));
      }
    }
    renderer.drawTiles(tileSet, tiles);
  }
}
