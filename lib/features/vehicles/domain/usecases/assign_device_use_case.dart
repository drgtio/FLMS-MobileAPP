import 'package:injectable/injectable.dart';
import 'package:v2x/features/vehicles/domain/repository/vehicles_repository.dart';

@injectable
class AssignDeviceUseCase {
  final VehiclesRepository repository;

  AssignDeviceUseCase(this.repository);

  Future<bool?> call({
    required int deviceId,
    int? vehicleId,
    required String serialNumber,
  }) {
    return repository.assignDevice(
      deviceId: deviceId,
      vehicleId: vehicleId,
      serialNumber: serialNumber,
    );
  }
}
