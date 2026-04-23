import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/features/notifications/data/remote/remote_notifications_data_source.dart';

@module
abstract class NotificationsDataSourceModule {
  @lazySingleton
  RemoteNotificationsDataSource notificationsDataSource(Dio dio) =>
      RemoteNotificationsDataSource(dio);
}
