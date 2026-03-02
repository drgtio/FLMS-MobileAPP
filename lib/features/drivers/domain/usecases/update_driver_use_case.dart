import 'package:injectable/injectable.dart';
import 'package:v2x/features/drivers/domain/repository/drivers_repository.dart';

@injectable
class UpdateDriverUseCase {
  final DriversRepository repository;

  UpdateDriverUseCase(this.repository);

  Future<bool?> call(
    String id,
    String firstName,
    String lastName,
    String email,
    String username,
    String? password,
  ) {
    return repository.updateDriver(
      id,
      firstName,
      lastName,
      email,
      username,
      password,
    );
  }
}
