import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/network/error/app_exception.dart';
import 'package:v2x/core/network/state/request_state_handler.dart';
import 'package:v2x/core/network/state/result_state.dart';
import 'package:v2x/core/storage/secure_storage_user.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_vehicle_model.dart';
import 'package:v2x/features/vehicles/domain/usecases/add_vehicle_use_case.dart';
import 'package:v2x/features/vehicles/domain/usecases/edit_vehicle_use_case.dart';
import 'package:v2x/features/vehicles/domain/usecases/validate_add_vehicle_use_case.dart';

@injectable
class AddEditVehicleViewModel extends ChangeNotifier {
  final AddVehicleUseCase _addVehicleUseCase;
  final EditVehicleUseCase _editVehicleUseCase;
  final ValidateAddVehicleUseCase _validateAddVehicleUseCase;

  AddEditVehicleViewModel(
    this._addVehicleUseCase,
    this._validateAddVehicleUseCase,
    this._editVehicleUseCase,
  );

  bool isLoading = false;
  String? errorMessage;
  bool _isButtonEnabled = false;
  bool get isButtonEnabled => _isButtonEnabled;

  Maker? selectedMaker;

  final storageService = getIt<SecureStorageService>();

  final ValueNotifier<ResultState<int?>> addVehicleState =
      ValueNotifier<ResultState<int?>>(Idle());

  final ValueNotifier<ResultState<RemoteVehicleModel?>> editVehicleState =
      ValueNotifier<ResultState<RemoteVehicleModel?>>(Idle());

  Future<void> addVehicle(
    String name,
    String year,
    String licensePlate,
    String model,
  ) async {
    RequestStateHandler.run<int?>(
      action:
          () => _addVehicleUseCase(
            name,
            selectedMaker?.id ?? 0,
            year,
            licensePlate,
            model,
          ),
      stateNotifier: addVehicleState,
    ).then((_) {
      final state = addVehicleState.value;
      if (state is Error) {
        final stateError = state as Error;
        final error = (stateError.error as AppException?);
        errorMessage = error?.message;
        notifyListeners();
      }
    });
  }

  Future<void> editVehicle(
    int id,
    String name,
    String year,
    String licensePlate,
    String model,
  ) async {
    RequestStateHandler.run<RemoteVehicleModel?>(
      action:
          () => _editVehicleUseCase(
            id,
            name,
            selectedMaker?.id ?? 0,
            year,
            licensePlate,
            model,
          ),
      stateNotifier: editVehicleState,
    ).then((_) {
      final state = editVehicleState.value;
      if (state is Error) {
        final stateError = state as Error;
        final error = (stateError.error as AppException?);
        errorMessage = error?.message;
        notifyListeners();
      }
    });
  }

  bool? validateAddVehicleButton(
    String name,
    String year,
    String licensePlate,
    String model,
  ) {
    _isButtonEnabled = _validateAddVehicleUseCase.call(
      name: name,
      makerId: selectedMaker?.id,
      year: year,
      licensePlate: licensePlate,
      model: model,
    );
    notifyListeners();
    return _isButtonEnabled;
  }
}
