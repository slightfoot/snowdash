import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:snowdash/app/assets.dart';
import 'package:snowdash/game/game.dart';
import 'package:snowdash/models/level_data.dart';

class GameScreen extends StatefulWidget {
  const GameScreen(this.images, this.levelData, {super.key});

  final ImageAssets images;
  final LevelData levelData;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late final SnowDashGame game;
  late final Ticker ticker;
  Duration? lastElapsed;

  @override
  void initState() {
    super.initState();
    game = SnowDashGame(
      levelData: widget.levelData,
    );
    game.init();
    ticker = createTicker(_onTick);
    ticker.start();
  }

  void _onTick(Duration elapsed) {
    lastElapsed ??= elapsed;
    final deltaTime = (lastElapsed! - elapsed).inMicroseconds / Duration.microsecondsPerMillisecond;
    game.tick(deltaTime);
    lastElapsed = elapsed;
  }

  @override
  void dispose() {
    ticker.stop();
    game.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Material(
        color: Colors.white,
        child: FittedBox(
          fit: BoxFit.contain,
          child: CustomPaint(
            painter: GamePainter(
              game: game,
              images: widget.images,
              levelData: widget.levelData,
            ),
            size: const Size(320, 256),
          ),
        ),
      ),
    );
  }
}

class GamePainter extends CustomPainter {
  GamePainter({
    required this.game,
    required this.images,
    required this.levelData,
  }) : super(repaint: game);

  final SnowDashGame game;
  final ImageAssets images;
  final LevelData levelData;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Draw Background
    canvas.drawRect(rect, Paint()..color = levelData.backgroundColor);

    final tilePaint = Paint();
    const tileSize = Size(32, 32);
    final tileSet = images.getImage(ImageAsset.dashTileSet);
    final tileStride = tileSet.width ~/ tileSize.width;
    for (int layerIndex = 0; layerIndex < levelData.layers.length; layerIndex++) {
      final layer = levelData.layers[layerIndex];
      if (layer.visible == false) {
        continue;
      }
      for (int row = 0; row < layer.height; row++) {
        for (int col = 0; col < layer.width; col++) {
          int tileIndex = row * layer.width + col;
          int tileValue = layer.data[tileIndex] - 1;
          if (tileValue < 0) {
            continue;
          }
          final tileCol = (tileValue % tileStride).truncateToDouble();
          final tileRow = (tileValue / tileStride).truncateToDouble();
          canvas.drawImageRect(
            tileSet,
            Offset(tileCol * 32, tileRow * 32) & tileSize,
            Offset(col * 32, row * 32) & tileSize,
            tilePaint,
          );
        }
      }
    }

    // TODO: Draw Level Layer 0

    // Draw player
    final gamePadState = game.gamepad.state;
    final pos = game.pos;
    Color playerColor;
    if (gamePadState.buttonA) {
      playerColor = Colors.red;
    } else if (gamePadState.buttonB) {
      playerColor = Colors.green;
    } else if (gamePadState.buttonC) {
      playerColor = Colors.blue;
    } else if (gamePadState.buttonX) {
      playerColor = Colors.purple;
    } else if (gamePadState.buttonY) {
      playerColor = Colors.deepOrange;
    } else if (gamePadState.buttonZ) {
      playerColor = Colors.yellow;
    } else {
      playerColor = Colors.white;
    }
    canvas.drawImage(
        images.getImage(ImageAsset.dashStanding),
        Offset(pos.x, pos.y),
        Paint()
          ..colorFilter = ColorFilter.mode(
            playerColor,
            BlendMode.modulate,
          ));

    // TODO: Draw Level Layer 1

    //
    // canvas.drawAtlas(
    //   atlas,
    //   transforms,
    //   rects,
    //   colors,
    //   blendMode,
    //   cullRect,
    //   paint,
    // );
  }

  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) {
    return images != oldDelegate.images;
  }
}
