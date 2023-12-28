import 'package:flutter/cupertino.dart';
import 'package:snowdash/game/gamepad.dart';
import 'package:snowdash/models/level_data.dart';
import 'package:vector_math/vector_math.dart';

class SnowDashGame extends ChangeNotifier {
  SnowDashGame({
    required this.levelData,
  });

  final LevelData levelData;

  final gamepad = Gamepad(0); // primary controller

  var pos = Vector2.zero();
  var vel = Vector2(0.1, 0.1);

  void init() {
    //
  }

  @override
  void dispose() {
    //
    super.dispose();
  }

  void tick(double deltaTime) {
    gamepad.updateState();
    if (gamepad.isConnected) {
      final dv = gamepad.state.direction;
      pos += dv..multiply(vel * deltaTime);
    }
    notifyListeners();
  }
}
