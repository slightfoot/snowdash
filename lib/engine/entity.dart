part of 'game.dart';

abstract class Entity<G extends Game> {
  String get id;

  final position = Vector2.zero();
  final velocity = Vector2.zero();
  G? _game;

  G get game => _game!;

  void init();

  void update(double deltaTime) {
    position.add(velocity * deltaTime);
  }

  void render(Canvas canvas, Size size);

  @override
  String toString() => '$runtimeType#$id($position :: $velocity)';
}

