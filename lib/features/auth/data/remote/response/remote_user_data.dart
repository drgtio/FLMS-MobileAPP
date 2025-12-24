import 'package:v2x/features/auth/domain/models/user_entity.dart';

class RemoteUserModel {
  final String? id;
  final String? username;
  final String? fullName;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? createdDate;
  final bool? allowNotifications;
  final bool? isVerified;
  final int? userType;
  final String? token;
  final String? refreshToken;

  RemoteUserModel({
    this.id,
    this.username,
    this.fullName,
    this.firstName,
    this.lastName,
    this.email,
    this.createdDate,
    this.allowNotifications,
    this.isVerified,
    this.userType,
    this.token,
    this.refreshToken,
  });

  factory RemoteUserModel.fromJson(Map<String, dynamic> json) =>
      RemoteUserModel(
        id: json['id'] as String?,
        username: json['username'] as String?,
        fullName: json['fullName'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        email: json['email'] as String?,
        createdDate: json['createdDate'] as String?,
        allowNotifications: json['allowNotifications'] as bool?,
        isVerified: json['isVerified'] as bool?,
        userType: json['userType'] as int?,
        token: json['token'] as String?,
        refreshToken: json['refreshToken'] as String?,
      );

  UserEntity? toEntity() => UserEntity(
    id: id,
    username: username,
    fullName: fullName,
    email: email,
    createdDate: createdDate,
    allowNotifications: allowNotifications,
    isVerified: isVerified,
    userType: userType,
    token: token,
    refreshToken: refreshToken,
  );
}
