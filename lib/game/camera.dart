import 'package:snowdash/game/game_entity.dart';
import 'package:snowdash/game/player.dart';

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
    position.xy = player.position;
  }

  @override
  void render(Renderer renderer) {
    renderer.strokeRect(renderer.bounds, Colors.red, 2.0);
  }
}
