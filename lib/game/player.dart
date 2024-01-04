import 'package:flutter/material.dart' show Colors;
import 'package:snowdash/game/game_entity.dart';

class Player extends SnowDashEntity {
  Player({
    required this.startPosition,
  });

  @override
  String get id => 'player';

  final Vector2 startPosition;

  var _playerColor = Colors.white;

  @override
  void init() {
    position.setFrom(startPosition); // TODO: load position from level data
    velocity.setValues(0.1, 0.1);
  }

  @override
  void update(double deltaTime) {
    final dv = input.player1Axis;
    position.add(dv..multiply(velocity * deltaTime));

    if (input.player1Action) {
      _playerColor = Colors.red;
    } else {
      _playerColor = Colors.white;
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
