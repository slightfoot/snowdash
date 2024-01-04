import 'dart:ui';

import 'package:snowdash/app/assets.dart';
import 'package:snowdash/engine/game.dart';
import 'package:snowdash/game/fireworks.dart';
import 'package:snowdash/game/player.dart';
import 'package:snowdash/models/level_data.dart';
import 'package:vector_math/vector_math.dart';

export 'dart:ui';
export 'package:flutter/material.dart' show Colors;
export 'package:vector_math/vector_math.dart' hide Colors;

class SnowDashGame extends Game {
  SnowDashGame({
    required this.level,
    required this.images,
  }) {
    //gamepad = Gamepad(0); // primary controller
    addEntity(Player(startPosition: Vector2(320/2,256/2)));
    fireworks = Fireworks();
    addEntity(fireworks);
  }

  final size = const Size(320, 256);
  final playField = Aabb2.minMax(
    Vector2(0.0, 0.0),
    Vector2(320.0, 256.0),
  );
  final LevelData level;
  final ImageAssets images;
  //late final Gamepad gamepad;

  late final Fireworks fireworks;

  @override
  void update(double deltaTime) {
    //gamepad.updateState();
    super.update(deltaTime);
  }
}
