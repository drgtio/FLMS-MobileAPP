import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/features/home/data/remote/response/remote_vehicle_area_model.dart';
import 'package:v2x/features/home/presentation/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final viewModel = getIt<HomeViewModel>();
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      viewModel.loadAreas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<HomeViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Areas Map'),
            ),
            body: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(31.963716085509905, 35.98268330646816),
                    zoom: 7,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  polygons: vm.polygons,
                  circles: vm.circles,
                  markers: vm.markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  onTap: (_) {
                    if (vm.selectedArea != null) {
                      vm.clearSelection();
                    }
                  },
                ),
                // Loading indicator
                if (vm.isAreasLoading)
                  const Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                // Map controls
                Positioned(
                  right: 16,
                  bottom: vm.selectedArea != null ? 220 : 16,
                  child: Column(
                    children: [
                      _buildMapButton(
                        icon: Icons.my_location,
                        onPressed: _goToMyLocation,
                      ),
                      const SizedBox(height: 8),
                      _buildMapButton(
                        icon: Icons.add,
                        onPressed: _zoomIn,
                      ),
                      const SizedBox(height: 8),
                      _buildMapButton(
                        icon: Icons.remove,
                        onPressed: _zoomOut,
                      ),
                    ],
                  ),
                ),
                // Areas count chip
                if (!vm.isAreasLoading && vm.areas.isNotEmpty)
                  Positioned(
                    left: 16,
                    top: 16,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.layers,
                                size: 18, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              '${vm.areas.length} Areas',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                // Bottom area card
                if (vm.selectedArea != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _buildAreaInfoCard(context, vm),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMapButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.neutral60),
        ),
      ),
    );
  }

  Widget _buildAreaInfoCard(BuildContext context, HomeViewModel vm) {
    final area = vm.selectedArea!;

    return GestureDetector(
      onVerticalDragEnd: (details) {
        // If swiped down (positive velocity), clear selection
        if (details.primaryVelocity != null && details.primaryVelocity! > 100) {
          vm.clearSelection();
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.neutral10,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Area name and type
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        area.areaType.name == 'circle'
                            ? Icons.circle_outlined
                            : Icons.pentagon_outlined,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            area.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          Text(
                            area.areaType.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.neutral40,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.gps_fixed),
                      color: AppColors.primary,
                      onPressed: () => _animateToArea(vm),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Stats row
                Row(
                  children: [
                    _buildStatItem(
                      icon: Icons.directions_car,
                      label: 'Vehicles',
                      value: vm.isVehiclesLoading
                          ? '...'
                          : '${vm.vehiclesInSelectedArea.length}',
                      color: AppColors.blue,
                    ),
                    const SizedBox(width: 16),
                    _buildStatItem(
                      icon: Icons.group,
                      label: 'Groups',
                      value: '${area.vehicleGroupsCount}',
                      color: AppColors.green,
                    ),
                    const SizedBox(width: 16),
                    _buildStatItem(
                      icon: Icons.speed,
                      label: 'Alarm Speed',
                      value: '${area.alarmSpeed} km/h',
                      color: AppColors.orange,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Vehicles section
                if (vm.isVehiclesLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (vm.vehiclesInSelectedArea.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Vehicles in Area',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.neutral60,
                        ),
                      ),
                      TextButton(
                        onPressed: () => _showVehiclesBottomSheet(context, vm),
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: vm.vehiclesInSelectedArea.length > 5
                          ? 5
                          : vm.vehiclesInSelectedArea.length,
                      itemBuilder: (context, index) {
                        final vehicle = vm.vehiclesInSelectedArea[index];
                        return _buildVehicleChip(vehicle);
                      },
                    ),
                  ),
                ] else
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'No vehicles in this area',
                      style: TextStyle(color: AppColors.neutral40),
                    ),
                  ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.neutral40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleChip(RemoteVehicleAreaModel vehicle) {
    final statusColor = _getStatusColor(vehicle.vehicleStatus);
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neutral10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                vehicle.vehicleName ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                vehicle.licensePlate ?? '',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.neutral40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'moving':
        return AppColors.green;
      case 'idle':
        return AppColors.orange;
      case 'stopped':
        return AppColors.red;
      default:
        return AppColors.neutral40;
    }
  }

  void _showVehiclesBottomSheet(BuildContext context, HomeViewModel vm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.neutral10,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.directions_car,
                          color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Vehicles in ${vm.selectedArea?.name ?? 'Area'}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${vm.vehiclesInSelectedArea.length}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.neutral40,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: vm.vehiclesInSelectedArea.length,
                    itemBuilder: (context, index) {
                      final vehicle = vm.vehiclesInSelectedArea[index];
                      return _buildVehicleListTile(vehicle);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVehicleListTile(RemoteVehicleAreaModel vehicle) {
    final statusColor = _getStatusColor(vehicle.vehicleStatus);
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.directions_car,
          color: statusColor,
        ),
      ),
      title: Text(
        vehicle.vehicleName ?? '',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (vehicle.driverName != null && vehicle.driverName!.isNotEmpty)
            Text('Driver: ${vehicle.driverName}'),
          if (vehicle.licensePlate != null)
            Text('Plate: ${vehicle.licensePlate}'),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              vehicle.vehicleStatus ?? 'Unknown',
              style: TextStyle(
                fontSize: 12,
                color: statusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                (vehicle.isInArea ?? false) ? Icons.check_circle : Icons.cancel,
                size: 14,
                color: (vehicle.isInArea ?? false) ? AppColors.green : AppColors.red,
              ),
              const SizedBox(width: 4),
              Text(
                (vehicle.isInArea ?? false) ? 'In Area' : 'Outside',
                style: TextStyle(
                  fontSize: 11,
                  color: (vehicle.isInArea ?? false) ? AppColors.green : AppColors.red,
                ),
              ),
            ],
          ),
        ],
      ),
      onTap: () {
        if (vehicle.latitude != null && vehicle.longitude != null) {
          Navigator.pop(context);
          _mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(vehicle.latitude!, vehicle.longitude!),
              16,
            ),
          );
        }
      },
    );
  }

  void _animateToArea(HomeViewModel vm) {
    final center = vm.selectedAreaCenter;
    if (center != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(center, 14),
      );
    }
  }

  void _goToMyLocation() async {
    // This will trigger the map to go to user's location
    // You may need to get the actual location using a location package
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        const LatLng(31.963716085509905, 35.98268330646816),
        12,
      ),
    );
  }

  void _zoomIn() {
    _mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _mapController?.animateCamera(CameraUpdate.zoomOut());
  }
}
