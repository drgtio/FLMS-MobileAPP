import 'package:injectable/injectable.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_vehicle_model.dart';
import 'package:v2x/features/vehicles/domain/repository/vehicles_repository.dart';

@injectable
class GetVehicleMakersUseCase {
  final VehiclesRepository repository;

  GetVehicleMakersUseCase(this.repository);

  Future<List<Maker>?> call() {
    return repository.getVehicleMakers();
  }
}
