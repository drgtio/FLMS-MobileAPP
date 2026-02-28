// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_drivers_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteDriversData _$RemoteDriversDataFromJson(Map<String, dynamic> json) =>
    RemoteDriversData(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => RemoteDriverModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalRows: (json['totalRows'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RemoteDriversDataToJson(RemoteDriversData instance) =>
    <String, dynamic>{
      'data': instance.data,
      'totalRows': instance.totalRows,
      'totalPages': instance.totalPages,
    };
