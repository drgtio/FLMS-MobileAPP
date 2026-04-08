// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteDeviceModel _$RemoteDeviceModelFromJson(Map<String, dynamic> json) =>
    RemoteDeviceModel(
      id: (json['id'] as num?)?.toInt(),
      vehicleId: (json['vehicleId'] as num?)?.toInt(),
      serialNumber: json['serialNumber'] as String?,
    );

Map<String, dynamic> _$RemoteDeviceModelToJson(RemoteDeviceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicleId': instance.vehicleId,
      'serialNumber': instance.serialNumber,
    };

RemoteDevicesData _$RemoteDevicesDataFromJson(Map<String, dynamic> json) =>
    RemoteDevicesData(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => RemoteDeviceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalRows: (json['totalRows'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RemoteDevicesDataToJson(RemoteDevicesData instance) =>
    <String, dynamic>{
      'data': instance.data,
      'totalRows': instance.totalRows,
      'totalPages': instance.totalPages,
    };
