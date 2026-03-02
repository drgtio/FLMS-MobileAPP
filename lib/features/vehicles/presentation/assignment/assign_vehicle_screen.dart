import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:v2x/core/components/button/filled_button.dart';
import 'package:v2x/core/components/dropdown/drop_down.dart';
import 'package:v2x/core/components/edittext/edit_text_default.dart';
import 'package:v2x/core/components/toolbar/main_toolbar.dart';
import 'package:v2x/core/network/state/result_state.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';
import 'package:v2x/core/utils/snack_bar.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_vehicle_model.dart';
import 'package:v2x/features/vehicles/presentation/assignment/assign_vehicle_view_model.dart';

class AssignVehicleScreen extends StatefulWidget {
  final RemoteVehicleModel selectedVehicle;
  final Function() onRefresh;

  const AssignVehicleScreen({
    super.key,
    required this.selectedVehicle,
    required this.onRefresh,
  });

  @override
  State<AssignVehicleScreen> createState() => _AssignVehicleScreenState();
}

class _AssignVehicleScreenState extends State<AssignVehicleScreen> {
  late final AssignVehicleViewModel viewModel;
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel = context.read<AssignVehicleViewModel>();
    commentController.addListener(_syncComment);
    viewModel.assignState.addListener(_handleAssignNavigation);
    viewModel.init(widget.selectedVehicle).then((_) {
      commentController.text = viewModel.comment;
    });
  }

  @override
  void dispose() {
    commentController.removeListener(_syncComment);
    commentController.dispose();
    viewModel.assignState.removeListener(_handleAssignNavigation);
    super.dispose();
  }

  void _syncComment() {
    viewModel.setComment(commentController.text);
  }

  void _handleAssignNavigation() {
    final state = viewModel.assignState.value;
    if (state is Success<bool?> && state.data == true) {
      showSnackBarDefault(
        context,
        viewModel.isUpdateMode
            ? 'Assignment updated successfully'
            : 'Vehicle assigned successfully',
      );
      viewModel.assignState.value = Idle();
      GoRouter.of(context).pop();
      widget.onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder:
          (context, _) => Scaffold(
            appBar: const MainToolbar(title: 'Assign Vehicle'),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    _buildAssignmentCard(),
                    const SizedBox(height: 16),
                    _buildInfoBox(),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildAssignmentCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.neutral10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary.withAlpha(24),
                child: const Icon(Icons.directions_car, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Text(
                'Assignment Details',
                style: AppStyles.textSize18.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppDropdownField(
            label: 'Select Driver',
            hint:
                viewModel.driversState.value is Loading
                    ? 'Loading drivers...'
                    : 'Choose driver',
            value: viewModel.selectedDriver?.fullName,
            onTap: _showDriverSelector,
          ),
          const SizedBox(height: 4),
          AppDropdownField(
            label: 'Select Vehicle',
            hint: '-',
            value: _vehicleLabel(),
            isEnabled: false,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  label: 'From Date',
                  value: viewModel.startDate,
                  onTap: () => _pickDateTime(isStartDate: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateField(
                  label: 'To Date',
                  value: viewModel.endDate,
                  onTap: () => _pickDateTime(isStartDate: false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AppTextFieldDefault(
            hint: 'Comment (optional)',
            label: 'Comment',
            controller: commentController,
            validator: (_) => null,
            containerPadding: EdgeInsets.zero,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder<ResultState<bool?>>(
            valueListenable: viewModel.assignState,
            builder: (context, state, _) {
              return AppFilledButton(
                containerPadding: EdgeInsets.zero,
                label:
                    viewModel.isUpdateMode
                        ? 'Update Assignment'
                        : 'Assign Vehicle',
                isEnabled: viewModel.isButtonEnabled,
                isLoading: state is Loading,
                onClick: viewModel.submitAssignment,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.textSize14),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.neutral10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: AppColors.neutral40),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value == null ? 'DD/MM/YYYY HH:mm' : _formatDateTime(value),
                    style: AppStyles.textSize14.copyWith(
                      color:
                          value == null ? AppColors.neutral30 : AppColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.secondary.withAlpha(15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.secondary.withAlpha(30)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info, color: AppColors.secondary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Set a date range to automatically manage driver rotations and maintenance schedules for the selected vehicle.',
              style: AppStyles.textSize14.copyWith(color: AppColors.secondary),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDateTime({required bool isStartDate}) async {
    final currentValue =
        isStartDate
            ? (viewModel.startDate ?? DateTime.now())
            : (viewModel.endDate ?? DateTime.now());
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentValue,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;

    if (!mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentValue),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (pickedTime == null) return;

    final selectedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
      0,
    );

    if (isStartDate) {
      viewModel.setStartDate(selectedDateTime);
      return;
    }
    viewModel.setEndDate(selectedDateTime);
  }

  void _showDriverSelector() {
    final state = viewModel.driversState.value;
    if (state is Loading) return;
    if (viewModel.drivers.isEmpty) {
      showSnackBarDefault(context, 'No drivers found');
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.white,
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: viewModel.drivers.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final driver = viewModel.drivers[index];
              return ListTile(
                title: Text(driver.fullName ?? '-'),
                subtitle: Text(driver.username ?? ''),
                trailing:
                    viewModel.selectedDriver?.id == driver.id
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                onTap: () {
                  viewModel.setSelectedDriver(driver);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        );
      },
    );
  }

  String _vehicleLabel() {
    final name = widget.selectedVehicle.name ?? '';
    final model = widget.selectedVehicle.model ?? '';
    final plate = widget.selectedVehicle.licensePlate ?? '';
    final String composed = '$name ${model.isNotEmpty ? '- $model' : ''} ${plate.isNotEmpty ? '($plate)' : ''}'.trim();
    return composed.isEmpty ? 'Vehicle' : composed;
  }

  String _formatDateTime(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }
}
