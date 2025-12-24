import 'package:v2x/features/auth/domain/models/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> login(String userName, String password);

  Future<UserEntity?> register(
    String username,
    String password,
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
  );

  Future<UserEntity?> getUser();
}
