import 'package:snowdash/game/game_entity.dart';

class Player extends SnowDashEntity {
  Player({
    required this.startPosition,
  });

  @override
  String get id => 'player';

  final Vector2 startPosition;
  late final Image _image;
  final _playerCenter = Vector2.zero();
  var _playerColor = Colors.white;

  @override
  void init() {
    _image = images.getImage(ImageAsset.dashStanding);
    _playerCenter.xy = Vector2(
      -_image.width.toDouble() / 2,
      -_image.height.toDouble() / 2,
    );
    // TODO: load position from level data
    position.setFrom(startPosition);
    velocity.setValues(0.1, 0.1);
  }

  @override
  void update(double deltaTime) {
    final dv = input.player1Axis;
    position.add(dv..multiply(velocity * deltaTime));

    if (input.player1Action) {
      _playerColor = Colors.red;
    } else {
      _playerColor = Colors.white;
    }
  }

  @override
  void render(Renderer renderer) {
    renderer.drawImage(_playerCenter, _image, _playerColor);
  }
}
