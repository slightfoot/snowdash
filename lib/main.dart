import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snowdash/app/app.dart';
import 'package:snowdash/app/assets.dart';
import 'package:snowdash/models/level_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final images = ImageAssets();
  await images.load();
  final levelData = LevelData.fromJson(
    json.decode(await rootBundle.loadString('assets/level1.json')),
  );
  runApp(SnowDashApp(images, levelData));
}
