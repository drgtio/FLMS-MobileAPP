import 'package:injectable/injectable.dart';
import 'package:v2x/features/vehicles/domain/repository/vehicles_repository.dart';

@injectable
class AssignVehicleUseCase {
  final VehiclesRepository repository;

  AssignVehicleUseCase(this.repository);

  Future<bool?> call({
    required bool isUpdate,
    required int vehicleId,
    required String operatorId,
    Object? currentAssignmentId,
    String? startDate,
    String? endDate,
    String? comment,
  }) {
    return repository.assignVehicle(
      isUpdate: isUpdate,
      vehicleId: vehicleId,
      operatorId: operatorId,
      currentAssignmentId: currentAssignmentId,
      startDate: startDate,
      endDate: endDate,
      comment: comment,
    );
  }
}
