import 'package:injectable/injectable.dart';

@injectable
class ValidateAddDriverUseCase {
  bool call({
    required String? firstName,
    required String? lastName,
    required String? email,
    required String? username,
    required String? password,
    bool isEditMode = false,
  }) {
    return firstName?.isNotEmpty == true &&
        lastName?.isNotEmpty == true &&
        email?.isNotEmpty == true &&
        username?.isNotEmpty == true &&
        (isEditMode || password?.isNotEmpty == true);
  }
}
