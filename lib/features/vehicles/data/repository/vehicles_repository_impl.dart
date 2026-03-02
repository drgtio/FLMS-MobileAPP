import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/core/network/error/app_exception.dart';
import 'package:v2x/core/network/error/error_handler.dart';
import 'package:v2x/features/vehicles/data/remote/remote_vehicles_data_source.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_vehicle_model.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_vehicles_data.dart';
import 'package:v2x/features/vehicles/domain/repository/vehicles_repository.dart';

@Injectable(as: VehiclesRepository)
class VehiclesRepositoryImpl implements VehiclesRepository {
  final RemoteVehiclesDataSource _remoteDataSource;

  VehiclesRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<AppException, RemoteVehiclesData>> getVehiclesList({
    required int page,
  }) async {
    try {
      final response = await _remoteDataSource.getVehiclesList(page, 10);

      final data = response.data;
      final List<RemoteVehicleModel>? entities =
          data?.data?.map((e) => e).whereType<RemoteVehicleModel>().toList();

      return Right(
        RemoteVehiclesData(
          totalPages: data?.totalPages,
          data: entities,
          totalRows: data?.totalRows,
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

  @override
  Future<int?> addVehicle(
    String name,
    int makerId,
    String year,
    String licensePlate,
    String model,
  ) async {
    final response = await _remoteDataSource.addVehicle({
      'name': name,
      'makerId': makerId,
      'year': year,
      'licensePlate': licensePlate,
      'model': model,
    });
    return response.data;
  }

  @override
  Future<RemoteVehicleModel?> editVehicle(
    int id,
    String name,
    int makerId,
    String year,
    String licensePlate,
    String model,
  ) async {
    final response = await _remoteDataSource.editVehicle({
      'id': id,
      'name': name,
      'makerId': makerId,
      'year': year,
      'licensePlate': licensePlate,
      'model': model,
    });
    return response.data;
  }

  @override
  Future<int?> deleteVehicle(int id) async {
    final response = await _remoteDataSource.deleteVehicle(id);
    return response.data;
  }

  @override
  Future<bool?> assignVehicle({
    required bool isUpdate,
    required int vehicleId,
    required String operatorId,
    Object? currentAssignmentId,
    String? startDate,
    String? endDate,
    String? comment,
  }) async {
    final body = {
      'vehicleId': vehicleId,
      'operatorId': operatorId,
      'startDate': startDate,
      'endDate': endDate,
      'comment': comment,
    };
    if (isUpdate) {
      final assignmentId = (currentAssignmentId ?? '').toString().trim();
      if (assignmentId.isEmpty) {
        throw Exception('Missing current assignment id for update request');
      }
      body['id'] = assignmentId;
      body['vehicleId'] = vehicleId.toString();
      final response = await _remoteDataSource.updateVehicleAssignment(body);
      return response.success;
    }

    final response = await _remoteDataSource.createVehicleAssignment(body);
    return response.success;
  }

  @override
  Future<List<Maker>?> getVehicleMakers() async {
    final response = await _remoteDataSource.getVehicleMakers();
    return response.data;
  }
}
