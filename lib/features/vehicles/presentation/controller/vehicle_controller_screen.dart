import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:v2x/core/components/button/filled_button.dart';
import 'package:v2x/core/components/button/outline_button.dart';
import 'package:v2x/core/components/toolbar/main_toolbar.dart';
import 'package:v2x/core/network/state/result_state.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_device_model.dart';
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
        widget.selectedVehicle.id,
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

    final String deviceSerial = vm.deviceId ?? '';
    final bool hasDevice = deviceSerial.isNotEmpty;

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
                hasDevice ? '@$deviceSerial' : '-',
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
                  await vm.startEngine();
                },
              ),
              const SizedBox(height: 14),
              AppOutlinedButton(
                containerPadding: EdgeInsets.zero,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                borderColor: AppColors.red,
                isEnabled: hasDevice && !vm.isStartingEngine,
                textStyle: AppStyles.textSize16.copyWith(
                  color: hasDevice && !vm.isStartingEngine ? AppColors.red : AppColors.neutral40,
                  fontWeight: FontWeight.bold,
                ),
                label: 'stop_engine'.tr(),
                onClick: () async {
                  if (!hasDevice || vm.isStartingEngine) return;
                  await vm.stopEngine();
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
              const SizedBox(height: 18),
              const Divider(height: 24),
              _DeviceSection(
                vm: vm,
                vehicleId: widget.selectedVehicle.id ?? 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Device Section ───────────────────────────────────────────────────────────

class _DeviceSection extends StatelessWidget {
  final VehicleControllerViewModel vm;
  final int vehicleId;

  const _DeviceSection({required this.vm, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    final bool hasDevice = vm.hasDevice;
    final RemoteDeviceModel? details = vm.currentDeviceDetails;
    final String serial = details?.serialNumber ?? vm.deviceId ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.router_rounded, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              'device'.tr(),
              style: AppStyles.textSize14.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (vm.isFetchingDevice)
          const Center(child: CircularProgressIndicator())
        else if (hasDevice)
          _DeviceCard(
            serial: serial,
            vm: vm,
            vehicleId: vehicleId,
          )
        else
          _NoDeviceCard(vm: vm, vehicleId: vehicleId),
      ],
    );
  }
}

class _DeviceCard extends StatelessWidget {
  final String serial;
  final VehicleControllerViewModel vm;
  final int vehicleId;

  const _DeviceCard({
    required this.serial,
    required this.vm,
    required this.vehicleId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withAlpha(40)),
      ),
      child: Row(
        children: [
          const Icon(Icons.sim_card_rounded, color: AppColors.primary, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'serial_number'.tr(),
                  style: AppStyles.textSize12.copyWith(color: AppColors.neutral40),
                ),
                const SizedBox(height: 2),
                Text(
                  serial.isNotEmpty ? serial : '-',
                  style: AppStyles.textSize14.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _SmallButton(
            label: 'replace_device'.tr(),
            color: AppColors.primary,
            onTap: () => _showDeviceDialog(context, vm, vehicleId, isReplace: true),
          ),
          const SizedBox(width: 8),
          _SmallButton(
            label: 'remove_device'.tr(),
            color: AppColors.red,
            onTap: () => _confirmRemove(context, vm),
          ),
        ],
      ),
    );
  }

  void _confirmRemove(BuildContext context, VehicleControllerViewModel vm) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.link_off_rounded, size: 48, color: AppColors.red),
              const SizedBox(height: 12),
              Text(
                'remove_device'.tr(),
                style: AppStyles.textSize16.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'remove_device_confirm'.tr(),
                textAlign: TextAlign.center,
                style: AppStyles.textSize14.copyWith(color: AppColors.neutral40),
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder<ResultState<bool?>>(
                valueListenable: vm.assignDeviceState,
                builder: (context, state, _) {
                  final isLoading = state is Loading;
                  return Row(
                    children: [
                      Expanded(
                        child: AppOutlinedButton(
                          containerPadding: EdgeInsets.zero,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          label: 'cancel'.tr(),
                          onClick: () => Navigator.of(ctx).pop(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppFilledButton(
                          containerPadding: EdgeInsets.zero,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: AppColors.red,
                          label: 'remove_device'.tr(),
                          isLoading: isLoading,
                          onClick: () async {
                            final success = await vm.removeDevice();
                            if (success && ctx.mounted) Navigator.of(ctx).pop();
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoDeviceCard extends StatelessWidget {
  final VehicleControllerViewModel vm;
  final int vehicleId;

  const _NoDeviceCard({required this.vm, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'vehicle_no_device_associated'.tr(),
          style: AppStyles.textSize14.copyWith(color: AppColors.neutral40),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        AppFilledButton(
          containerPadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: AppColors.primary,
          label: 'add_device'.tr(),
          onClick: () => _showDeviceDialog(context, vm, vehicleId, isReplace: false),
        ),
      ],
    );
  }
}

// ─── Shared helper to open device dialog ─────────────────────────────────────

void _showDeviceDialog(
  BuildContext context,
  VehicleControllerViewModel vm,
  int vehicleId, {
  required bool isReplace,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => ChangeNotifierProvider.value(
      value: vm,
      child: _DeviceDialog(isReplace: isReplace),
    ),
  );
}

// ─── Device Dialog ────────────────────────────────────────────────────────────

class _DeviceDialog extends StatefulWidget {
  final bool isReplace;

  const _DeviceDialog({required this.isReplace});

  @override
  State<_DeviceDialog> createState() => _DeviceDialogState();
}

class _DeviceDialogState extends State<_DeviceDialog> {
  int _selectedMode = 0; // 0 = browse, 1 = by serial, 2 = add new
  final TextEditingController _serialController = TextEditingController();
  final TextEditingController _newSerialController = TextEditingController();
  RemoteDeviceModel? _lookedUpDevice;
  String? _lookupError;
  String? _createError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleControllerViewModel>().loadDevices();
    });
  }

  @override
  void dispose() {
    _serialController.dispose();
    _newSerialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VehicleControllerViewModel>();

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isReplace ? 'replace_device'.tr() : 'add_device'.tr(),
                style: AppStyles.textSize16.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SegmentedButton<int>(
                segments: [
                  ButtonSegment(value: 0, label: Text('browse_devices'.tr())),
                  ButtonSegment(value: 1, label: Text('by_serial_number'.tr())),
                  ButtonSegment(value: 2, label: Text('add_new_device'.tr())),
                ],
                selected: {_selectedMode},
                onSelectionChanged: (s) => setState(() {
                  _selectedMode = s.first;
                  _lookedUpDevice = null;
                  _lookupError = null;
                  _createError = null;
                }),
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_selectedMode == 0)
                Expanded(child: _BrowseDevicesView(vm: vm, scrollController: scrollController))
              else if (_selectedMode == 1)
                _BySerialView(
                  vm: vm,
                  serialController: _serialController,
                  lookedUpDevice: _lookedUpDevice,
                  lookupError: _lookupError,
                  onLookup: (device, error) => setState(() {
                    _lookedUpDevice = device;
                    _lookupError = error;
                  }),
                )
              else
                _CreateDeviceView(
                  vm: vm,
                  serialController: _newSerialController,
                  errorMessage: _createError,
                  onError: (msg) => setState(() => _createError = msg),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Browse mode ─────────────────────────────────────────────────────────────

class _BrowseDevicesView extends StatelessWidget {
  final VehicleControllerViewModel vm;
  final ScrollController scrollController;

  const _BrowseDevicesView({required this.vm, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    if (vm.isLoadingDevices) {
      return const Center(child: CircularProgressIndicator());
    }

    final devices = vm.devicesList;

    if (devices.isEmpty) {
      return Center(
        child: Text(
          'device_not_found'.tr(),
          style: AppStyles.textSize14.copyWith(color: AppColors.neutral40),
        ),
      );
    }

    return ListView.separated(
      controller: scrollController,
      itemCount: devices.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final device = devices[index];
        return ListTile(
          leading: const Icon(Icons.sim_card_rounded, color: AppColors.primary),
          title: Text(
            device.serialNumber ?? '-',
            style: AppStyles.textSize14.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: device.vehicleId != null
              ? Text(
                  'vehicle #${device.vehicleId}',
                  style: AppStyles.textSize12.copyWith(color: AppColors.neutral40),
                )
              : null,
          trailing: ValueListenableBuilder<ResultState<bool?>>(
            valueListenable: vm.assignDeviceState,
            builder: (context, state, _) {
              final isLoading = state is Loading;
              return TextButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (device.id == null || device.serialNumber == null) return;
                        final success = await vm.assignDevice(
                          deviceId: device.id!,
                          serialNumber: device.serialNumber!,
                        );
                        if (success && context.mounted) Navigator.of(context).pop();
                      },
                child: Text(
                  'assign_device'.tr(),
                  style: AppStyles.textSize14.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ─── By serial mode ───────────────────────────────────────────────────────────

class _BySerialView extends StatelessWidget {
  final VehicleControllerViewModel vm;
  final TextEditingController serialController;
  final RemoteDeviceModel? lookedUpDevice;
  final String? lookupError;
  final void Function(RemoteDeviceModel? device, String? error) onLookup;

  const _BySerialView({
    required this.vm,
    required this.serialController,
    required this.lookedUpDevice,
    required this.lookupError,
    required this.onLookup,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'serial_number'.tr(),
          style: AppStyles.textSize14,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: serialController,
          style: AppStyles.textSize14,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'enter_serial_number'.tr(),
            hintStyle: AppStyles.textSize14.copyWith(color: AppColors.neutral30),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.neutral10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            suffixIcon: ValueListenableBuilder<ResultState<RemoteDeviceModel?>>(
              valueListenable: vm.fetchDeviceState,
              builder: (_, state, __) {
                if (state is Loading) {
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                return IconButton(
                  icon: const Icon(Icons.search),
                  color: AppColors.primary,
                  onPressed: () => _lookup(context),
                );
              },
            ),
          ),
          onSubmitted: (_) => _lookup(context),
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
        ),
        const SizedBox(height: 16),
        if (lookupError != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              lookupError!,
              style: AppStyles.textSize14.copyWith(color: AppColors.red),
            ),
          ),
        if (lookedUpDevice != null) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(10),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withAlpha(40)),
            ),
            child: Row(
              children: [
                const Icon(Icons.sim_card_rounded, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lookedUpDevice!.serialNumber ?? '-',
                        style: AppStyles.textSize14.copyWith(fontWeight: FontWeight.w600),
                      ),
                      if (lookedUpDevice!.vehicleId != null)
                        Text(
                          'vehicle #${lookedUpDevice!.vehicleId}',
                          style: AppStyles.textSize12.copyWith(color: AppColors.neutral40),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<ResultState<bool?>>(
            valueListenable: vm.assignDeviceState,
            builder: (context, state, _) {
              return AppFilledButton(
                containerPadding: EdgeInsets.zero,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: AppColors.primary,
                label: 'assign_device'.tr(),
                isLoading: state is Loading,
                onClick: () async {
                  final device = lookedUpDevice!;
                  if (device.id == null || device.serialNumber == null) return;
                  final success = await vm.assignDevice(
                    deviceId: device.id!,
                    serialNumber: device.serialNumber!,
                  );
                  if (success && context.mounted) Navigator.of(context).pop();
                },
              );
            },
          ),
        ],
      ],
    );
  }

  Future<void> _lookup(BuildContext context) async {
    final serial = serialController.text.trim();
    if (serial.isEmpty) return;
    FocusScope.of(context).unfocus();
    final device = await vm.lookupDeviceBySerial(serial);
    if (device != null) {
      onLookup(device, null);
    } else {
      onLookup(null, 'device_not_found'.tr());
    }
  }
}

// ─── Add new device mode ──────────────────────────────────────────────────────

class _CreateDeviceView extends StatelessWidget {
  final VehicleControllerViewModel vm;
  final TextEditingController serialController;
  final String? errorMessage;
  final void Function(String? msg) onError;

  const _CreateDeviceView({
    required this.vm,
    required this.serialController,
    required this.errorMessage,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'serial_number'.tr(),
          style: AppStyles.textSize14,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: serialController,
          style: AppStyles.textSize14,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'create_device_serial_hint'.tr(),
            hintStyle: AppStyles.textSize14.copyWith(color: AppColors.neutral30),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorMessage != null ? AppColors.red : AppColors.neutral10,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorText: errorMessage,
            errorStyle: AppStyles.textSize12.copyWith(color: AppColors.red),
          ),
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          onChanged: (_) {
            if (errorMessage != null) onError(null);
          },
        ),
        const SizedBox(height: 20),
        ValueListenableBuilder<ResultState<bool?>>(
          valueListenable: vm.createDeviceState,
          builder: (context, state, _) {
            return AppFilledButton(
              containerPadding: EdgeInsets.zero,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: AppColors.primary,
              label: 'create_and_assign'.tr(),
              isLoading: state is Loading,
              isEnabled: state is! Loading,
              onClick: () async {
                final serial = serialController.text.trim();
                if (serial.isEmpty) {
                  onError('enter_serial_number'.tr());
                  return;
                }
                FocusScope.of(context).unfocus();
                final success = await vm.createAndAssignDevice(serialNumber: serial);
                if (success && context.mounted) {
                  Navigator.of(context).pop();
                } else if (!success && context.mounted) {
                  onError('device_create_error'.tr());
                }
              },
            );
          },
        ),
      ],
    );
  }
}

// ─── Small action button ──────────────────────────────────────────────────────

class _SmallButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SmallButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: color.withAlpha(120)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: AppStyles.textSize12.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ─── Info Row ─────────────────────────────────────────────────────────────────

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
