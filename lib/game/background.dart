import 'package:snowdash/game/game_entity.dart';
import 'package:snowdash/models/level_data.dart';

class Background extends SnowDashEntity {
  Background(
    this.level,
  );

  final LevelData level;

  @override
  String get id => 'background';

  @override
  void render(Renderer renderer) {
    renderer.fillRect(game.levelBox, level.backgroundColor);
  }
}
