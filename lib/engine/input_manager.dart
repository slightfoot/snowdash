import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math.dart';

class InputManager {
  InputManager();

  final _player1Axis = Vector2.zero();
  var _player1Action = false;

  Vector2 get player1Axis => _player1Axis.clone();

  bool get player1Action {
    // TODO: perhaps reset flag once read?
    return _player1Action;
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    final isPressed = event is! KeyUpEvent;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowUp:
      case LogicalKeyboardKey.keyW:
        _player1Axis.y = isPressed ? 1 : 0;
      case LogicalKeyboardKey.arrowDown:
      case LogicalKeyboardKey.keyS:
        _player1Axis.y = isPressed ? -1 : 0;
      case LogicalKeyboardKey.arrowLeft:
      case LogicalKeyboardKey.keyA:
        _player1Axis.x = isPressed ? 1 : 0;
      case LogicalKeyboardKey.arrowRight:
      case LogicalKeyboardKey.keyD:
        _player1Axis.x = isPressed ? -1 : 0;
      case LogicalKeyboardKey.space:
      case LogicalKeyboardKey.enter:
        _player1Action = isPressed;
      default:
        return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }
}

class InputHost extends StatelessWidget {
  const InputHost({
    super.key,
    required this.inputManager,
    required this.child,
  });

  final InputManager inputManager;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: inputManager._onKeyEvent,
      child: child,
    );
  }
}
