part of 'game.dart';

abstract class Entity<G extends Game> {
  Entity({required this.id});

  final String id;

  var position = Vector2.zero();
  var velocity = Vector2.zero();
  G? _game;

  G get game => _game!;

  void init();

  void update(double deltaTime) {
    position += velocity * deltaTime;
  }

  void render(Canvas canvas, Size size);

  @override
  String toString() => '$runtimeType#$id($position :: $velocity)';
}

