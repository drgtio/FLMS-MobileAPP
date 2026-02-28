import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:v2x/core/network/models/base_response.dart';
import 'package:v2x/features/drivers/data/remote/response/remote_drivers_data.dart';

part 'remote_drivers_data_source.g.dart';

@RestApi()
abstract class RemoteDriversDataSource {
  factory RemoteDriversDataSource(Dio dio, {String baseUrl}) =
      _RemoteDriversDataSource;

  @GET('/management/user')
  Future<BaseResponse<RemoteDriversData?>> getDriversList(
    @Query('PageNumber') int? page,
    @Query('PageSize') int? pageSize,
  );
}
