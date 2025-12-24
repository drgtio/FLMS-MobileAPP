import 'package:injectable/injectable.dart';

@injectable
class ValidateRegisterUseCase {
  bool call({
    required String? phoneNumber,
    required String? firstName,
    required String? lastName,
    required String? email,
    required String? password,
    required String? userName,
  }) {
    return phoneNumber?.isNotEmpty == true &&
        firstName?.isNotEmpty == true &&
        lastName?.isNotEmpty == true &&
        email?.isNotEmpty == true &&
        password?.isNotEmpty == true &&
        userName?.isNotEmpty == true;
  }
}
