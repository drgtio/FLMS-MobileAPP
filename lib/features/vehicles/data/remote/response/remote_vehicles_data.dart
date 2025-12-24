import 'package:json_annotation/json_annotation.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_vehicle_model.dart';

part 'remote_vehicles_data.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class RemoteVehiclesData {
  final List<RemoteVehicleModel>? data;
  final int? totalRows;
  final int? totalPages;

  RemoteVehiclesData({
    required this.data,
    required this.totalRows,
    required this.totalPages,
  });

  factory RemoteVehiclesData.fromJson(
    Map<String, dynamic> json,
  ) => _$RemoteVehiclesDataFromJson(json);

  Map<String, dynamic> toJson(
    Object Function(RemoteVehicleModel value) toJsonfromJsonRemoteVehicleModel,
  ) => _$RemoteVehiclesDataToJson(this);
}
