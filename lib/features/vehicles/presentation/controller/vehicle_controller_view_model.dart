import 'package:flutter/foundation.dart';
import 'package:v2x/core/network/state/request_state_handler.dart';
import 'package:v2x/core/network/state/result_state.dart';

class VehicleControllerViewModel extends ChangeNotifier {
  final ValueNotifier<ResultState<bool?>> startEngineState =
      ValueNotifier<ResultState<bool?>>(Idle());
  final ValueNotifier<ResultState<bool?>> stopEngineState =
      ValueNotifier<ResultState<bool?>>(Idle());

  String? _deviceId;
  String? get deviceId => _deviceId;
  bool get hasDevice => (_deviceId ?? '').trim().isNotEmpty;

  bool get isStartingEngine => startEngineState.value is Loading;
  bool get isStoppingEngine => stopEngineState.value is Loading;

  void init(String? currentDevice) {
    _deviceId = currentDevice?.trim();
  }

  Future<void> startEngine(String deviceId) async {
    if (deviceId.trim().isEmpty) return;
    await RequestStateHandler.run<bool>(
      action: () async {
        // TODO: Replace placeholder with start engine endpoint call.
        final requestDeviceId = deviceId.trim();
        if (requestDeviceId.isEmpty) return false;
        return true;
      },
      stateNotifier: startEngineState,
      showPopup: false,
    );
    notifyListeners();
  }

  Future<void> stopEngine(String deviceId) async {
    if (deviceId.trim().isEmpty) return;
    await RequestStateHandler.run<bool>(
      action: () async {
        // TODO: Replace placeholder with stop engine endpoint call.
        final requestDeviceId = deviceId.trim();
        if (requestDeviceId.isEmpty) return false;
        return true;
      },
      stateNotifier: stopEngineState,
      showPopup: false,
    );
    notifyListeners();
  }
}
