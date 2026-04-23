import 'package:injectable/injectable.dart';
import 'package:v2x/features/notifications/data/remote/remote_notifications_data_source.dart';
import 'package:v2x/features/notifications/data/remote/request/register_device_request.dart';
import 'package:v2x/features/notifications/domain/repository/notifications_repository.dart';

@Injectable(as: NotificationsRepository)
class NotificationsRepositoryImpl implements NotificationsRepository {
  final RemoteNotificationsDataSource _dataSource;

  NotificationsRepositoryImpl(this._dataSource);

  @override
  Future<void> registerDevice({
    required String registrationId,
    required String platform,
  }) async {
    final request = RegisterDeviceRequest(
      authenticationPlatform: platform == 'Android' ? 1 : 2,
      registrationId: registrationId,
      allowNotifications: true,
    );
    await _dataSource.registerDevice(request.toJson());
  }
}
