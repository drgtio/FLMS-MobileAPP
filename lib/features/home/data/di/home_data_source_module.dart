import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/features/home/data/remote/remote_home_data_source.dart';

@module
abstract class HomeDataSourceModule {
  @lazySingleton
  RemoteHomeDataSource apiService(Dio dio) => RemoteHomeDataSource(dio);
}
