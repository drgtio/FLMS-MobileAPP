import 'package:injectable/injectable.dart';
import 'package:v2x/features/auth/domain/models/user_entity.dart';
import 'package:v2x/features/auth/domain/repository/auth_repository.dart';

@injectable
class LoginApiUseCase {
  final AuthRepository repository;

  LoginApiUseCase(this.repository);

  Future<UserEntity?> call(String userName, String password) {
    return repository.login(userName, password);
  }
}
