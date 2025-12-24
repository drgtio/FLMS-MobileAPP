import 'package:json_annotation/json_annotation.dart';
part 'user_entity.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class UserEntity {
  String? id;
  String? username;
  String? fullName;
  String? firstName;
  String? lastName;
  String? email;
  String? createdDate;
  bool? allowNotifications;
  bool? isVerified;
  int? userType;
  String? token;
  String? refreshToken;

  UserEntity({
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

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);

  UserEntity copyWith({
  String? id,
  String? username,
  String? fullName,
  String? firstName,
  String? lastName,
  String? email,
  String? createdDate,
  bool? allowNotifications,
  bool? isVerified,
  int? userType,
  String? token,
  String? refreshToken,
}) {
  return UserEntity(
    id: id ?? this.id,
    username: username ?? this.username,
    fullName: fullName ?? this.fullName,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    createdDate: createdDate ?? this.createdDate,
    allowNotifications: allowNotifications ?? this.allowNotifications,
    isVerified: isVerified ?? this.isVerified,
    userType: userType ?? this.userType,
    token: token ?? this.token,
    refreshToken: refreshToken ?? this.refreshToken,
  );
}

}
