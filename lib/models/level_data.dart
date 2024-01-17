import 'package:vector_math/vector_math.dart';

class LevelData {
  const LevelData({
    required this.width,
    required this.height,
    required this.backgroundColor,
    required this.layers,
    required this.tileWidth,
    required this.tileHeight,
  });

  factory LevelData.fromJson(Map<String, dynamic> json) {
    final backgroundColorHex = json['backgroundcolor'] as String?;
    final backgroundColor = Colors.black;
    if (backgroundColorHex != null) {
      Colors.fromHexString(backgroundColorHex, backgroundColor);
    }
    return LevelData(
      width: json['width'] as int,
      height: json['height'] as int,
      backgroundColor: backgroundColor,
      layers: (json['layers'] as List) //
          .cast<Map<String, dynamic>>()
          .map(LevelLayer.fromJson)
          .toList(),
      tileWidth: json['tilewidth'] as int,
      tileHeight: json['tileheight'] as int,
    );
  }

  final int width;
  final int height;
  final Vector4 backgroundColor;
  final List<LevelLayer> layers;
  final int tileWidth;
  final int tileHeight;

  int get pixelWidth => width * tileWidth;

  int get pixelHeight => height * tileHeight;

  Vector2 get tileSize {
    return Vector2(
      tileWidth.toDouble(),
      tileHeight.toDouble(),
    );
  }
}

class LevelLayer {
  LevelLayer({
    required this.id,
    required this.name,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.visible,
    required this.opacity,
    required this.data,
    required this.properties,
  });

  factory LevelLayer.fromJson(Map<String, dynamic> json) {
    return LevelLayer(
      id: json['id'] as int,
      name: json['name'] as String,
      x: json['x'] as int,
      y: json['y'] as int,
      width: json['width'] as int,
      height: json['height'] as int,
      visible: json['visible'] as bool,
      opacity: (json['opacity'] as num).toDouble(),
      data: List.unmodifiable(
        (json['data'] as List).cast(),
      ),
      properties: Map.fromEntries(
        (json['properties'] as List?)?.map(
              (el) {
                final entry = (el as Map).cast<String, dynamic>();
                return MapEntry<String, dynamic>(entry['name'], entry['value']);
              },
            ) ??
            {},
      ),
    );
  }

  final int id;
  final String name;
  final int x;
  final int y;
  final int width;
  final int height;
  final bool visible;
  final double opacity;
  final List<int> data;
  final Map<String, dynamic> properties;

  bool get foreground => properties['foreground'] ?? false;

  bool get solid => properties['solid'] ?? false;

  Vector2 get size {
    return Vector2(width.toDouble(), height.toDouble());
  }
}
