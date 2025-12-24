import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/network/error/app_exception.dart';
import 'package:v2x/core/network/state/request_state_handler.dart';
import 'package:v2x/core/network/state/result_state.dart';
import 'package:v2x/core/storage/secure_storage_user.dart';
import 'package:v2x/features/auth/domain/models/user_entity.dart';
import 'package:v2x/features/auth/domain/usecases/login/login_api_use_case.dart';
import 'package:v2x/features/auth/domain/usecases/login/validate_login_use_case.dart';

@injectable
class LoginViewModel extends ChangeNotifier {
  final ValidateLoginUseCase _validateLoginUseCase;
  final LoginApiUseCase _loginApiUseCase;

  LoginViewModel(this._validateLoginUseCase, this._loginApiUseCase);

  bool isLoading = false;
  String? errorMessage;
  bool _isButtonEnabled = false;
  bool get isButtonEnabled => _isButtonEnabled;

  final storageService = getIt<SecureStorageService>();

  final ValueNotifier<ResultState<UserEntity?>> loginState =
      ValueNotifier<ResultState<UserEntity?>>(Idle());

  Future<void> login(String username, String password) async {
    RequestStateHandler.run<UserEntity?>(
      action: () => _loginApiUseCase(username, password),
      stateNotifier: loginState,
    ).then((_) {
      final state = loginState.value;
      if (state is Error) {
        final stateError = state as Error;
        final error = (stateError.error as AppException?);
        errorMessage = error?.message;
        notifyListeners();
      }
    });
  }

  bool? validateLoginButton(String username, String password) {
    _isButtonEnabled = _validateLoginUseCase.call(
      username: username,
      password: password,
    );
    notifyListeners();
    return _isButtonEnabled;
  }

  void saveUser(UserEntity user) async {
    await storageService.saveUser(user);
  }
}
