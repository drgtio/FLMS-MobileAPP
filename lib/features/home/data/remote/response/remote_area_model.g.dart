// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_area_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteAreaModel _$RemoteAreaModelFromJson(Map<String, dynamic> json) =>
    RemoteAreaModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      vehiclesCount: (json['vehiclesCount'] as num).toInt(),
      vehicleGroupsCount: (json['vehicleGroupsCount'] as num).toInt(),
      centreLatitude: (json['centreLatitude'] as num?)?.toDouble(),
      centreLongitude: (json['centreLongitude'] as num?)?.toDouble(),
      alarmSpeed: (json['alarmSpeed'] as num).toInt(),
      areaType: $enumDecode(_$AreaTypeEnumMap, json['areaType']),
      radius: (json['radius'] as num?)?.toDouble(),
      areaPoints: (json['areaPoint'] as List<dynamic>)
          .map((e) => RemoteAreaPointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RemoteAreaModelToJson(RemoteAreaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'vehiclesCount': instance.vehiclesCount,
      'vehicleGroupsCount': instance.vehicleGroupsCount,
      'centreLatitude': instance.centreLatitude,
      'centreLongitude': instance.centreLongitude,
      'alarmSpeed': instance.alarmSpeed,
      'areaType': _$AreaTypeEnumMap[instance.areaType]!,
      'radius': instance.radius,
      'areaPoint': instance.areaPoints,
    };

const _$AreaTypeEnumMap = {
  AreaType.circle: 0,
  AreaType.polygon: 1,
};

RemoteAreaPointModel _$RemoteAreaPointModelFromJson(
        Map<String, dynamic> json) =>
    RemoteAreaPointModel(
      order: (json['order'] as num).toInt(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$RemoteAreaPointModelToJson(
        RemoteAreaPointModel instance) =>
    <String, dynamic>{
      'order': instance.order,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
