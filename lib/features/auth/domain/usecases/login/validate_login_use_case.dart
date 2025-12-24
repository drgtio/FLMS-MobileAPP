import 'package:injectable/injectable.dart';

@injectable
class ValidateLoginUseCase {
  bool call({required String? username, required String? password}) {
    return username?.isNotEmpty == true && password?.isNotEmpty == true;
  }
}
