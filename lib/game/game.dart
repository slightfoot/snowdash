import 'dart:ui';

import 'package:snowdash/app/assets.dart';
import 'package:snowdash/engine/game.dart';
import 'package:snowdash/game/background.dart';
import 'package:snowdash/game/camera.dart';
import 'package:snowdash/game/fireworks.dart';
import 'package:snowdash/game/player.dart';
import 'package:snowdash/game/tile_layer.dart';
import 'package:snowdash/models/level_data.dart';
import 'package:vector_math/vector_math.dart';

export 'dart:ui';
export 'package:vector_math/vector_math.dart';

class SnowDashGame extends Game {
  SnowDashGame({
    required this.level,
    required this.images,
  }) {
    //gamepad = Gamepad(0); // primary controller

    addEntity(Background(level));

    // Add background layers
    for (final layer in level.layers.where(
      (layer) => !layer.foreground && layer.visible,
    )) {
      addEntity(
        TileLayer(images, layer, level.tileSize),
      );
    }

    // Add entities that should appear between foreground and background
    addEntity(player);
    addEntity(fireworks);

    // Add foreground layers
    for (final layer in level.layers.where(
      (layer) => layer.foreground && layer.visible,
    )) {
      addEntity(
        TileLayer(images, layer, level.tileSize),
      );
    }

    addEntity(camera);
  }

  static const size = Size(320, 256);

  final camera = Camera();
  final player = Player(
    startPosition: Vector2(size.width / 2, size.height / 2),
  );
  final fireworks = Fireworks();

  final playField = Aabb2.minMax(
    Vector2(0.0, 0.0),
    Vector2(size.width, size.height),
  );

  late final levelBox = Aabb2.minMax(
    Vector2(0.0, 0.0),
    Vector2(
      level.pixelWidth.toDouble(),
      level.pixelHeight.toDouble(),
    ),
  );

  //late final Gamepad gamepad;
  final LevelData level;
  final ImageAssets images;

  @override
  void update(double deltaTime) {
    //gamepad.updateState();
    super.update(deltaTime);
  }
}
