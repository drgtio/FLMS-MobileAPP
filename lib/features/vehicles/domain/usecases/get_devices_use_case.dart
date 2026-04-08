import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/core/network/error/app_exception.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_device_model.dart';
import 'package:v2x/features/vehicles/domain/repository/vehicles_repository.dart';

@injectable
class GetDevicesUseCase {
  final VehiclesRepository repository;

  GetDevicesUseCase(this.repository);

  Future<Either<AppException, RemoteDevicesData>> call({
    required int page,
    int pageSize = 10,
  }) {
    return repository.getDevices(page: page, pageSize: pageSize);
  }
}
