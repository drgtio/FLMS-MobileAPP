import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/core/network/state/request_state_handler.dart';
import 'package:v2x/core/network/state/result_state.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_vehicle_model.dart';
import 'package:v2x/features/vehicles/domain/usecases/get_vehicle_makers_use_case.dart';

enum LookupType { city, neighborhood, services }

@injectable
class LookupListViewModel extends ChangeNotifier {
  final GetVehicleMakersUseCase _getVehicleMakersUseCase;
  int? _selectedValue;
  List<Maker> _items = [];

  LookupListViewModel(this._getVehicleMakersUseCase);

  final ValueNotifier<ResultState<List<Maker>?>> lookupState =
      ValueNotifier<ResultState<List<Maker>?>>(Idle());

  List<Maker> get items => _items;
  int? get selectedValue => _selectedValue;

  void init({int? selectedValue}) {
    _selectedValue = selectedValue;
    _loadMakers();
  }

  Future<void> _loadMakers() async {
    await RequestStateHandler.run<List<Maker>>(
      action: () => _getVehicleMakersUseCase(),
      stateNotifier: lookupState,
    ).then((_) {
      if (lookupState.value is Success<List<Maker>?>) {
        final successState = lookupState.value as Success<List<Maker>?>;
        _items = successState.data ?? [];
      }
    });
  }

  void selectItem(Maker item) {
    _selectedValue = item.id;
    notifyListeners();
  }
}
