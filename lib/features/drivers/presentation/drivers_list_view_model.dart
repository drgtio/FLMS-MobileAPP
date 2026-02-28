import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/network/state/request_state_handler.dart';
import 'package:v2x/core/network/state/result_state.dart';
import 'package:v2x/core/storage/secure_storage_user.dart';
import 'package:v2x/features/auth/domain/models/user_entity.dart';
import 'package:v2x/features/drivers/data/remote/response/remote_driver_model.dart';
import 'package:v2x/features/drivers/domain/usecases/get_drivers_use_case.dart';

@injectable
class DriversListViewModel extends ChangeNotifier {
  final GetDriversUseCase _getDriversUseCase;

  DriversListViewModel(this._getDriversUseCase);

  final SecureStorageService storageService = getIt<SecureStorageService>();

  final ValueNotifier<ResultState<List<RemoteDriverModel>?>> requestsState =
      ValueNotifier<ResultState<List<RemoteDriverModel>?>>(Idle());

  final ValueNotifier<bool> isLoadingMore = ValueNotifier<bool>(false);

  final List<RemoteDriverModel> _items = [];
  List<RemoteDriverModel> get items => _items;

  int _currentPage = 1;
  int _pageCount = 1;
  bool get hasMore => _currentPage < _pageCount;

  bool _isInitializing = false;

  Future<UserEntity?> getUserModel() async => storageService.getUser();

  Future<void> init() async {
    final user = await getUserModel();
    if (user == null) return;
    if (_isInitializing) return;
    _isInitializing = true;

    _currentPage = 1;
    _pageCount = 1;
    _items.clear();

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
      final res = await _getDriversUseCase(_currentPage);
      res.fold((failure) => throw Exception(failure.message), (paginated) {
        _pageCount = paginated.totalPages ?? 1;
        _items.addAll(paginated.data ?? const []);
      });
      notifyListeners();
    } catch (_) {
      _currentPage = (_currentPage > 1) ? _currentPage - 1 : 1;
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> _loadFirstPage() async {
    await RequestStateHandler.run<List<RemoteDriverModel>>(
      action: () async {
        final res = await _getDriversUseCase(_currentPage);
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

  @override
  void dispose() {
    requestsState.dispose();
    isLoadingMore.dispose();
    super.dispose();
  }
}
