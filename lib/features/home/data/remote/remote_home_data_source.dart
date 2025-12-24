import 'package:dio/dio.dart';
import 'package:v2x/core/network/models/base_response.dart';
import 'package:retrofit/http.dart';
import 'package:v2x/features/home/data/remote/response/remote_area_model.dart';
import 'package:v2x/features/home/data/remote/response/remote_vehicle_area_model.dart';
part 'remote_home_data_source.g.dart';

@RestApi()
abstract class RemoteHomeDataSource {
  factory RemoteHomeDataSource(Dio dio, {String baseUrl}) =
      _RemoteHomeDataSource;

  @GET('/manage/area/get-all-area')
  Future<BaseResponse<List<RemoteAreaModel>?>> getAreaList();

  @GET('/Tracking/vehicles-for-map')
  Future<BaseResponse<List<RemoteVehicleAreaModel>?>> getVehiclesByArea(
    @Query('areaId') int? areaId,
  );
}
