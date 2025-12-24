import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/core/network/error/app_exception.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_vehicles_data.dart';
import 'package:v2x/features/vehicles/domain/repository/vehicles_repository.dart';

@injectable
class GetVehiclesUseCase {
  final VehiclesRepository repository;

  GetVehiclesUseCase(this.repository);

  Future<Either<AppException, RemoteVehiclesData>> call(int page) {
    return repository.getVehiclesList(page: page);
  }
}
