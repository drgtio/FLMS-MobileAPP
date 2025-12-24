import 'package:json_annotation/json_annotation.dart';

part 'remote_vehicle_area_model.g.dart';

@JsonSerializable()
class RemoteVehicleAreaModel {
  final int? vehicleId;
  final String? vehicleName;
  final String? driverName;
  final String? areaName;
  final bool? isInArea;
  final double? latitude;
  final double? longitude;
  final String? groupName;
  final String? vehicleStatus;
  final String? licensePlate;

  RemoteVehicleAreaModel({
    this.vehicleId,
    this.vehicleName,
    this.driverName,
    this.areaName,
    this.isInArea,
    this.latitude,
    this.longitude,
    this.groupName,
    this.vehicleStatus,
    this.licensePlate,
  });

  factory RemoteVehicleAreaModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteVehicleAreaModelFromJson(json);
  Map<String, dynamic> toJson() => _$RemoteVehicleAreaModelToJson(this);
}
