import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/features/auth/data/remote/remote_auth_data_source.dart';

@module
abstract class AuthDataSourceModule {
  @lazySingleton
  RemoteAuthDataSource apiService(Dio dio) => RemoteAuthDataSource(dio);
}
