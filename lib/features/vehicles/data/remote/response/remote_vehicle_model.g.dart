// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Maker _$MakerFromJson(Map<String, dynamic> json) => Maker(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$MakerToJson(Maker instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

VehicleStatusRef _$VehicleStatusRefFromJson(Map<String, dynamic> json) =>
    VehicleStatusRef(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$VehicleStatusRefToJson(VehicleStatusRef instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

VehicleGroupRef _$VehicleGroupRefFromJson(Map<String, dynamic> json) =>
    VehicleGroupRef(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$VehicleGroupRefToJson(VehicleGroupRef instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

RemoteVehicleModel _$RemoteVehicleModelFromJson(Map<String, dynamic> json) =>
    RemoteVehicleModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      maintenanceStatus: json['maintenanceStatus'] as String?,
      vehicleIdentificationNumber:
          json['vehicleIdentificationNumber'] as String?,
      licensePlate: json['licensePlate'] as String?,
      type: (json['type'] as num?)?.toInt(),
      year: (json['year'] as num?)?.toInt(),
      model: json['model'] as String?,
      registerationState: json['registerationState'] as String?,
      photo: json['photo'] as String?,
      makerId: (json['makerId'] as num?)?.toInt(),
      vehicleStatusId: (json['vehicleStatusId'] as num?)?.toInt(),
      vehicleGroupId: (json['vehicleGroupId'] as num?)?.toInt(),
      maker: json['maker'] == null
          ? null
          : Maker.fromJson(json['maker'] as Map<String, dynamic>),
      vehicleStatus: json['vehicleStatus'] == null
          ? null
          : VehicleStatusRef.fromJson(
              json['vehicleStatus'] as Map<String, dynamic>),
      vehicleGroup: json['vehicleGroup'] == null
          ? null
          : VehicleGroupRef.fromJson(
              json['vehicleGroup'] as Map<String, dynamic>),
      isCurrentlyAssigned: json['isCurrentlyAssigned'] as bool?,
      currentDriverName: json['currentDriverName'] as String?,
      currentDevice: json['currentDevice'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      deletionDate: json['deletionDate'] as String?,
      updatedDate: json['updatedDate'] as String?,
      createdDate: json['createdDate'] as String?,
    );

Map<String, dynamic> _$RemoteVehicleModelToJson(RemoteVehicleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'maintenanceStatus': instance.maintenanceStatus,
      'vehicleIdentificationNumber': instance.vehicleIdentificationNumber,
      'licensePlate': instance.licensePlate,
      'type': instance.type,
      'year': instance.year,
      'model': instance.model,
      'registerationState': instance.registerationState,
      'photo': instance.photo,
      'makerId': instance.makerId,
      'vehicleStatusId': instance.vehicleStatusId,
      'vehicleGroupId': instance.vehicleGroupId,
      'maker': instance.maker,
      'vehicleStatus': instance.vehicleStatus,
      'vehicleGroup': instance.vehicleGroup,
      'isCurrentlyAssigned': instance.isCurrentlyAssigned,
      'currentDriverName': instance.currentDriverName,
      'currentDevice': instance.currentDevice,
      'isDeleted': instance.isDeleted,
      'deletionDate': instance.deletionDate,
      'updatedDate': instance.updatedDate,
      'createdDate': instance.createdDate,
    };
