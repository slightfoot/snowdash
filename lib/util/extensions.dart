import 'dart:ui';

import 'package:vector_math/vector_math.dart';

extension OffsetToVector2 on Offset {
  Vector2 toVector2() => Vector2(dx, dy);

  void setVector2(Vector2 v) => v.setValues(dx, dy);
}

extension Vector2ToOffset on Vector2 {
  Offset toOffset() => Offset(x, y);
}

extension Aabb2ToRect on Aabb2 {
  Rect toRect() => Rect.fromLTRB(min.x, min.y, max.x, max.y);
}

extension Vector4ToColor on Vector4 {
  Color toColor() {
    final color = (this * 255);
    return Color.fromARGB(
      color.a.toInt(),
      color.r.toInt(),
      color.g.toInt(),
      color.b.toInt(),
    );
  }
}

extension ColorToVector4 on Color {
  Vector4 toVector4() {
    return Vector4(
      red.toDouble() / 256,
      green.toDouble() / 256,
      blue.toDouble() / 256,
      alpha.toDouble() / 256,
    );
  }
}

extension ExtensionsOnAabb2 on Aabb2 {
  double get width => max.x - min.x;

  double get height => max.y - min.y;

  Vector2 get size => max - min;
}
