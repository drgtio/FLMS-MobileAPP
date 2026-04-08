import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/core/network/state/request_state_handler.dart';
import 'package:v2x/core/network/state/result_state.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_device_model.dart';
import 'package:v2x/features/vehicles/domain/usecases/assign_device_use_case.dart';
import 'package:v2x/features/vehicles/domain/usecases/create_device_use_case.dart';
import 'package:v2x/features/vehicles/domain/usecases/delete_device_use_case.dart';
import 'package:v2x/features/vehicles/domain/usecases/get_device_by_serial_use_case.dart';
import 'package:v2x/features/vehicles/domain/usecases/get_devices_use_case.dart';
import 'package:v2x/features/vehicles/domain/usecases/relay_control_use_case.dart';

@injectable
class VehicleControllerViewModel extends ChangeNotifier {
  final GetDeviceBySerialUseCase _getDeviceBySerialUseCase;
  final GetDevicesUseCase _getDevicesUseCase;
  final AssignDeviceUseCase _assignDeviceUseCase;
  final CreateDeviceUseCase _createDeviceUseCase;
  final DeleteDeviceUseCase _deleteDeviceUseCase;
  final RelayControlUseCase _relayControlUseCase;

  VehicleControllerViewModel(
    this._getDeviceBySerialUseCase,
    this._getDevicesUseCase,
    this._assignDeviceUseCase,
    this._createDeviceUseCase,
    this._deleteDeviceUseCase,
    this._relayControlUseCase,
  );

  // Engine state
  final ValueNotifier<ResultState<bool?>> startEngineState =
      ValueNotifier<ResultState<bool?>>(Idle());
  final ValueNotifier<ResultState<bool?>> stopEngineState =
      ValueNotifier<ResultState<bool?>>(Idle());

  // Device state
  final ValueNotifier<ResultState<RemoteDeviceModel?>> fetchDeviceState =
      ValueNotifier<ResultState<RemoteDeviceModel?>>(Idle());
  final ValueNotifier<ResultState<List<RemoteDeviceModel>?>> devicesListState =
      ValueNotifier<ResultState<List<RemoteDeviceModel>?>>(Idle());
  final ValueNotifier<ResultState<bool?>> assignDeviceState =
      ValueNotifier<ResultState<bool?>>(Idle());
  final ValueNotifier<ResultState<bool?>> createDeviceState =
      ValueNotifier<ResultState<bool?>>(Idle());

  String? _deviceId;
  String? get deviceId => _deviceId;
  bool get hasDevice => (_deviceId ?? '').trim().isNotEmpty;

  RemoteDeviceModel? _currentDeviceDetails;
  RemoteDeviceModel? get currentDeviceDetails => _currentDeviceDetails;

  List<RemoteDeviceModel> _devicesList = [];
  List<RemoteDeviceModel> get devicesList => _devicesList;

  bool get isStartingEngine => startEngineState.value is Loading;
  bool get isStoppingEngine => stopEngineState.value is Loading;
  bool get isAssigningDevice => assignDeviceState.value is Loading;
  bool get isFetchingDevice => fetchDeviceState.value is Loading;
  bool get isLoadingDevices => devicesListState.value is Loading;
  bool get isCreatingDevice => createDeviceState.value is Loading;

  int _vehicleId = 0;

  void init(String? currentDevice, int? vehicleId) {
    _deviceId = currentDevice?.trim();
    _vehicleId = vehicleId ?? 0;
    if (_deviceId != null && _deviceId!.isNotEmpty) {
      fetchCurrentDevice(_deviceId!);
    }
  }

  // relay 1 + control: true  → Relay1Control  (start engine)
  // relay 1 + control: false → Relay1Release  (stop engine)
  static const int _engineRelayNumber = 1;

  Future<void> startEngine() async {
    if (_vehicleId == 0) return;
    await RequestStateHandler.run<bool>(
      action: () => _relayControlUseCase(
        vehicleId: _vehicleId,
        relayNumber: _engineRelayNumber,
        control: false,
      ),
      stateNotifier: startEngineState,
      showPopup: true,
    );
    notifyListeners();
  }

  Future<void> stopEngine() async {
    if (_vehicleId == 0) return;
    await RequestStateHandler.run<bool>(
      action: () => _relayControlUseCase(
        vehicleId: _vehicleId,
        relayNumber: _engineRelayNumber,
        control: true,
      ),
      stateNotifier: stopEngineState,
      showPopup: false,
    );
    notifyListeners();
  }

  Future<void> fetchCurrentDevice(String serialNumber) async {
    await RequestStateHandler.run<RemoteDeviceModel>(
      action: () async {
        final device = await _getDeviceBySerialUseCase(serialNumber);
        _currentDeviceDetails = device;
        return device;
      },
      stateNotifier: fetchDeviceState,
      showPopup: false,
    );
    notifyListeners();
  }

  Future<void> loadDevices({int page = 1}) async {
    await RequestStateHandler.run<List<RemoteDeviceModel>>(
      action: () async {
        final result = await _getDevicesUseCase(page: page);
        return result.fold(
          (failure) => throw Exception(failure.message),
          (data) {
            _devicesList = List<RemoteDeviceModel>.from(data.data ?? []);
            return _devicesList;
          },
        );
      },
      stateNotifier: devicesListState,
      showPopup: false,
    );
    notifyListeners();
  }

  Future<bool> assignDevice({
    required int deviceId,
    required String serialNumber,
  }) async {
    bool success = false;
    await RequestStateHandler.run<bool>(
      action: () async {
        final result = await _assignDeviceUseCase(
          deviceId: deviceId,
          vehicleId: _vehicleId,
          serialNumber: serialNumber,
        );
        if (result == true) {
          _deviceId = serialNumber;
          final device = await _getDeviceBySerialUseCase(serialNumber);
          _currentDeviceDetails = device;
          success = true;
        }
        return result;
      },
      stateNotifier: assignDeviceState,
      showPopup: false,
    );
    notifyListeners();
    return success;
  }

  Future<bool> removeDevice() async {
    final details = _currentDeviceDetails;
    if (details == null || details.id == null) return false;
    bool success = false;
    await RequestStateHandler.run<bool>(
      action: () async {
        final result = await _deleteDeviceUseCase(details.id!);
        if (result == true) {
          _deviceId = null;
          _currentDeviceDetails = null;
          success = true;
        }
        return result;
      },
      stateNotifier: assignDeviceState,
      showPopup: false,
    );
    notifyListeners();
    return success;
  }

  Future<RemoteDeviceModel?> lookupDeviceBySerial(String serialNumber) async {
    RemoteDeviceModel? found;
    await RequestStateHandler.run<RemoteDeviceModel>(
      action: () async {
        final device = await _getDeviceBySerialUseCase(serialNumber.trim());
        found = device;
        return device;
      },
      stateNotifier: fetchDeviceState,
      showPopup: false,
    );
    notifyListeners();
    return found;
  }

  Future<bool> createAndAssignDevice({required String serialNumber}) async {
    bool success = false;
    await RequestStateHandler.run<bool>(
      action: () async {
        final device = await _createDeviceUseCase(
          serialNumber: serialNumber,
          vehicleId: _vehicleId,
        );
        if (device != null) {
          _deviceId = device.serialNumber ?? serialNumber;
          _currentDeviceDetails = device;
          success = true;
        }
        return success;
      },
      stateNotifier: createDeviceState,
      showPopup: false,
    );
    notifyListeners();
    return success;
  }

  void clearAssignState() {
    assignDeviceState.value = Idle();
    notifyListeners();
  }
}
