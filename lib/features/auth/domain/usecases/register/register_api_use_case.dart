import 'package:injectable/injectable.dart';
import 'package:v2x/features/auth/domain/models/user_entity.dart';
import 'package:v2x/features/auth/domain/repository/auth_repository.dart';

@injectable
class RegisterApiUseCase {
  final AuthRepository repository;

  RegisterApiUseCase(this.repository);

  Future<UserEntity?> call(
    String phoneNumber,
    String firstName,
    String lastName,
    String email,
    String password,
    String userName,
  ) {
    return repository.register(
      phoneNumber,
      firstName,
      lastName,
      email,
      password,
      userName,
    );
  }
}
