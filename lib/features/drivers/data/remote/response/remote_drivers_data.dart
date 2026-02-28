import 'package:json_annotation/json_annotation.dart';
import 'package:v2x/features/drivers/data/remote/response/remote_driver_model.dart';

part 'remote_drivers_data.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class RemoteDriversData {
  final List<RemoteDriverModel>? data;
  final int? totalRows;
  final int? totalPages;

  RemoteDriversData({
    required this.data,
    required this.totalRows,
    required this.totalPages,
  });

  factory RemoteDriversData.fromJson(Map<String, dynamic> json) =>
      _$RemoteDriversDataFromJson(json);

  Map<String, dynamic> toJson(
    Object Function(RemoteDriverModel value) toJsonRemoteDriverModel,
  ) => _$RemoteDriversDataToJson(this);
}
