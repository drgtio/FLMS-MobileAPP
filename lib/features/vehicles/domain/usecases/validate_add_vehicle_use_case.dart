import 'package:injectable/injectable.dart';

@injectable
class ValidateAddVehicleUseCase {
  bool call({
    required String? name,
    required int? makerId,
    required String? year,
    required String? licensePlate,
    required String? model,
  }) {
    return name?.isNotEmpty == true &&
        makerId != null &&
        makerId != 0 &&
        year?.isNotEmpty == true &&
        licensePlate?.isNotEmpty == true &&
        model?.isNotEmpty == true;
  }
}
