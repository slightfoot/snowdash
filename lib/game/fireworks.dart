import 'dart:math';

import 'package:flutter/material.dart' as material show Colors;
import 'package:snowdash/game/game_entity.dart';
import 'package:snowdash/util/extensions.dart';

class Fireworks extends SnowDashEntity {
  Fireworks();

  @override
  String get id => 'fireworks';

  final _random = Random();
  final _particles = <_Particle>[];

  @override
  void init() {
    // TODO: implement init
  }

  void addFirework() {
    if(isNotAttached) {
      return;
    }
    final randomColor = material.Colors.primaries[//
            _random.nextInt(material.Colors.primaries.length)];
    _particles.add(
      _Particle(
        position: Vector2(
          _random.nextDouble() * game.playField.max.x,
          _random.nextDouble() * game.playField.max.y,
        ),
        velocity: Vector2(
          cos(pi * _random.nextDouble()) * 0.03,
          sin(pi * _random.nextDouble()) * 0.06,
        ),
        color: randomColor.toVector4(),
      )..addForce(Vector2(0.0, 0.00001)),
    );
  }

  @override
  void update(double deltaTime) {
    for (final p in List.of(_particles)) {
      p.velocity.add(p.acceleration * deltaTime);
      p.position.add(p.velocity * deltaTime);
      if(!game.playField.containsVector2(p.position)){
        _particles.remove(p);
      }
    }
  }

  @override
  void render(Renderer renderer) {
    for (final p in List.of(_particles)) {
      renderer.drawCircle(
        p.position,
        4.0,
        p.color
      );
    }
  }
}

class _Particle {
  _Particle({
    Vector2? position,
    Vector2? velocity,
    Vector2? acceleration,
    Vector4? color,
  }) {
    this.position = position ?? Vector2.zero();
    this.velocity = velocity ?? Vector2.zero();
    this.acceleration = acceleration ?? Vector2.zero();
    this.color = color ?? Colors.white;
  }

  late final Vector2 position;
  late final Vector2 velocity;
  late final Vector2 acceleration;
  late final Vector4 color;

  void addForce(Vector2 force) {
    acceleration.add(force);
  }

  _Particle clone() {
    return _Particle(
      position: position,
      velocity: velocity,
      acceleration: acceleration,
      color: color,
    );
  }
}
