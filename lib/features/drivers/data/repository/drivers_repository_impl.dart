import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/core/network/error/app_exception.dart';
import 'package:v2x/core/network/error/error_handler.dart';
import 'package:v2x/features/drivers/data/remote/remote_drivers_data_source.dart';
import 'package:v2x/features/drivers/data/remote/response/remote_driver_model.dart';
import 'package:v2x/features/drivers/data/remote/response/remote_drivers_data.dart';
import 'package:v2x/features/drivers/domain/repository/drivers_repository.dart';

@Injectable(as: DriversRepository)
class DriversRepositoryImpl implements DriversRepository {
  final RemoteDriversDataSource _remoteDataSource;

  DriversRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<AppException, RemoteDriversData>> getDriversList({
    required int page,
  }) async {
    try {
      final response = await _remoteDataSource.getDriversList(page, 10);
      final payload = response.data;

      final List<RemoteDriverModel>? drivers =
          payload?.data
              ?.whereType<RemoteDriverModel>()
              .where((item) => item.type == 4)
              .toList();

      return Right(
        RemoteDriversData(
          totalPages: payload?.totalPages,
          totalRows: payload?.totalRows,
          data: drivers,
        ),
      );
    } catch (e) {
      final exception = ErrorHandler.handle(e);
      return Left(
        AppException(
          message: exception.message,
          exception: exception.exception,
        ),
      );
    }
  }
}
