import 'package:snowdash/app/assets.dart';
import 'package:snowdash/game/game.dart';
import 'package:snowdash/models/level_data.dart';
import 'package:snowdash/util/extensions.dart';

class Renderer {
  Renderer({
    required this.game,
    required this.images,
    required this.level,
  });

  final SnowDashGame game;
  final ImageAssets images;
  final LevelData level;

  late Canvas _canvas;
  late Aabb2 _bounds;

  Aabb2 get bounds => _bounds;

  final _tilePaint = Paint()
    ..isAntiAlias = false
    ..filterQuality = FilterQuality.none;

  void render(Canvas canvas, Size size) {
    _canvas = canvas;
    _bounds = Aabb2.minMax(
      Vector2.zero(),
      Vector2(size.width, size.height),
    );

    final camera = game.findEntityById('camera')!;
    canvas.save();
    canvas.translate(-camera.position.x, -camera.position.y);
    game.renderAllEntities((entity) {
      canvas.save();
      canvas.translate(entity.position.x, entity.position.y);
      entity.render(this);
      canvas.restore();
    });
    canvas.restore();
  }

  void fillRect(Aabb2 box, Vector4 color) {
    _canvas.drawRect(
      box.toRect(),
      Paint()..color = color.toColor(),
    );
  }

  void strokeRect(Aabb2 box, Vector4 color, double strokeWidth) {
    _canvas.drawRect(
      box.toRect(),
      Paint()
        ..color = color.toColor()
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke,
    );
  }

  void drawAsset(Vector2 offset, ImageAsset asset, [Vector4? colorFilter]) {
    drawImage(offset, images.getImage(asset), colorFilter);
  }

  void drawImage(Vector2 offset, Image image, [Vector4? colorFilter]) {
    final paint = Paint();
    if (colorFilter != null) {
      paint.colorFilter = ColorFilter.mode(
        colorFilter.toColor(),
        BlendMode.modulate,
      );
    }
    _canvas.drawImage(image, offset.toOffset(), paint);
  }

  void drawTile(Image tileSet, Aabb2 source, Aabb2 destination) {
    _canvas.drawImageRect(
      tileSet,
      source.toRect(),
      destination.toRect(),
      _tilePaint,
    );
  }

  void drawCircle(Vector2 offset, double radius, Vector4 color) {
    _canvas.drawCircle(
      offset.toOffset(),
      radius,
      Paint()..color = color.toColor(),
    );
  }
}
