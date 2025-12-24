import 'package:injectable/injectable.dart';
import 'package:v2x/features/home/data/remote/remote_home_data_source.dart';
import 'package:v2x/features/home/data/remote/response/remote_area_model.dart';
import 'package:v2x/features/home/data/remote/response/remote_vehicle_area_model.dart';
import 'package:v2x/features/home/domain/repository/home_repository.dart';

@Injectable(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final RemoteHomeDataSource _remoteDataSource;

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<RemoteAreaModel>?> getAreaList() async {
    final response = await _remoteDataSource.getAreaList();
    return response.data;
  }

  @override
  Future<List<RemoteVehicleAreaModel>?> getVehiclesByArea(int areaId) async {
    final response = await _remoteDataSource.getVehiclesByArea(
      areaId
    );
    return response.data;
  }
}
