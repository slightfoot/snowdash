import 'package:flutter/material.dart' show ChangeNotifier, Color, Colors;
import 'package:snowdash/engine/gamepad.dart';
import 'package:snowdash/models/level_data.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

class SnowDashGame extends ChangeNotifier {
  SnowDashGame({
    required this.levelData,
  });

  final LevelData levelData;

  final gamepad = Gamepad(0); // primary controller

  var pos = Vector2.zero();
  var vel = Vector2(0.1, 0.1);
  Color playerColor = Colors.white;

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
      final gamePadState = gamepad.state;
      final dv = gamePadState.direction;
      pos += dv..multiply(vel * deltaTime);

      if (gamePadState.buttonA) {
        playerColor = Colors.red;
      } else if (gamePadState.buttonB) {
        playerColor = Colors.green;
      } else if (gamePadState.buttonC) {
        playerColor = Colors.blue;
      } else if (gamePadState.buttonX) {
        playerColor = Colors.purple;
      } else if (gamePadState.buttonY) {
        playerColor = Colors.deepOrange;
      } else if (gamePadState.buttonZ) {
        playerColor = Colors.yellow;
      } else {
        playerColor = Colors.white;
      }
    }

    notifyListeners();
  }
}
