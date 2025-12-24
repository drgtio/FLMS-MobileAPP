import 'package:v2x/features/home/data/remote/response/remote_area_model.dart';
import 'package:v2x/features/home/data/remote/response/remote_vehicle_area_model.dart';

abstract class HomeRepository {
  Future<List<RemoteAreaModel>?> getAreaList();

  Future<List<RemoteVehicleAreaModel>?> getVehiclesByArea(int areaId);
}
