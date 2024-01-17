part of 'game.dart';

abstract class Entity<G extends Game> {
  String get id;

  final position = Vector2.zero();
  final velocity = Vector2.zero();
  final size = Vector2.zero();

  final _bounds = Aabb2();

  G? _game;

  G get game => _game!;

  bool get isAttached => _game != null;

  bool get isNotAttached => !isAttached;

  Aabb2 get bounds {
    _bounds.setCenterAndHalfExtents(position, size / 2);
    return _bounds;
  }

  void init() {
    // override to implement initialisation
  }

  void update(double deltaTime) {
    position.add(velocity * deltaTime);
  }

  void render(Renderer renderer);

  @override
  String toString() => '$runtimeType#$id('
      'bounds: ${bounds.toDebugString()} :: '
      'vel: ${velocity.toDebugString()}'
      ')';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entity && //
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
