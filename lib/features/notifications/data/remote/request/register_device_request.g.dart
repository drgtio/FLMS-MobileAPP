// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_device_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterDeviceRequest _$RegisterDeviceRequestFromJson(
        Map<String, dynamic> json) =>
    RegisterDeviceRequest(
      authenticationPlatform: (json['authenticationPlatform'] as num).toInt(),
      registrationId: json['registrationId'] as String,
      allowNotifications: json['allowNotifications'] as bool,
    );

Map<String, dynamic> _$RegisterDeviceRequestToJson(
        RegisterDeviceRequest instance) =>
    <String, dynamic>{
      'authenticationPlatform': instance.authenticationPlatform,
      'registrationId': instance.registrationId,
      'allowNotifications': instance.allowNotifications,
    };
