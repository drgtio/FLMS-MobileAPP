import 'package:injectable/injectable.dart';
import 'package:v2x/features/home/data/remote/response/remote_vehicle_area_model.dart';
import 'package:v2x/features/home/domain/repository/home_repository.dart';

@injectable
class GetVehiclesAreaUseCase {
  final HomeRepository repository;

  GetVehiclesAreaUseCase(this.repository);

  Future<List<RemoteVehicleAreaModel>?> call(int areaId) {
    return repository.getVehiclesByArea(areaId);
  }
}
