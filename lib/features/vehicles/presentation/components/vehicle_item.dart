import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:v2x/core/components/button/filled_button.dart';
import 'package:v2x/core/components/button/outline_button.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_vehicle_model.dart';

class VehicleItem extends StatelessWidget {
  final RemoteVehicleModel item;
  final VoidCallback? onClickEditVehicle;
  final VoidCallback? onClickDeleteVehicle;

  const VehicleItem({
    super.key,
    required this.item,
    this.onClickEditVehicle,
    this.onClickDeleteVehicle,
  });

  @override
  Widget build(BuildContext context) {
    final assigned =
        item.isCurrentlyAssigned == true ? 'Assigned' : 'Unassigned';

    final maintenance = item.maintenanceStatus;
    final Color statusColor = _maintenanceColor(maintenance);
    final String statusLabel = _maintenanceLabel(maintenance);

    final String title =
        (item.name ?? '').isNotEmpty
            ? item.name!
            : (item.model ?? '').isNotEmpty
            ? item.model!
            : 'Vehicle';

    final String subtitleLine =
        '${item.model ?? '-'} • ${item.year ?? '-'}'.trim();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Material(
        color: AppColors.white,
        elevation: 1.5,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Colored status strip
              Container(width: 4, height: double.infinity, color: statusColor),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row: avatar + title + maintenance badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _VehicleAvatar(name: item.name, model: item.model),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyles.textSize14.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                // Model • Year
                                Text(
                                  subtitleLine,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyles.textSize14.copyWith(
                                    color: AppColors.neutral40,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          _MaintenanceBadge(
                            color: statusColor,
                            label: statusLabel,
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Chips row (Maker, Status, Assigned)
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (item.maker?.name != null &&
                              item.maker?.name.isNotEmpty == true)
                            _ChipLabel(
                              icon: Icons.directions_car_filled_rounded,
                              label: item.maker?.name ?? '',
                            ),
                          if (item.vehicleStatus?.name != null &&
                              item.vehicleStatus?.name.isNotEmpty == true)
                            _ChipLabel(
                              icon: Icons.flag_rounded,
                              label: item.vehicleStatus?.name ?? '',
                            ),
                          _ChipLabel(
                            icon:
                                item.isCurrentlyAssigned == true
                                    ? Icons.check_circle_rounded
                                    : Icons.remove_circle_outline_rounded,
                            label: assigned,
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Plate / VIN / driver / device
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if ((item.licensePlate != null &&
                                  item.licensePlate!.isNotEmpty) ||
                              (item.vehicleIdentificationNumber != null &&
                                  item.vehicleIdentificationNumber!.isNotEmpty))
                            Text(
                              'Plate: ${item.licensePlate ?? '-'} • VIN: ${item.vehicleIdentificationNumber ?? '-'}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.textSize14.copyWith(
                                color: AppColors.neutral40,
                              ),
                            ),
                          if (item.currentDriverName != null &&
                              item.currentDriverName!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.person_outline_rounded,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      'Driver: ${item.currentDriverName}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.textSize14.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (item.currentDevice != null &&
                              item.currentDevice!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Row(
                                children: [
                                  const Icon(Icons.memory_rounded, size: 16),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      'Device: ${item.currentDevice}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.textSize14.copyWith(
                                        color: AppColors.neutral40,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: AppFilledButton(
                              containerPadding: const EdgeInsets.only(right: 8),
                              contentPadding: const EdgeInsets.all(8),
                              label: 'edit'.tr(),
                              onClick: () {
                                onClickEditVehicle?.call();
                              },
                            ),
                          ),
                          Expanded(
                            child: AppOutlinedButton(
                              containerPadding: const EdgeInsets.only(left: 8),
                              borderColor: AppColors.red,
                              textStyle: AppStyles.textSize16.copyWith(
                                color: AppColors.red,
                                fontWeight: FontWeight.bold,
                              ),
                              contentPadding: const EdgeInsets.all(8),
                              label: 'delete_vehicle'.tr(),
                              onClick: () {
                                onClickDeleteVehicle?.call();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _maintenanceColor(String? status) {
    switch (status) {
      case 'Overdue':
        return AppColors.red;
      case 'DueSoon':
        return AppColors.orange;
      default:
        return AppColors.green;
    }
  }

  String _maintenanceLabel(String? status) {
    switch (status) {
      case 'Overdue':
        return 'Overdue';
      case 'DueSoon':
        return 'Due soon';
      default:
        return 'OK';
    }
  }
}

/// Circular avatar with initials / first letter
class _VehicleAvatar extends StatelessWidget {
  final String? name;
  final String? model;

  const _VehicleAvatar({required this.name, required this.model});

  @override
  Widget build(BuildContext context) {
    final base = (name ?? model ?? '').trim();
    final String initial =
        base.isNotEmpty ? base.characters.first.toUpperCase() : '?';

    return CircleAvatar(
      radius: 22,
      backgroundColor: AppColors.secondary.withAlpha(10),
      child: Text(
        initial,
        style: AppStyles.textSize18.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}

class _MaintenanceBadge extends StatelessWidget {
  final Color color;
  final String label;

  const _MaintenanceBadge({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.6), width: 0.7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppStyles.textSize14.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ChipLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppStyles.textSize14.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
