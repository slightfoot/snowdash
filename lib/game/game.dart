import 'package:snowdash/app/assets.dart';
import 'package:snowdash/engine/game.dart';
import 'package:snowdash/engine/gamepad.dart';
import 'package:snowdash/game/player.dart';
import 'package:snowdash/models/level_data.dart';

class SnowDashGame extends Game {
  SnowDashGame({
    required this.level,
    required this.images,
  }) {
    gamepad = Gamepad(0); // primary controller
    addEntity(Player());
  }

  final LevelData level;
  final ImageAssets images;
  late final Gamepad gamepad;

  @override
  void update(double deltaTime) {
    gamepad.updateState();
    super.update(deltaTime);
  }
}
