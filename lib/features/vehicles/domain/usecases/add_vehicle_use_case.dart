import 'package:injectable/injectable.dart';
import 'package:v2x/features/vehicles/domain/repository/vehicles_repository.dart';

@injectable
class AddVehicleUseCase {
  final VehiclesRepository repository;

  AddVehicleUseCase(this.repository);

  Future<int?> call(
    String name,
    int makerId,
    String year,
    String licensePlate,
    String model,
  ) {
    return repository.addVehicle(name, makerId, year, licensePlate, model);
  }
}
