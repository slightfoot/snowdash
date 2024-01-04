import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:snowdash/engine/input_manager.dart';
import 'package:vector_math/vector_math.dart';

part 'entity.dart';

abstract class Game extends ChangeNotifier {
  final _entities = <Entity>{};

  final inputManager = InputManager();

  E? findEntityById<E extends Entity>(String id) {
    return _entities.firstWhereOrNull((e) => e.id == id) as E?;
  }

  List<E> findEntities<E extends Entity>(bool Function(E entity) test) {
    return _entities.whereType<E>().where(test).toList(growable: false);
  }

  void addEntity(Entity entity) {
    if (_entities.add(entity)) {
      entity._game = this;
      notifyListeners();
    }
  }

  void removeEntity(Entity entity) {
    if (_entities.remove(entity)) {
      entity._game = null;
      notifyListeners();
    }
  }

  void init() {
    for (final entity in List.of(_entities)) {
      entity.init();
    }
  }

  void update(double deltaTime) {
    for (final entity in List.of(_entities)) {
      entity.update(deltaTime);
    }
    notifyListeners();
  }

  void render(Canvas canvas, Size size) {
    for (final entity in List.of(_entities)) {
      entity.render(canvas, size);
    }
  }

  @override
  void dispose() {
    //
    super.dispose();
  }
}
