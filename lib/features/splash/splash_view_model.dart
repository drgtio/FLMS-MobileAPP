import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/network/state/request_state_handler.dart';
import 'package:v2x/core/network/state/result_state.dart';
import 'package:v2x/core/storage/secure_storage_user.dart';
import 'package:v2x/features/auth/domain/models/user_entity.dart';
import 'package:v2x/features/auth/domain/usecases/user/get_user_api_use_case.dart';

@injectable
class SplashViewModel extends ChangeNotifier {
  final GetUserApiUseCase _getUserApiUseCase;

  SplashViewModel(this._getUserApiUseCase);

  final storageService = getIt<SecureStorageService>();

  final ValueNotifier<ResultState<UserEntity?>> providerInfoState =
      ValueNotifier<ResultState<UserEntity?>>(Idle());

  Future<UserEntity?> getUserInfo() async {
    await RequestStateHandler.run<UserEntity?>(
      action: () => _getUserApiUseCase(),
      stateNotifier: providerInfoState,
    );

    if (providerInfoState.value is Success<UserEntity?>) {
      final userInfo = (providerInfoState.value as Success<UserEntity?>).data;
      if (userInfo != null) {
        await saveUserModel(userInfo);
      }
      return userInfo;
    }

    return null;
  }

  Future<UserEntity?> getUserModel() async {
    return storageService.getUser();
  }

  Future<void> saveUserModel(UserEntity userModel) async {
    UserEntity? user = await getUserModel();
    user = userModel;
    return storageService.saveUser(user);
  }
}
