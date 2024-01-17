import 'package:snowdash/game/game_entity.dart';

class Player extends SnowDashEntity {
  Player({
    required this.startPosition,
  });

  @override
  String get id => 'player';

  final Vector2 startPosition;
  late final ImageAsset _asset;
  late final Image _image;
  final _playerCenter = Vector2.zero();

  var _playerColor = Colors.white;
  final _movementAxis = Vector2.zero();


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
    final dv = input.player1Axis;
    _movementAxis.xy = -dv.xy;
    position.add(dv..multiply(velocity * deltaTime));
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
      flipHorizontal: _movementAxis.x < 0,
    );
  }
}
