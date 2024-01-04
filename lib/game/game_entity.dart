import 'package:snowdash/app/assets.dart';
import 'package:snowdash/engine/game.dart';
import 'package:snowdash/engine/input_manager.dart';
import 'package:snowdash/game/game.dart';

export 'dart:ui';
export 'package:snowdash/app/assets.dart';
export 'package:vector_math/vector_math.dart' hide Colors;

abstract class SnowDashEntity extends Entity<SnowDashGame> {
  ImageAssets get images => game.images;

  InputManager get input => game.inputManager;
}
