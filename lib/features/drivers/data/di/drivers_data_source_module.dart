import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/features/drivers/data/remote/remote_drivers_data_source.dart';

@module
abstract class DriversDataSourceModule {
  @lazySingleton
  RemoteDriversDataSource apiService(Dio dio) => RemoteDriversDataSource(dio);
}
