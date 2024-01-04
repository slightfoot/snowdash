import 'package:snowdash/game/game_entity.dart';
import 'package:snowdash/game/player.dart';
import 'package:snowdash/util/extensions.dart';

class Camera extends SnowDashEntity {
  Camera();

  @override
  String get id => 'camera';

  @override
  void init() {
    //
  }

  @override
  void update(double deltaTime) {
    final player = game.findEntityById<Player>('player')!;

    final viewBox = Aabb2.copy(game.playField);
    final boundingBox = Aabb2.copy(game.levelBox) //
      ..max.xy -= viewBox.size;

    // Set position to where we want to ideally be
    position.xy = player.position - viewBox.center;

    // Ensure camera can only see LevelBox
    // Left Edge
    if (position.x < boundingBox.min.x) {
      position.x += (boundingBox.min.x - position.x);
    }
    // Right Edge
    else if (position.x >= boundingBox.max.x) {
      position.x += (boundingBox.max.x - position.x);
    }
    // Top Edge
    if (position.y < boundingBox.min.y) {
      position.y += (boundingBox.min.y - position.y);
    }
    // Bottom Edge
    else if (position.y >= boundingBox.max.y) {
      position.y += (boundingBox.max.y - position.y);
    }
  }

  @override
  void render(Renderer renderer) {
    if(renderer.isDebugging) {
      renderer.strokeRect(renderer.bounds, Colors.red, 2.0);
    }
  }
}
