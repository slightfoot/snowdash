import 'dart:ui' as ui;

import 'package:flutter/services.dart';

enum ImageAsset {
  dashFalling('assets/dash_falling.png'),
  dashJumping('assets/dash_jumping.png'),
  dashRunning('assets/dash_running.png'),
  dashStanding('assets/dash_standing.png'),
  dashTileSet('assets/grass_tileset.png'),
  ;

  const ImageAsset(this.path);

  final String path;
}

class ImageAssets {
  ImageAssets();

  Map<ImageAsset, ui.Image>? _images;

  ui.Image getImage(ImageAsset asset) => _images![asset]!;

  Future<void> load() async {
    if (_images != null) {
      return;
    }
    _images = Map.fromIterables(
      ImageAsset.values,
      await Future.wait(ImageAsset.values.map(
        (el) => _loadImage(el.path),
      )),
    );
  }

  Future<ui.Image> _loadImage(String assetPath) async {
    final codec = await ui.instantiateImageCodecFromBuffer(
      await rootBundle.loadBuffer(assetPath),
    );
    return (await codec.getNextFrame()).image;
  }
}
