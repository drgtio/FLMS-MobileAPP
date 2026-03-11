import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:v2x/core/components/button/filled_button.dart';
import 'package:v2x/core/components/button/outline_button.dart';
import 'package:v2x/core/components/toolbar/main_toolbar.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_vehicle_model.dart';
import 'package:v2x/features/vehicles/presentation/controller/vehicle_controller_view_model.dart';

class VehicleControllerScreen extends StatefulWidget {
  final RemoteVehicleModel selectedVehicle;
  final VoidCallback? onRefresh;

  const VehicleControllerScreen({
    super.key,
    required this.selectedVehicle,
    this.onRefresh,
  });

  @override
  State<VehicleControllerScreen> createState() => _VehicleControllerScreenState();
}

class _VehicleControllerScreenState extends State<VehicleControllerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleControllerViewModel>().init(
        widget.selectedVehicle.currentDevice,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VehicleControllerViewModel>();
    final String title =
        (widget.selectedVehicle.model ?? '').trim().isNotEmpty
            ? widget.selectedVehicle.model!.trim()
            : (widget.selectedVehicle.name ?? '').trim();

    final String deviceId = vm.deviceId ?? '';
    final bool hasDevice = deviceId.isNotEmpty;

    return Scaffold(
      appBar: MainToolbar(title: 'vehicle_controller_title'.tr()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(12),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: AppColors.primary.withAlpha(12),
                child: const Icon(
                  Icons.directions_car_filled_rounded,
                  size: 30,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title.isNotEmpty ? title : '-',
                style: AppStyles.textSize21.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                'vehicle_controller_subtitle'.tr(),
                style: AppStyles.textSize12.copyWith(color: AppColors.neutral40),
              ),
              const SizedBox(height: 4),
              Text(
                hasDevice ? '@$deviceId' : '-',
                style: AppStyles.textSize14.copyWith(color: AppColors.neutral40),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCF3EA),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.circle, size: 8, color: Color(0xFF00A66A)),
                    const SizedBox(width: 8),
                    Text(
                      'engine_running'.tr(),
                      style: AppStyles.textSize14.copyWith(
                        color: const Color(0xFF00A66A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              AppFilledButton(
                containerPadding: EdgeInsets.zero,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: AppColors.primary,
                label: 'start_engine'.tr(),
                isLoading: vm.isStartingEngine,
                isEnabled: hasDevice && !vm.isStoppingEngine,
                onClick: () async {
                  if (!hasDevice) return;
                  await vm.startEngine(deviceId);
                },
              ),
              const SizedBox(height: 14),
              AppOutlinedButton(
                containerPadding: EdgeInsets.zero,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                borderColor: AppColors.red,
                textStyle: AppStyles.textSize16.copyWith(
                  color: AppColors.red,
                  fontWeight: FontWeight.bold,
                ),
                label: 'stop_engine'.tr(),
                onClick: () async {
                  if (!hasDevice || vm.isStartingEngine) return;
                  await vm.stopEngine(deviceId);
                },
              ),
              const SizedBox(height: 12),
              AppOutlinedButton(
                containerPadding: EdgeInsets.zero,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                label: 'vehicle_controller_back'.tr(),
                onClick: () {
                  Navigator.of(context).maybePop();
                },
              ),
              const SizedBox(height: 18),
              const Divider(height: 24),
              _InfoRow(
                icon: Icons.pin_drop_outlined,
                label: 'current_location'.tr(),
                value: '-',
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.access_time,
                label: 'last_activity'.tr(),
                value: widget.selectedVehicle.updatedDate ?? '-',
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.speed,
                label: 'speed'.tr(),
                value: '-',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.neutral40, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppStyles.textSize12.copyWith(color: AppColors.neutral40),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppStyles.textSize16.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
