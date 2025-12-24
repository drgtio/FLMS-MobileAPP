import 'package:json_annotation/json_annotation.dart';

part 'remote_area_model.g.dart';

@JsonSerializable()
class RemoteAreaModel {
  final int id;
  final String name;
  final int vehiclesCount;
  final int vehicleGroupsCount;
  final double? centreLatitude;
  final double? centreLongitude;
  final int alarmSpeed;
  final AreaType areaType;
  final double? radius; // meters
  @JsonKey(name: 'areaPoint')
  final List<RemoteAreaPointModel> areaPoints;

  RemoteAreaModel({
    required this.id,
    required this.name,
    required this.vehiclesCount,
    required this.vehicleGroupsCount,
    required this.centreLatitude,
    required this.centreLongitude,
    required this.alarmSpeed,
    required this.areaType,
    required this.radius,
    required this.areaPoints,
  });

  factory RemoteAreaModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteAreaModelFromJson(json);
  Map<String, dynamic> toJson() => _$RemoteAreaModelToJson(this);
}

@JsonEnum(valueField: 'value')
enum AreaType {
  circle(0),
  polygon(1);

  const AreaType(this.value);
  final int value;
}

@JsonSerializable()
class RemoteAreaPointModel {
  final int order;
  final double latitude;
  final double longitude;

  RemoteAreaPointModel({
    required this.order,
    required this.latitude,
    required this.longitude,
  });

  factory RemoteAreaPointModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteAreaPointModelFromJson(json);
  Map<String, dynamic> toJson() => _$RemoteAreaPointModelToJson(this);
}
