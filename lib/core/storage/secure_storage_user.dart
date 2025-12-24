import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/features/auth/domain/models/user_entity.dart';

@lazySingleton
class SecureStorageService {
  final _storage = const FlutterSecureStorage();
  static const _userKey = 'user_entity';

  Future<void> saveUser(UserEntity user) async {
    final jsonString = jsonEncode(user.toJson());
    await _storage.write(key: _userKey, value: jsonString);
  }

  Future<UserEntity?> getUser() async {
    final jsonString = await _storage.read(key: _userKey);
    if (jsonString == null) return null;

    final Map<String, dynamic> json = jsonDecode(jsonString);
    return UserEntity.fromJson(json);
  }

  Future<void> clearUser() async {
    await _storage.delete(key: _userKey);
  }
}
