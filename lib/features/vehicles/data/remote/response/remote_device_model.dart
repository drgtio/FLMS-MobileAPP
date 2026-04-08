import 'package:json_annotation/json_annotation.dart';

part 'remote_device_model.g.dart';

@JsonSerializable()
class RemoteDeviceModel {
  final int? id;
  final int? vehicleId;
  final String? serialNumber;

  RemoteDeviceModel({
    this.id,
    this.vehicleId,
    this.serialNumber,
  });

  factory RemoteDeviceModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteDeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteDeviceModelToJson(this);
}

@JsonSerializable()
class RemoteDevicesData {
  final List<RemoteDeviceModel>? data;
  final int? totalRows;
  final int? totalPages;

  RemoteDevicesData({
    this.data,
    this.totalRows,
    this.totalPages,
  });

  factory RemoteDevicesData.fromJson(Map<String, dynamic> json) =>
      _$RemoteDevicesDataFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteDevicesDataToJson(this);
}
