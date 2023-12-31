import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:snowdash/app/assets.dart';
import 'package:snowdash/engine/renderer.dart';
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
  late Renderer renderer;

  @override
  void initState() {
    super.initState();
    game = SnowDashGame(
      levelData: widget.levelData,
    );
    game.init();
    renderer = Renderer(
      level: widget.levelData,
      images: widget.images,
    );
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
              renderer: renderer,
              game: game,
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
    required this.renderer,
    required this.game,
  }) : super(repaint: game);

  final Renderer renderer;
  final SnowDashGame game;

  @override
  void paint(Canvas canvas, Size size) {
    renderer.render(canvas, size, game);
  }

  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) {
    return renderer != oldDelegate.renderer || game != oldDelegate.game;
  }
}
