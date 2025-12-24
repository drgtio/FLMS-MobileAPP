import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:v2x/core/components/button/filled_button.dart';
import 'package:v2x/core/components/dropdown/drop_down.dart';
import 'package:v2x/core/components/edittext/edit_text_default.dart';
import 'package:v2x/core/components/toolbar/main_toolbar.dart';
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/navigation/navigation_router.dart';
import 'package:v2x/core/network/state/result_state.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';
import 'package:v2x/core/utils/snack_bar.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_vehicle_model.dart';
import 'package:v2x/features/vehicles/domain/utils/constant_vehicles.dart';
import 'package:v2x/features/vehicles/presentation/addeditvehicle/add_edit_vehicle_view_model.dart';

class AddEditVehicleScreen extends StatefulWidget {
  final RemoteVehicleModel? selectedVehicle;
  final Function() onRefresh;
  const AddEditVehicleScreen({
    super.key,
    this.selectedVehicle,
    required this.onRefresh,
  });

  @override
  State<AddEditVehicleScreen> createState() => _AddEditVehicleScreenState();
}

class _AddEditVehicleScreenState extends State<AddEditVehicleScreen> {
  final viewModel = getIt<AddEditVehicleViewModel>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController plateController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    yearController.dispose();
    modelController.dispose();
    plateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    nameController.addListener(_updateButtonState);
    yearController.addListener(_updateButtonState);
    modelController.addListener(_updateButtonState);
    plateController.addListener(_updateButtonState);
    viewModel.addVehicleState.addListener(_handleAddVehicleNavigation);
    viewModel.editVehicleState.addListener(_handleEditVehicleNavigation);
    checkEditVehicle();
    super.initState();
  }

  void _handleAddVehicleNavigation() {
    final state = viewModel.addVehicleState.value;
    if (state is Success<int?>) {
      showSnackBarDefault(context, "Successfully added vehicle");
      viewModel.addVehicleState.value = Idle();
      GoRouter.of(context).pop();
      widget.onRefresh();
    }
  }

  void _handleEditVehicleNavigation() {
    final state = viewModel.editVehicleState.value;
    if (state is Success<RemoteVehicleModel?>) {
      showSnackBarDefault(context, "Successfully edit vehicle");
      viewModel.editVehicleState.value = Idle();
      GoRouter.of(context).pop();
      widget.onRefresh();
    }
  }

  void _updateButtonState() {
    viewModel.errorMessage = null;
    viewModel.validateAddVehicleButton(
      nameController.text,
      yearController.text,
      modelController.text,
      plateController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder:
          (context, _) => Scaffold(
            appBar: MainToolbar(
              title:
                  widget.selectedVehicle != null
                      ? 'edit_vehicle'.tr()
                      : 'add_vehicle'.tr(),
              showBackButton: true,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                _buildSubTitle(),
                const SizedBox(height: 24),
                AppTextFieldDefault(
                  hint: 'enter_vehicle_name'.tr(),
                  label: 'vehicle_name'.tr(),
                  controller: nameController,
                  validator: (value) => null,
                ),
                const SizedBox(height: 16),
                AppDropdownField(
                  label: 'vehicle_maker'.tr(),
                  hint: 'select_vehicle_maker'.tr(),
                  value: viewModel.selectedMaker?.name,
                  onTap: () {
                    _navigateLookupScreen(context);
                  },
                ),

                const SizedBox(height: 16),
                AppTextFieldDefault(
                  hint: 'enter_vehicle_year'.tr(),
                  label: 'vehicle_year'.tr(),
                  controller: yearController,
                  validator: (value) => null,
                ),

                const SizedBox(height: 16),
                AppTextFieldDefault(
                  hint: 'enter_vehicle_model'.tr(),
                  label: 'vehicle_model'.tr(),
                  controller: modelController,
                  validator: (value) => null,
                ),

                const SizedBox(height: 16),
                AppTextFieldDefault(
                  hint: 'enter_vehicle_license_plate'.tr(),
                  label: 'vehicle_license_plate'.tr(),
                  controller: plateController,
                  validator: (value) => null,
                ),

                const SizedBox(height: 24),
                ValueListenableBuilder<ResultState<void>>(
                  valueListenable:
                      widget.selectedVehicle != null
                          ? viewModel.editVehicleState
                          : viewModel.addVehicleState,
                  builder: (context, state, _) {
                    if (state is Loading) {
                      return _buildAddVehicleButton(isLoading: true);
                    }
                    return _buildAddVehicleButton();
                  },
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildAddVehicleButton({bool isLoading = false}) {
    return AppFilledButton(
      label: widget.selectedVehicle != null ? 'edit'.tr() : 'add_vehicle'.tr(),
      isLoading: isLoading,
      isEnabled: viewModel.isButtonEnabled,
      onClick:
          widget.selectedVehicle != null
              ? _onEditVehicleClick
              : _onAddVehicleClick,
    );
  }

  void _onAddVehicleClick() {
    viewModel.addVehicle(
      nameController.text,
      yearController.text,
      plateController.text,
      modelController.text,
    );
  }

  void _onEditVehicleClick() {
    viewModel.editVehicle(
      widget.selectedVehicle?.id ?? 0,
      nameController.text,
      yearController.text,
      plateController.text,
      modelController.text,
    );
  }

  Widget _buildSubTitle() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Text(
      'add_vehicle_sub_title'.tr(),
      textAlign: TextAlign.start,
      style: AppStyles.textSize14.copyWith(color: AppColors.neutral30),
    ),
  );

  void _navigateLookupScreen(BuildContext context) {
    GoRouter.of(context).push(
      AppRoutes.lookupList,
      extra: {
        ConstantVehicles.selectedValue: viewModel.selectedMaker?.id,
        ConstantVehicles.onItemSelected: (Maker item) {
          setState(() {
            viewModel.selectedMaker = item;
          });
          _updateButtonState();
        },
      },
    );
  }

  void checkEditVehicle() {
    if (widget.selectedVehicle != null) {
      nameController.text = widget.selectedVehicle!.name ?? '';
      yearController.text = widget.selectedVehicle!.year?.toString() ?? '';
      modelController.text = widget.selectedVehicle!.model ?? '';
      plateController.text = widget.selectedVehicle!.licensePlate ?? '';
      viewModel.selectedMaker = widget.selectedVehicle!.maker;
      _updateButtonState();
    }
  }
}
