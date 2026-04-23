import 'package:json_annotation/json_annotation.dart';

part 'register_device_request.g.dart';

@JsonSerializable()
class RegisterDeviceRequest {
  final int authenticationPlatform;
  final String registrationId;
  final bool allowNotifications;

  const RegisterDeviceRequest({
    required this.authenticationPlatform,
    required this.registrationId,
    required this.allowNotifications,
  });

  factory RegisterDeviceRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterDeviceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDeviceRequestToJson(this);
}
