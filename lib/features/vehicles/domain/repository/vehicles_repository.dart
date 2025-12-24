import 'package:dartz/dartz.dart';

import 'package:v2x/core/network/error/app_exception.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_vehicle_model.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_vehicles_data.dart';

abstract class VehiclesRepository {
  Future<Either<AppException, RemoteVehiclesData>> getVehiclesList({
    required int page,
  });

  Future<int?> addVehicle(
    String name,
    int makerId,
    String year,
    String licensePlate,
    String model,
  );

  Future<RemoteVehicleModel?> editVehicle(
    int id,
    String name,
    int makerId,
    String year,
    String licensePlate,
    String model,
  );

  Future<int?> deleteVehicle(int id);

  Future<List<Maker>?> getVehicleMakers();
}
