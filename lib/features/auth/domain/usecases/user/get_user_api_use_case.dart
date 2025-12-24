import 'package:injectable/injectable.dart';
import 'package:v2x/features/auth/domain/models/user_entity.dart';
import 'package:v2x/features/auth/domain/repository/auth_repository.dart';

@injectable
class GetUserApiUseCase {
  final AuthRepository repository;

  GetUserApiUseCase(this.repository);

  Future<UserEntity?> call() {
    return repository.getUser();
  }
}
