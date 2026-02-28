// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_driver_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteDriverModel _$RemoteDriverModelFromJson(Map<String, dynamic> json) =>
    RemoteDriverModel(
      id: json['id'] as String?,
      username: json['username'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      phoneNumbers: (json['phoneNumbers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      type: (json['type'] as num?)?.toInt(),
      createdDate: json['createdDate'] as String?,
      lastLoginDate: json['lastLoginDate'] as String?,
      active: json['active'] as bool?,
    );

Map<String, dynamic> _$RemoteDriverModelToJson(RemoteDriverModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'fullName': instance.fullName,
      'email': instance.email,
      'phoneNumbers': instance.phoneNumbers,
      'type': instance.type,
      'createdDate': instance.createdDate,
      'lastLoginDate': instance.lastLoginDate,
      'active': instance.active,
    };
