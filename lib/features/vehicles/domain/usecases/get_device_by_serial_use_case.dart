import 'package:injectable/injectable.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_device_model.dart';
import 'package:v2x/features/vehicles/domain/repository/vehicles_repository.dart';

@injectable
class GetDeviceBySerialUseCase {
  final VehiclesRepository repository;

  GetDeviceBySerialUseCase(this.repository);

  Future<RemoteDeviceModel?> call(String serialNumber) {
    return repository.getDeviceBySerial(serialNumber);
  }
}
