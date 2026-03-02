import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/core/network/state/request_state_handler.dart';
import 'package:v2x/core/network/state/result_state.dart';
import 'package:v2x/features/drivers/data/remote/response/remote_driver_model.dart';
import 'package:v2x/features/drivers/domain/usecases/get_drivers_use_case.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_vehicle_model.dart';
import 'package:v2x/features/vehicles/domain/usecases/assign_vehicle_use_case.dart';

@injectable
class AssignVehicleViewModel extends ChangeNotifier {
  final AssignVehicleUseCase _assignVehicleUseCase;
  final GetDriversUseCase _getDriversUseCase;

  AssignVehicleViewModel(this._assignVehicleUseCase, this._getDriversUseCase);

  final ValueNotifier<ResultState<List<RemoteDriverModel>?>> driversState =
      ValueNotifier<ResultState<List<RemoteDriverModel>?>>(Idle());

  final ValueNotifier<ResultState<bool?>> assignState =
      ValueNotifier<ResultState<bool?>>(Idle());

  List<RemoteDriverModel> _drivers = [];
  List<RemoteDriverModel> get drivers => _drivers;

  RemoteDriverModel? selectedDriver;
  DateTime? startDate;
  DateTime? endDate;
  String comment = '';

  RemoteVehicleModel? selectedVehicle;

  bool get isUpdateMode => selectedVehicle?.isCurrentlyAssigned == true;

  bool get isButtonEnabled {
    final vehicleId = selectedVehicle?.id;
    final operatorId = selectedDriver?.id;
    final assignmentId =
        (selectedVehicle?.currentAssignmentId ?? '').toString().trim();
    return vehicleId != null &&
        operatorId != null &&
        operatorId.trim().isNotEmpty &&
        (!isUpdateMode || assignmentId.isNotEmpty) &&
        assignState.value is! Loading;
  }

  Future<void> init(RemoteVehicleModel vehicle) async {
    selectedVehicle = vehicle;
    _prefillLocalFieldsFromVehicle(vehicle);
    await loadDrivers();
  }

  Future<void> loadDrivers() async {
    await RequestStateHandler.run<List<RemoteDriverModel>>(
      action: () async {
        final result = await _getDriversUseCase(1);
        return result.fold((failure) => throw Exception(failure.message), (
          paginated,
        ) {
          final list = paginated.data ?? const [];
          _drivers = List<RemoteDriverModel>.from(list);
          _prefillDriverSelection();
          return _drivers;
        });
      },
      stateNotifier: driversState,
      showPopup: false,
    );
    notifyListeners();
  }

  void setSelectedDriver(RemoteDriverModel? driver) {
    selectedDriver = driver;
    notifyListeners();
  }

  void setStartDate(DateTime? value) {
    startDate = value;
    notifyListeners();
  }

  void setEndDate(DateTime? value) {
    endDate = value;
    notifyListeners();
  }

  void setComment(String value) {
    comment = value;
    notifyListeners();
  }

  Future<void> submitAssignment() async {
    if (!isButtonEnabled) return;

    final vehicleId = selectedVehicle?.id;
    final operatorId = selectedDriver?.id;
    if (vehicleId == null || operatorId == null || operatorId.trim().isEmpty) {
      return;
    }

    await RequestStateHandler.run<bool>(
      action:
          () => _assignVehicleUseCase(
            isUpdate: isUpdateMode,
            vehicleId: vehicleId,
            operatorId: operatorId,
            currentAssignmentId: selectedVehicle?.currentAssignmentId,
            startDate: _toBackendDateTimeString(startDate),
            endDate: _toBackendDateTimeString(endDate),
            comment: comment.trim().isEmpty ? null : comment.trim(),
          ),
      stateNotifier: assignState,
      showPopup: false,
    );
    notifyListeners();
  }

  void _prefillLocalFieldsFromVehicle(RemoteVehicleModel vehicle) {
    startDate = _tryParseDate(vehicle.currentAssignmentStartDate);
    endDate = _tryParseDate(vehicle.currentAssignmentEndDate);
    comment = vehicle.currentAssignmentComment ?? '';
  }

  void _prefillDriverSelection() {
    final currentDriverId = selectedVehicle?.currentDriverId;
    if (currentDriverId != null && currentDriverId.isNotEmpty) {
      for (final driver in _drivers) {
        if (driver.id == currentDriverId) {
          selectedDriver = driver;
          return;
        }
      }
    }

    final currentDriverName = selectedVehicle?.currentDriverName;
    if (currentDriverName != null && currentDriverName.isNotEmpty) {
      for (final driver in _drivers) {
        if ((driver.fullName ?? '').trim() == currentDriverName.trim()) {
          selectedDriver = driver;
          return;
        }
      }
    }
  }

  String? _toBackendDateTimeString(DateTime? value) {
    if (value == null) return null;
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final second = value.second.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute:$second';
  }

  DateTime? _tryParseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    final backendPattern = RegExp(
      r'^(\d{2})\/(\d{2})\/(\d{4}) (\d{2}):(\d{2}):(\d{2})$',
    );
    final match = backendPattern.firstMatch(value.trim());
    if (match != null) {
      final day = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);
      final year = int.parse(match.group(3)!);
      final hour = int.parse(match.group(4)!);
      final minute = int.parse(match.group(5)!);
      final second = int.parse(match.group(6)!);
      return DateTime(year, month, day, hour, minute, second);
    }
    return DateTime.tryParse(value);
  }
}
