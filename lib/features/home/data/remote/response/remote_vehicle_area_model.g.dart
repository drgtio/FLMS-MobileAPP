// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_vehicle_area_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteVehicleAreaModel _$RemoteVehicleAreaModelFromJson(
        Map<String, dynamic> json) =>
    RemoteVehicleAreaModel(
      vehicleId: (json['vehicleId'] as num?)?.toInt(),
      vehicleName: json['vehicleName'] as String?,
      driverName: json['driverName'] as String?,
      areaName: json['areaName'] as String?,
      isInArea: json['isInArea'] as bool?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      groupName: json['groupName'] as String?,
      vehicleStatus: json['vehicleStatus'] as String?,
      licensePlate: json['licensePlate'] as String?,
    );

Map<String, dynamic> _$RemoteVehicleAreaModelToJson(
        RemoteVehicleAreaModel instance) =>
    <String, dynamic>{
      'vehicleId': instance.vehicleId,
      'vehicleName': instance.vehicleName,
      'driverName': instance.driverName,
      'areaName': instance.areaName,
      'isInArea': instance.isInArea,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'groupName': instance.groupName,
      'vehicleStatus': instance.vehicleStatus,
      'licensePlate': instance.licensePlate,
    };
