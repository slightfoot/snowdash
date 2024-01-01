import 'package:snowdash/app/assets.dart';
import 'package:snowdash/engine/game.dart';
import 'package:snowdash/engine/gamepad.dart';
import 'package:snowdash/game/game.dart';

abstract class SnowDashEntity extends Entity<SnowDashGame> {
  SnowDashEntity({required super.id});

  ImageAssets get images => game.images;

  Gamepad get gamepad => game.gamepad;
}
