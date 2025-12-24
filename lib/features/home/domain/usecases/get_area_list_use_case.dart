import 'package:injectable/injectable.dart';
import 'package:v2x/features/home/data/remote/response/remote_area_model.dart';
import 'package:v2x/features/home/domain/repository/home_repository.dart';

@injectable
class GetAreaListUseCase {
  final HomeRepository repository;

  GetAreaListUseCase(this.repository);

  Future<List<RemoteAreaModel>?> call() {
    return repository.getAreaList();
  }
}
