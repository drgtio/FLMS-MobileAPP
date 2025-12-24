import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/features/vehicles/data/remote/remote_vehicles_data_source.dart';

@module
abstract class VehiclesDataSourceModule {
  @lazySingleton
  RemoteVehiclesDataSource apiService(Dio dio) => RemoteVehiclesDataSource(dio);
}
