import 'package:snowdash/game/game_entity.dart';
import 'package:snowdash/models/level_data.dart';
import 'package:snowdash/util/extensions.dart';

class Background extends SnowDashEntity {
  Background(
    this.level,
  );

  final LevelData level;

  @override
  String get id => 'background';

  @override
  void render(Renderer renderer) {
    renderer.fillRect(
      renderer.bounds + renderer.origin,
      level.backgroundColor,
    );
  }
}
