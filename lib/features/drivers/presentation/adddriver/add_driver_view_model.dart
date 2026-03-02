import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/core/network/error/app_exception.dart';
import 'package:v2x/core/network/state/request_state_handler.dart';
import 'package:v2x/core/network/state/result_state.dart';
import 'package:v2x/features/drivers/domain/usecases/add_driver_use_case.dart';
import 'package:v2x/features/drivers/domain/usecases/update_driver_use_case.dart';
import 'package:v2x/features/drivers/domain/usecases/validate_add_driver_use_case.dart';

@injectable
class AddDriverViewModel extends ChangeNotifier {
  final AddDriverUseCase _addDriverUseCase;
  final UpdateDriverUseCase _updateDriverUseCase;
  final ValidateAddDriverUseCase _validateAddDriverUseCase;

  AddDriverViewModel(
    this._addDriverUseCase,
    this._validateAddDriverUseCase,
    this._updateDriverUseCase,
  );

  String? errorMessage;
  bool _isButtonEnabled = false;
  bool get isButtonEnabled => _isButtonEnabled;

  final ValueNotifier<ResultState<bool?>> addDriverState =
      ValueNotifier<ResultState<bool?>>(Idle());
  final ValueNotifier<ResultState<bool?>> updateDriverState =
      ValueNotifier<ResultState<bool?>>(Idle());

  Future<void> addDriver(
    String firstName,
    String lastName,
    String email,
    String username,
    String password,
  ) async {
    RequestStateHandler.run<bool?>(
      action:
          () => _addDriverUseCase(firstName, lastName, email, username, password),
      stateNotifier: addDriverState,
    ).then((_) {
      final state = addDriverState.value;
      if (state is Error) {
        final stateError = state as Error;
        final error = (stateError.error as AppException?);
        errorMessage = error?.message;
        notifyListeners();
      }
    });
  }

  Future<void> updateDriver(
    String id,
    String firstName,
    String lastName,
    String email,
    String username,
    String? password,
  ) async {
    RequestStateHandler.run<bool?>(
      action:
          () => _updateDriverUseCase(
            id,
            firstName,
            lastName,
            email,
            username,
            password,
          ),
      stateNotifier: updateDriverState,
    ).then((_) {
      final state = updateDriverState.value;
      if (state is Error) {
        final stateError = state as Error;
        final error = (stateError.error as AppException?);
        errorMessage = error?.message;
        notifyListeners();
      }
    });
  }

  bool validateAddDriverButton(
    String firstName,
    String lastName,
    String email,
    String username,
    String password,
    bool isEditMode,
  ) {
    _isButtonEnabled = _validateAddDriverUseCase.call(
      firstName: firstName,
      lastName: lastName,
      email: email,
      username: username,
      password: password,
      isEditMode: isEditMode,
    );
    notifyListeners();
    return _isButtonEnabled;
  }
}
