import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/rendering.dart';
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
  late Size _size;

  final _bounds = Aabb2();
  final _origin = Vector2.zero();

  Aabb2 get bounds => Aabb2.copy(_bounds);

  Vector2 get origin => _origin.clone();

  final _tilePaint = Paint()
    ..isAntiAlias = false
    ..filterQuality = FilterQuality.none;

  bool get isDebugging => debugPaintSizeEnabled;

  void render(Canvas canvas, Size size) {
    _canvas = canvas;
    _size = size;
    _bounds.max.xy = Vector2(size.width, size.height);
    _origin.xy = game.findEntityById('camera')!.position;
    _canvas.save();
    if (!isDebugging) {
      _canvas.clipRect(
        Offset.zero & size,
        doAntiAlias: false,
      );
    }
    _canvas.translate(-_origin.x, -_origin.y);
    game.entitiesRun((entity) {
      _canvas.save();
      _canvas.translate(entity.position.x, entity.position.y);
      entity.render(this);
      _canvas.restore();
      if (isDebugging) {
        strokeRect(
          entity.bounds,
          Colors.yellow,
          0.5,
        );
        drawText(
          entity.position + Vector2(-8.0, -14.0),
          entity.toString(),
          fontSize: 3.0,
        );
      }
    });
    _canvas.restore();
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

  void drawImage(
    Vector2 offset,
    Image image, {
    Vector4? colorFilter,
    bool flipHorizontal = false,
    bool flipVertical = false,
  }) {
    final paint = Paint();
    if (colorFilter != null) {
      paint.colorFilter = ColorFilter.mode(
        colorFilter.toColor(),
        BlendMode.modulate,
      );
    }
    if (flipHorizontal || flipVertical) {
      _canvas.save();
      _canvas.scale(
        flipHorizontal ? -1.0 : 1.0,
        flipVertical ? -1.0 : 1.0,
      );
    }
    _canvas.drawImage(image, offset.toOffset(), paint);
    if (flipHorizontal || flipVertical) {
      _canvas.restore();
    }
  }

  void drawTile(Image tileSet, Aabb2 source, Aabb2 destination) {
    _canvas.drawImageRect(
      tileSet,
      source.toRect(),
      destination.toRect(),
      _tilePaint,
    );
  }

  void drawTiles(Image tileSet, List<({int index, Aabb2 source, Aabb2 destination})> tiles) {
    _canvas.drawAtlas(
      tileSet,
      [
        for (final tile in tiles) //
          RSTransform(
            1.0,
            0.0,
            tile.destination.min.x,
            tile.destination.min.y,
          ),
      ],
      [
        for (final tile in tiles) //
          tile.source.toRect(),
      ],
      null,
      BlendMode.srcIn,
      Offset.zero & _size,
      Paint(),
    );
    if (isDebugging) {
      for (final tile in tiles) {
        strokeRect(
          tile.destination,
          Colors.white..a = 0.25,
          0.5,
        );
        drawText(
          tile.destination.min,
          tile.index.toString(),
          fontSize: 4.0,
          color: Colors.white..a = 0.75,
        );
      }
    }
  }

  void drawCircle(Vector2 offset, double radius, Vector4 color) {
    _canvas.drawCircle(
      offset.toOffset(),
      radius,
      Paint()..color = color.toColor(),
    );
  }

  void drawText(Vector2 offset, String text,
      {double? fontSize, Vector4? color, ui.TextAlign? textAlign}) {
    final paragraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: textAlign ?? ui.TextAlign.left,
      textDirection: ui.TextDirection.ltr,
    ));
    paragraphBuilder.pushStyle(ui.TextStyle(
      fontSize: fontSize,
      color: color?.toColor(),
    ));
    paragraphBuilder.addText(text);
    final paragraph = paragraphBuilder.build();
    paragraph.layout(
      const ui.ParagraphConstraints(width: double.infinity),
    );
    _canvas.drawParagraph(paragraph, offset.toOffset());
  }
}
