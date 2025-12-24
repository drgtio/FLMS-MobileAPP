import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/network/error/app_exception.dart';
import 'package:v2x/core/network/state/request_state_handler.dart';
import 'package:v2x/core/network/state/result_state.dart';
import 'package:v2x/core/storage/secure_storage_user.dart';
import 'package:v2x/features/auth/domain/models/user_entity.dart';
import 'package:v2x/features/auth/domain/usecases/register/register_api_use_case.dart';
import 'package:v2x/features/auth/domain/usecases/register/validate_register_use_case.dart';

@injectable
class RegisterViewModel extends ChangeNotifier {
  final ValidateRegisterUseCase _validateRegisterUseCase;
  final RegisterApiUseCase _registerApiUseCase;

  RegisterViewModel(this._validateRegisterUseCase, this._registerApiUseCase);

  bool isLoading = false;
  String? errorMessage;
  bool _isButtonEnabled = false;
  bool get isButtonEnabled => _isButtonEnabled;

    final storageService = getIt<SecureStorageService>();


  final ValueNotifier<ResultState<UserEntity?>> registerState =
      ValueNotifier<ResultState<UserEntity?>>(Idle());

  Future<void> register(
    String phoneNumber,
    String firstName,
    String lastName,
    String email,
    String password,
    String userName,
  ) async {
    RequestStateHandler.run<UserEntity?>(
      action:
          () => _registerApiUseCase(
            phoneNumber,
            firstName,
            lastName,
            email,
            password,
            userName,
          ),
      stateNotifier: registerState,
    ).then((_) {
      final state = registerState.value;
      if (state is Error) {
        final stateError = state as Error;
        final error = (stateError.error as AppException?);
        errorMessage = error?.message;
        notifyListeners();
      }
    });
  }

  bool? validateRegisterButton(
    String phoneNumber,
    String firstName,
    String lastName,
    String email,
    String password,
    String userName,
  ) {
    _isButtonEnabled = _validateRegisterUseCase.call(
      phoneNumber: phoneNumber,
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      userName: userName,
    );
    notifyListeners();
    return _isButtonEnabled;
  }

    void saveUser(UserEntity user) async {
    await storageService.saveUser(user);
  }
}
