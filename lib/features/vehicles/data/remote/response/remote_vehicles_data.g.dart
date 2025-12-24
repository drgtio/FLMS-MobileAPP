// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_vehicles_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteVehiclesData _$RemoteVehiclesDataFromJson(Map<String, dynamic> json) =>
    RemoteVehiclesData(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => RemoteVehicleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalRows: (json['totalRows'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RemoteVehiclesDataToJson(RemoteVehiclesData instance) =>
    <String, dynamic>{
      'data': instance.data,
      'totalRows': instance.totalRows,
      'totalPages': instance.totalPages,
    };
