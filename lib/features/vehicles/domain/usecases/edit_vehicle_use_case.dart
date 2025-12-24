import 'package:injectable/injectable.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_vehicle_model.dart';
import 'package:v2x/features/vehicles/domain/repository/vehicles_repository.dart';

@injectable
class EditVehicleUseCase {
  final VehiclesRepository repository;

  EditVehicleUseCase(this.repository);

  Future<RemoteVehicleModel?> call(
    int id,
    String name,
    int makerId,
    String year,
    String licensePlate,
    String model,
  ) {
    return repository.editVehicle(id, name, makerId, year, licensePlate, model);
  }
}
