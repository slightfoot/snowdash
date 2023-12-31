import 'dart:ui';

class LevelData {
  const LevelData({
    required this.tileWidth,
    required this.tileHeight,
    required this.backgroundColor,
    required this.layers,
  });

  factory LevelData.fromJson(Map<String, dynamic> json) {
    final backgroundColor = (json['backgroundcolor'] as String).substring(1);
    return LevelData(
      tileWidth: json['tilewidth'] as int,
      tileHeight: json['tileheight'] as int,
      backgroundColor: Color(
        0xFF000000 | int.parse(backgroundColor, radix: 16),
      ),
      layers: (json['layers'] as List) //
          .cast<Map<String, dynamic>>()
          .map(LevelLayer.fromJson)
          .toList(),
    );
  }

  final int tileWidth;
  final int tileHeight;
  final Color backgroundColor;
  final List<LevelLayer> layers;
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
        (json['properties'] as List).map(
          (el) {
            final entry = (el as Map).cast<String, dynamic>();
            return MapEntry<String, dynamic>(entry['name'], entry['value']);
          },
        ),
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
}
