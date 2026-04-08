import 'package:injectable/injectable.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_device_model.dart';
import 'package:v2x/features/vehicles/domain/repository/vehicles_repository.dart';

@injectable
class CreateDeviceUseCase {
  final VehiclesRepository repository;

  CreateDeviceUseCase(this.repository);

  Future<RemoteDeviceModel?> call({
    required String serialNumber,
    required int vehicleId,
  }) {
    return repository.createDevice(
      serialNumber: serialNumber,
      vehicleId: vehicleId,
    );
  }
}
