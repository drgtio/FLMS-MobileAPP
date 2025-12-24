// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => UserEntity(
      id: json['id'] as String?,
      username: json['username'] as String?,
      fullName: json['fullName'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      createdDate: json['createdDate'] as String?,
      allowNotifications: json['allowNotifications'] as bool?,
      isVerified: json['isVerified'] as bool?,
      userType: (json['userType'] as num?)?.toInt(),
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'fullName': instance.fullName,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'createdDate': instance.createdDate,
      'allowNotifications': instance.allowNotifications,
      'isVerified': instance.isVerified,
      'userType': instance.userType,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
    };
