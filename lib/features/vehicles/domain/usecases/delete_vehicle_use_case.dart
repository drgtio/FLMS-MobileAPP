import 'package:injectable/injectable.dart';
import 'package:v2x/features/vehicles/domain/repository/vehicles_repository.dart';

@injectable
class DeleteVehicleUseCase {
  final VehiclesRepository repository;

  DeleteVehicleUseCase(this.repository);

  Future<int?> call(int id) {
    return repository.deleteVehicle(id);
  }
}
