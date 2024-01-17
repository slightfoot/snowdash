import 'package:snowdash/game/game_entity.dart';
import 'package:snowdash/models/level_data.dart';
import 'package:snowdash/util/extensions.dart';

class Player extends SnowDashEntity {
  Player({
    required this.startPosition,
    required this.level,
  });

  @override
  String get id => 'player';

  final Vector2 startPosition;
  final LevelData level;

  late final ImageAsset _asset;
  late final Image _image;
  final _playerCenter = Vector2.zero();

  var _playerColor = Colors.white;
  var _flipHorizontal = false;

  @override
  void init() {
    updateImage(ImageAsset.dashStanding);
    // TODO: load position from level data
    position.setFrom(startPosition);
    velocity.setValues(0.1, 0.1);
    size.setValues(16.0, 16.0);
  }

  void updateImage(ImageAsset asset) {
    _asset = asset;
    _image = images.getImage(_asset);
    _playerCenter.xy = Vector2(
      -_image.width.toDouble() / 2,
      -_image.height.toDouble() / 2,
    );
  }

  @override
  void update(double deltaTime) {
    final directionVector = input.player1Axis;
    if (directionVector.x < 0) {
      _flipHorizontal = false;
    } else if (directionVector.x > 0) {
      _flipHorizontal = true;
    }

    // Collision test loop
    final directionDelta = directionVector..multiply(velocity * deltaTime);
    final box = Aabb2.copy(bounds);
    box.min.add(directionDelta);
    box.max.add(directionDelta);

    // Check for collisions and adjust direction vector
    final tiles = level.collisionTest(box);
    if (tiles.isNotEmpty) {
      print('tiles: ${tiles.map((el) => el.intersection.toDebugString()).toList()}');
      // adjust direction vector
      directionVector.setValues(0.0, 0.0);
    }

    // Apply direction vector
    position.add(
      directionVector,
    );

    if (input.player1Action) {
      _playerColor = Colors.red;
    } else {
      _playerColor = Colors.white;
    }
  }

  @override
  void render(Renderer renderer) {
    renderer.drawImage(
      _playerCenter,
      _image,
      colorFilter: _playerColor,
      flipHorizontal: _flipHorizontal,
    );
  }
}
