import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:vector_math/vector_math.dart';

final _winmm = DynamicLibrary.open('winmm.dll');

final _joyGetNumDevs = _winmm.lookupFunction<Uint32 Function(), int Function()>('joyGetNumDevs');

/// The joyGetPosEx function queries a joystick for its position and button status.
final _joyGetPosEx = _winmm.lookupFunction<Uint32 Function(Uint32, Pointer<JOYINFOEX>),
    int Function(int id, Pointer<JOYINFOEX> info)>('joyGetPosEx');

class Gamepad {
  Gamepad(this.id);

  final int id;

  var _state = GamepadState.disconnected();

  GamepadState get state => _state;

  static int get deviceCount => _joyGetNumDevs();

  bool get isConnected => state.connected;

  void updateState() {
    final infoEx = calloc<JOYINFOEX>(1);
    try {
      infoEx.ref.dwSize = sizeOf<JOYINFOEX>();
      infoEx.ref.dwFlags = JOY_RETURNX | JOY_RETURNY | JOY_RETURNBUTTONS;
      final result = _joyGetPosEx(id, infoEx);
      if (result == JOYERR_NOERROR) {
        // TODO: should call joyGetDevCaps
        // to get the max values for x and y
        // https://learn.microsoft.com/en-us/windows/win32/api/joystickapi/nf-joystickapi-joygetdevcaps
        _state = GamepadState(
          connected: true,
          x: ((infoEx.ref.dwXpos / 0x7FFF) - 1.0).roundToDouble(),
          y: ((infoEx.ref.dwYpos / 0x7FFF) - 1.0).roundToDouble(),
          buttons: infoEx.ref.dwButtons,
        );
      } else {
        print('error: ${result - JOYERR_BASE}');
        _state = GamepadState.disconnected();
      }
    } finally {
      calloc.free(infoEx);
    }
  }
}

class GamepadState {
  GamepadState({
    required this.connected,
    required this.x,
    required this.y,
    required this.buttons,
  });

  GamepadState.disconnected()
      : connected = false,
        x = 0,
        y = 0,
        buttons = 0;

  final bool connected;
  final double x;
  final double y;
  final int buttons;

  Vector2 get direction => Vector2(-x, -y);

  bool get buttonX => buttons & (1 << 0) != 0;

  bool get buttonA => buttons & (1 << 1) != 0;

  bool get buttonB => buttons & (1 << 2) != 0;

  bool get buttonY => buttons & (1 << 3) != 0;

  bool get buttonC => buttons & (1 << 4) != 0;

  bool get buttonZ => buttons & (1 << 5) != 0;

  bool get leftTrigger => buttons & (1 << 6) != 0;

  bool get rightTrigger => buttons & (1 << 7) != 0;

  bool get select => buttons & (1 << 8) != 0;

  bool get start => buttons & (1 << 9) != 0;
}

const JOY_RETURNX = 0x00000001;
const JOY_RETURNY = 0x00000002;
const JOY_RETURNBUTTONS = 0x00000080;

const JOYERR_BASE = 160;

/// no error
const JOYERR_NOERROR = 0;

/// bad parameters
const JOYERR_PARMS = JOYERR_BASE + 5;

/// request not completed
const JOYERR_NOCANDO = JOYERR_BASE + 6;

/// joystick is unplugged
const JOYERR_UNPLUGGED = JOYERR_BASE + 7;

/// The JOYINFOEX structure contains extended information
/// about the joystick position, point-of-view position,
/// and button state.
base class JOYINFOEX extends Struct {
  /// Size, in bytes, of this structure.
  @Uint32()
  external int dwSize;

  /// Flags indicating the valid information returned in
  /// this structure. Members that do not contain valid
  /// information are set to zero. The following flags
  /// are defined:
  ///
  /// JOY_RETURNALL       Equivalent to setting all of the JOY_RETURN bits except JOY_RETURNRAWDATA.
  /// JOY_RETURNBUTTONS	  The dwButtons member contains valid information about the state of each joystick button.
  /// JOY_RETURNCENTERED  Centers the joystick neutral position to the middle value of each axis of movement.
  /// JOY_RETURNPOV       The dwPOV member contains valid information about the point-of-view control, expressed in discrete units.
  /// JOY_RETURNPOVCTS    The dwPOV member contains valid information about the point-of-view control expressed in continuous, one-hundredth degree units.
  /// JOY_RETURNR         The dwRpos member contains valid rudder pedal data. This information represents another (fourth) axis.
  /// JOY_RETURNRAWDATA   Data stored in this structure is uncalibrated joystick readings.
  /// JOY_RETURNU         The dwUpos member contains valid data for a fifth axis of the joystick, if such an axis is available, or returns zero otherwise.
  /// JOY_RETURNV         The dwVpos member contains valid data for a sixth axis of the joystick, if such an axis is available, or returns zero otherwise.
  /// JOY_RETURNX         The dwXpos member contains valid data for the x-coordinate of the joystick.
  /// JOY_RETURNY         The dwYpos member contains valid data for the y-coordinate of the joystick.
  /// JOY_RETURNZ         The dwZpos member contains valid data for the z-coordinate of the joystick.
  ///
  @Uint32()
  external int dwFlags;

  /// x position
  @Uint32()
  external int dwXpos;

  /// y position
  @Uint32()
  external int dwYpos;

  /// z position
  @Uint32()
  external int dwZpos;

  /// rudder/4th axis position
  @Uint32()
  external int dwRpos;

  /// 5th axis position
  @Uint32()
  external int dwUpos;

  /// 6th axis position
  @Uint32()
  external int dwVpos;

  /// button states
  @Uint32()
  external int dwButtons;

  /// current button number pressed
  @Uint32()
  external int dwButtonNumber;

  /// point of view state
  @Uint32()
  external int dwPOV;

  /// reserved for communication between winmm & driver
  @Uint32()
  external int dwReserved1;

  /// reserved for future expansion
  @Uint32()
  external int dwReserved2;
}
