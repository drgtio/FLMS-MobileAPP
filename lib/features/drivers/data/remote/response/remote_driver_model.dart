import 'package:json_annotation/json_annotation.dart';

part 'remote_driver_model.g.dart';

@JsonSerializable()
class RemoteDriverModel {
  final String? id;
  final String? username;
  final String? fullName;
  final String? email;
  final List<String>? phoneNumbers;
  final int? type;
  final String? createdDate;
  final String? lastLoginDate;
  final bool? active;

  RemoteDriverModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.phoneNumbers,
    required this.type,
    required this.createdDate,
    required this.lastLoginDate,
    required this.active,
  });

  factory RemoteDriverModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteDriverModelFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteDriverModelToJson(this);
}
