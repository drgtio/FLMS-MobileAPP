import 'package:dio/dio.dart';
import 'package:v2x/core/network/models/base_response.dart';
import 'package:retrofit/http.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_vehicle_model.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_vehicles_data.dart';
part 'remote_vehicles_data_source.g.dart';

@RestApi()
abstract class RemoteVehiclesDataSource {
  factory RemoteVehiclesDataSource(Dio dio, {String baseUrl}) =
      _RemoteVehiclesDataSource;

  @GET('/mobile/vehicle')
  Future<BaseResponse<RemoteVehiclesData?>> getVehiclesList(
    @Query('PageNumber') int? page,
    @Query('PageSize') int? pageSize,
  );

  @POST('/manage/vehicle')
  Future<BaseResponse<int?>> addVehicle(@Body() Map<String, dynamic> body);

  @PUT('/manage/vehicle')
  Future<BaseResponse<RemoteVehicleModel?>> editVehicle(@Body() Map<String, dynamic> body);

  @DELETE('/manage/vehicle/{id}')
  Future<BaseResponse<int?>> deleteVehicle(@Path() int id);

  @GET('/vehicle-maker/lookup')
  Future<BaseResponse<List<Maker>?>> getVehicleMakers();
}
