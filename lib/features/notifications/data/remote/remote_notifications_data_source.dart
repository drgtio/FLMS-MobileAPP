import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:v2x/core/network/models/base_response.dart';

part 'remote_notifications_data_source.g.dart';

@RestApi()
abstract class RemoteNotificationsDataSource {
  factory RemoteNotificationsDataSource(Dio dio, {String baseUrl}) =
      _RemoteNotificationsDataSource;

  @PUT('user/device')
  Future<BaseResponse<dynamic>> registerDevice(
    @Body() Map<String, dynamic> body,
  );
}
