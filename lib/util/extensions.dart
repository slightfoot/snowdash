import 'dart:ui';

import 'package:vector_math/vector_math.dart';

extension OffsetToVector2 on Offset {
  Vector2 toVector2() => Vector2(dx, dy);

  void setVector2(Vector2 v) => v.setValues(dx, dy);
}

extension Vector2ToOffset on Vector2 {
  Offset toOffset() => Offset(x, y);

  String toDebugString() {
    return '(${x.toInt()}, ${y.toInt()})';
  }
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

  Aabb2 intersection(Aabb2 other) {
    final newMin = Vector2.zero();
    final newMax = Vector2.zero();
    Vector2.max(Vector2.zero(), min - other.min, newMin);
    Vector2.max(Vector2.zero(), max - other.max, newMax);
    return Aabb2.minMax(newMin, newMax);
  }

  Aabb2 operator -(Vector2 vector) {
    return Aabb2.copy(this)
      ..min.xy -= vector.xy
      ..max.xy -= vector.xy;
  }

  Aabb2 operator +(Vector2 vector) {
    return Aabb2.copy(this)
      ..min.xy += vector.xy
      ..max.xy += vector.xy;
  }

  set size(Vector2 size) {
    max.xy = min.xy + size;
  }

  String toDebugString() {
    return '${min.toDebugString()}-${max.toDebugString()}::${size.toDebugString()}';
  }
}
