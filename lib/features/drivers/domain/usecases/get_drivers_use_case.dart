import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/core/network/error/app_exception.dart';
import 'package:v2x/features/drivers/data/remote/response/remote_drivers_data.dart';
import 'package:v2x/features/drivers/domain/repository/drivers_repository.dart';

@injectable
class GetDriversUseCase {
  final DriversRepository repository;

  GetDriversUseCase(this.repository);

  Future<Either<AppException, RemoteDriversData>> call(int page) {
    return repository.getDriversList(page: page);
  }
}
