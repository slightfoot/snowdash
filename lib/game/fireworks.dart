import 'dart:math';

import 'package:flutter/material.dart';
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
    _particles.add(
      _Particle(
        position: Vector2(
          _random.nextDouble() * game.size.width,
          _random.nextDouble() * game.size.height,
        ),
        velocity: Vector2(
          cos(pi * _random.nextDouble()) * 0.03,
          sin(pi * _random.nextDouble()) * 0.06,
        ),
        color: Colors.primaries[//
            _random.nextInt(Colors.primaries.length)],
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
  void render(Canvas canvas, Size size) {
    for (final p in List.of(_particles)) {
      canvas.drawCircle(
        p.position.toOffset(),
        4.0,
        Paint()..color = p.color,
      );
    }
  }
}

class _Particle {
  _Particle({
    Vector2? position,
    Vector2? velocity,
    Vector2? acceleration,
    Color? color,
  }) {
    this.position = position ?? Vector2.zero();
    this.velocity = velocity ?? Vector2.zero();
    this.acceleration = acceleration ?? Vector2.zero();
    this.color = color ?? Colors.white;
  }

  late final Vector2 position;
  late final Vector2 velocity;
  late final Vector2 acceleration;
  late Color color;

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
