import 'package:dartz/dartz.dart';
import 'package:v2x/core/network/error/app_exception.dart';
import 'package:v2x/features/drivers/data/remote/response/remote_drivers_data.dart';

abstract class DriversRepository {
  Future<Either<AppException, RemoteDriversData>> getDriversList({
    required int page,
  });
}
