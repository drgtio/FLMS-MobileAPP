import 'package:dio/dio.dart';
import 'package:v2x/core/network/models/base_response.dart';
import 'package:v2x/features/auth/data/remote/response/remote_user_data.dart';
import 'package:retrofit/http.dart';
part 'remote_auth_data_source.g.dart';

@RestApi()
abstract class RemoteAuthDataSource {
  factory RemoteAuthDataSource(Dio dio, {String baseUrl}) =
      _RemoteAuthDataSource;

  @POST('user/authenticate')
  Future<BaseResponse<RemoteUserModel?>> login(
    @Body() Map<String, String> body,
  );

  @POST('mobile/register')
  Future<BaseResponse<RemoteUserModel?>> register(
    @Body() Map<String, String> body,
  );

  @GET('/user')
  Future<BaseResponse<RemoteUserModel?>> getUser();
}
