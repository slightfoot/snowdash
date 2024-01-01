import 'dart:ui';

import 'package:vector_math/vector_math.dart';

extension OffsetToVector2 on Offset {
  Vector2 toVector2() => Vector2(dx, dy);

  void setVector2(Vector2 v) => v.setValues(dx, dy);
}

extension Vector2ToOffset on Vector2 {
  Offset toOffset() => Offset(x, y);
}
