import 'package:json_annotation/json_annotation.dart';

part 'remote_vehicle_model.g.dart';

@JsonSerializable()
class Maker {
  final int id;
  final String name;
  Maker({required this.id, required this.name});
  factory Maker.fromJson(Map<String, dynamic> json) => _$MakerFromJson(json);
  Map<String, dynamic> toJson() => _$MakerToJson(this);
}

@JsonSerializable()
class VehicleStatusRef {
  final int id;
  final String name; // Arabic names in sample
  VehicleStatusRef({required this.id, required this.name});
  factory VehicleStatusRef.fromJson(Map<String, dynamic> json) =>
      _$VehicleStatusRefFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleStatusRefToJson(this);
}

@JsonSerializable()
class VehicleGroupRef {
  final int id;
  final String name;
  VehicleGroupRef({required this.id, required this.name});
  factory VehicleGroupRef.fromJson(Map<String, dynamic> json) =>
      _$VehicleGroupRefFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleGroupRefToJson(this);
}

@JsonSerializable()
class RemoteVehicleModel {
  final int? id;
  final String? name;
  final String? maintenanceStatus; // "Ok" | "DueSoon" | "Overdue"
  final String? vehicleIdentificationNumber;
  final String? licensePlate;
  final int? type;
  final int? year;
  final String? model;
  final String? registerationState;
  final String? photo;
  final int? makerId;
  final int? vehicleStatusId;
  final int? vehicleGroupId;

  final Maker? maker;
  final VehicleStatusRef? vehicleStatus;
  final VehicleGroupRef? vehicleGroup;

  final bool? isCurrentlyAssigned;
  final String? currentDriverName;
  final String? currentDevice;

  final bool? isDeleted;
  final String? deletionDate;
  final String? updatedDate;
  final String? createdDate;

  RemoteVehicleModel({
    required this.id,
    required this.name,
    required this.maintenanceStatus,
    required this.vehicleIdentificationNumber,
    required this.licensePlate,
    required this.type,
    required this.year,
    required this.model,
    required this.registerationState,
    required this.photo,
    required this.makerId,
    required this.vehicleStatusId,
    required this.vehicleGroupId,
    required this.maker,
    required this.vehicleStatus,
    required this.vehicleGroup,
    required this.isCurrentlyAssigned,
    this.currentDriverName,
    this.currentDevice,
    required this.isDeleted,
    this.deletionDate,
    this.updatedDate,
    this.createdDate,
  });

  factory RemoteVehicleModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteVehicleModelFromJson(json);
  Map<String, dynamic> toJson() => _$RemoteVehicleModelToJson(this);
}
