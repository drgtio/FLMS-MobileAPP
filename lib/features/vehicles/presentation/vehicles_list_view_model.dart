import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/network/state/request_state_handler.dart';
import 'package:v2x/core/network/state/result_state.dart';
import 'package:v2x/core/storage/secure_storage_user.dart';
import 'package:v2x/features/auth/domain/models/user_entity.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_vehicle_model.dart';
import 'package:v2x/features/vehicles/domain/usecases/delete_vehicle_use_case.dart';
import 'package:v2x/features/vehicles/domain/usecases/get_vehicles_use_case.dart';

@injectable
class VehiclesListViewModel extends ChangeNotifier {
  final GetVehiclesUseCase _getVehiclesUseCase;
  final DeleteVehicleUseCase _deleteVehicleUseCase;

  VehiclesListViewModel(this._getVehiclesUseCase, this._deleteVehicleUseCase);

  final SecureStorageService storageService = getIt<SecureStorageService>();

  final ValueNotifier<ResultState<List<RemoteVehicleModel>?>> requestsState =
      ValueNotifier<ResultState<List<RemoteVehicleModel>?>>(Idle());

  final ValueNotifier<ResultState<int?>> deleteState =
      ValueNotifier<ResultState<int?>>(Idle());

  final ValueNotifier<bool> isLoadingMore = ValueNotifier<bool>(false);

  final List<RemoteVehicleModel> _items = [];
  List<RemoteVehicleModel> get items => _items;

  int _currentPage = 1;
  int _pageCount = 1;
  bool get hasMore => _currentPage < _pageCount;

  bool _isInitializing = false;

  Future<UserEntity?> getUserModel() async => storageService.getUser();

  /// First load (page 1). Shows full-screen loader if list is empty.
  Future<void> init() async {
    final user = await getUserModel();
    if (user == null) return;
    if (_isInitializing) return;
    _isInitializing = true;

    _currentPage = 1;
    _pageCount = 1;
    _items.clear();

    // Full-screen loader only for first page
    requestsState.value = Loading();
    notifyListeners();

    await _loadFirstPage();

    _isInitializing = false;
  }

  Future<void> refresh() => init();

  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore.value) return;

    isLoadingMore.value = true;
    _currentPage++;

    try {
      final res = await _getVehiclesUseCase(_currentPage);
      res.fold((failure) => throw Exception(failure.message), (paginated) {
        _pageCount = paginated.totalPages ?? 1;
        _items.addAll(paginated.data ?? const []);
      });
      notifyListeners();
    } catch (e) {
      _currentPage = (_currentPage > 1) ? _currentPage - 1 : 1;
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> _loadFirstPage() async {
    await RequestStateHandler.run<List<RemoteVehicleModel>>(
      action: () async {
        final res = await _getVehiclesUseCase(_currentPage);
        return res.fold((failure) => throw Exception(failure.message), (
          paginated,
        ) {
          _pageCount = paginated.totalPages ?? 1;
          _items.addAll(paginated.data ?? const []);
          return _items;
        });
      },
      stateNotifier: requestsState,
    );
    notifyListeners();
  }

  Future<void> deleteVehicle(
    int id
  ) async {
    RequestStateHandler.run<int?>(
      action: () => _deleteVehicleUseCase(id),
      stateNotifier: deleteState,
    ).then((_) {
      final state = deleteState.value;
      if (state is Success<int?>) {
        _items.removeWhere((element) => element.id == id);
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    requestsState.dispose();
    isLoadingMore.dispose();
    super.dispose();
  }
}
