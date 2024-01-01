import 'package:flutter/material.dart' show Colors;
import 'package:snowdash/game/game_entity.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

class Player extends SnowDashEntity {
  Player();

  @override
  String get id => 'player';

  var _playerColor = Colors.white;

  @override
  void init() {
    position.setValues(0.0, 0.0); // TODO: load position from level data
    velocity.setValues(0.1, 0.1);
  }

  @override
  void update(double deltaTime) {
    if (gamepad.isConnected) {
      final gamePadState = gamepad.state;
      final dv = gamePadState.direction;
      position.add(dv..multiply(velocity * deltaTime));

      // TODO: just testing gamepad input, should remove
      if (gamePadState.buttonA) {
        _playerColor = Colors.red;
      } else if (gamePadState.buttonB) {
        _playerColor = Colors.green;
      } else if (gamePadState.buttonC) {
        _playerColor = Colors.blue;
      } else if (gamePadState.buttonX) {
        _playerColor = Colors.purple;
      } else if (gamePadState.buttonY) {
        _playerColor = Colors.deepOrange;
      } else if (gamePadState.buttonZ) {
        _playerColor = Colors.yellow;
      } else {
        _playerColor = Colors.white;
      }
    }
  }

  @override
  void render(Canvas canvas, Size size) {
    canvas.drawImage(
      images.getImage(ImageAsset.dashStanding),
      Offset(position.x, position.y),
      Paint()
        ..colorFilter = ColorFilter.mode(
          _playerColor,
          BlendMode.modulate,
        ),
    );
  }
}
