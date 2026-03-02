import 'package:injectable/injectable.dart';
import 'package:v2x/features/drivers/domain/repository/drivers_repository.dart';

@injectable
class AddDriverUseCase {
  final DriversRepository repository;

  AddDriverUseCase(this.repository);

  Future<bool?> call(
    String firstName,
    String lastName,
    String email,
    String username,
    String password,
  ) {
    return repository.addDriver(firstName, lastName, email, username, password);
  }
}
