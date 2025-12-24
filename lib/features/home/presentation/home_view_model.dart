import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/core/network/state/request_state_handler.dart';
import 'package:v2x/core/network/state/result_state.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/features/home/data/remote/response/remote_area_model.dart';
import 'package:v2x/features/home/data/remote/response/remote_vehicle_area_model.dart';
import 'package:v2x/features/home/domain/usecases/get_area_list_use_case.dart';
import 'package:v2x/features/home/domain/usecases/get_vehicles_area_use_case.dart';

@injectable
class HomeViewModel extends ChangeNotifier {
  final GetAreaListUseCase _getAreaListUseCase;
  final GetVehiclesAreaUseCase _getVehiclesAreaUseCase;

  HomeViewModel(this._getAreaListUseCase, this._getVehiclesAreaUseCase);

  final ValueNotifier<ResultState<List<RemoteAreaModel>?>> areasState =
      ValueNotifier(Idle());

  final ValueNotifier<ResultState<List<RemoteVehicleAreaModel>?>> vehiclesState =
      ValueNotifier(Idle());

  List<RemoteAreaModel> _areas = [];
  List<RemoteAreaModel> get areas => _areas;

  List<RemoteVehicleAreaModel> _vehiclesInSelectedArea = [];
  List<RemoteVehicleAreaModel> get vehiclesInSelectedArea =>
      _vehiclesInSelectedArea;

  RemoteAreaModel? selectedArea;

  Set<Polygon> polygons = {};
  Set<Circle> circles = {};
  Set<Marker> markers = {};

  bool get isAreasLoading => areasState.value is Loading;
  bool get isVehiclesLoading => vehiclesState.value is Loading;

  LatLng? get selectedAreaCenter {
    final area = selectedArea;
    if (area == null) return null;

    if (area.areaType == AreaType.circle &&
        area.centreLatitude != null &&
        area.centreLongitude != null) {
      return LatLng(area.centreLatitude!, area.centreLongitude!);
    } else if (area.areaType == AreaType.polygon &&
        area.areaPoints.isNotEmpty) {
      double latSum = 0;
      double lngSum = 0;
      for (final p in area.areaPoints) {
        latSum += p.latitude;
        lngSum += p.longitude;
      }
      return LatLng(
        latSum / area.areaPoints.length,
        lngSum / area.areaPoints.length,
      );
    }
    return null;
  }

  Future<void> loadAreas() async {
    await RequestStateHandler.run(
      stateNotifier: areasState,
      action: () => _getAreaListUseCase(),
    );

    final state = areasState.value;
    if (state is Success<List<RemoteAreaModel>?>) {
      _areas = state.data ?? [];
      _buildShapes();
      notifyListeners();
    }
  }

  void _buildShapes() {
    final Set<Polygon> newPolygons = {};
    final Set<Circle> newCircles = {};

    for (final area in _areas) {
      final isSelected = selectedArea?.id == area.id;
      final circleColor = isSelected ? AppColors.primary : AppColors.blue;
      final polygonColor = isSelected ? AppColors.primary : AppColors.green;

      if (area.areaType == AreaType.circle &&
          area.centreLatitude != null &&
          area.centreLongitude != null &&
          area.radius != null) {
        newCircles.add(
          Circle(
            circleId: CircleId('area_${area.id}'),
            center: LatLng(area.centreLatitude!, area.centreLongitude!),
            radius: area.radius!,
            strokeWidth: isSelected ? 3 : 2,
            strokeColor: circleColor,
            fillColor: circleColor.withValues(alpha: 0.2),
            consumeTapEvents: true,
            onTap: () => onAreaTapped(area),
          ),
        );
      } else if (area.areaType == AreaType.polygon &&
          area.areaPoints.isNotEmpty) {
        newPolygons.add(
          Polygon(
            polygonId: PolygonId('area_${area.id}'),
            points: area.areaPoints
                .map((p) => LatLng(p.latitude, p.longitude))
                .toList(),
            strokeWidth: isSelected ? 3 : 2,
            strokeColor: polygonColor,
            fillColor: polygonColor.withValues(alpha: 0.2),
            consumeTapEvents: true,
            onTap: () => onAreaTapped(area),
          ),
        );
      }
    }

    polygons = newPolygons;
    circles = newCircles;
  }

  void _buildVehicleMarkers() {
    final Set<Marker> newMarkers = {};

    for (final vehicle in _vehiclesInSelectedArea) {
      if (vehicle.latitude != null && vehicle.longitude != null) {
        final statusColor = _getVehicleStatusColor(vehicle.vehicleStatus);
        newMarkers.add(
          Marker(
            markerId: MarkerId('vehicle_${vehicle.vehicleId ?? 0}'),
            position: LatLng(vehicle.latitude!, vehicle.longitude!),
            infoWindow: InfoWindow(
              title: vehicle.vehicleName ?? '',
              snippet: '${vehicle.driverName ?? ''} • ${vehicle.licensePlate ?? ''}',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(statusColor),
          ),
        );
      }
    }

    markers = newMarkers;
  }

  double _getVehicleStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'moving':
        return BitmapDescriptor.hueGreen;
      case 'idle':
        return BitmapDescriptor.hueOrange;
      case 'stopped':
        return BitmapDescriptor.hueRed;
      default:
        return BitmapDescriptor.hueBlue;
    }
  }

  Future<void> onAreaTapped(RemoteAreaModel area) async {
    selectedArea = area;
    _buildShapes();
    notifyListeners();

    await RequestStateHandler.run(
      stateNotifier: vehiclesState,
      action: () => _getVehiclesAreaUseCase(area.id),
    );

    final state = vehiclesState.value;
    if (state is Success<List<RemoteVehicleAreaModel>?>) {
      _vehiclesInSelectedArea = state.data ?? [];
      _buildVehicleMarkers();
      notifyListeners();
    }
  }

  void clearSelection() {
    selectedArea = null;
    _vehiclesInSelectedArea = [];
    markers = {};
    vehiclesState.value = Idle();
    _buildShapes();
    notifyListeners();
  }
}
