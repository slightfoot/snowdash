import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:snowdash/app/assets.dart';
import 'package:snowdash/engine/input_manager.dart';
import 'package:snowdash/engine/renderer.dart';
import 'package:snowdash/game/game.dart' hide Colors;
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
      level: widget.levelData,
      images: widget.images,
    );
    game.init();
    renderer = Renderer(
      game: game,
      level: widget.levelData,
      images: widget.images,
    );
    ticker = createTicker(_onTick);
    ticker.start();
  }

  void _onTick(Duration elapsed) {
    lastElapsed ??= elapsed;
    final deltaTime = (lastElapsed! - elapsed).inMicroseconds / Duration.microsecondsPerMillisecond;
    game.update(deltaTime);
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
    return GestureDetector(
      onTap: () => game.fireworks.addFirework(),
      child: InputHost(
        inputManager: game.inputManager,
        child: SizedBox.expand(
          child: Material(
            color: Colors.black,
            child: FittedBox(
              fit: BoxFit.contain,
              child: CustomPaint(
                painter: GamePainter(
                  game: game,
                  renderer: renderer,
                ),
                size: SnowDashGame.size,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GamePainter extends CustomPainter {
  GamePainter({
    required SnowDashGame game,
    required this.renderer,
  }) : super(repaint: game);

  final Renderer renderer;

  @override
  void paint(Canvas canvas, Size size) {
    renderer.render(canvas, size);
  }

  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) {
    return renderer != oldDelegate.renderer;
  }
}
