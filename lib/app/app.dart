import 'package:flutter/material.dart';
import 'package:snowdash/app/assets.dart';
import 'package:snowdash/app/game_screen.dart';
import 'package:snowdash/models/level_data.dart';

class SnowDashApp extends StatelessWidget {
  const SnowDashApp(this.images, this.levelData, {super.key});

  final ImageAssets images;
  final LevelData levelData;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(images, levelData),
    );
  }
}
