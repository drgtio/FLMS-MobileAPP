import 'package:injectable/injectable.dart';
import 'package:v2x/features/vehicles/domain/repository/vehicles_repository.dart';

@injectable
class DeleteDeviceUseCase {
  final VehiclesRepository repository;

  DeleteDeviceUseCase(this.repository);

  Future<bool?> call(int deviceId) {
    return repository.deleteDevice(deviceId);
  }
}
