import 'package:injectable/injectable.dart';
import 'package:v2x/features/notifications/domain/repository/notifications_repository.dart';

@injectable
class RegisterDeviceUseCase {
  final NotificationsRepository _repository;

  RegisterDeviceUseCase(this._repository);

  Future<void> call({
    required String registrationId,
    required String platform,
  }) {
    return _repository.registerDevice(
      registrationId: registrationId,
      platform: platform,
    );
  }
}
