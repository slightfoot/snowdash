part of 'game.dart';

abstract class Entity<G extends Game> {
  String get id;

  final position = Vector2.zero();
  final velocity = Vector2.zero();

  G? _game;

  G get game => _game!;

  bool get isAttached => _game != null;

  bool get isNotAttached => !isAttached;

  void init() {
    // override to implement initialisation
  }

  void update(double deltaTime) {
    position.add(velocity * deltaTime);
  }

  void render(Renderer renderer);

  @override
  String toString() => '$runtimeType#$id(pos:$position :: vel:$velocity)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entity && //
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
