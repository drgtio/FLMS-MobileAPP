import 'package:injectable/injectable.dart';
import 'package:v2x/features/vehicles/domain/repository/vehicles_repository.dart';

@injectable
class RelayControlUseCase {
  final VehiclesRepository repository;

  RelayControlUseCase(this.repository);

  Future<bool?> call({
    required int vehicleId,
    required int relayNumber,
    required bool control,
  }) {
    return repository.relayControl(
      vehicleId: vehicleId,
      relayNumber: relayNumber,
      control: control,
    );
  }
}
