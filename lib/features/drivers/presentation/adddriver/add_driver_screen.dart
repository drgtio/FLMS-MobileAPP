import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:v2x/core/components/button/filled_button.dart';
import 'package:v2x/core/components/edittext/edit_text_default.dart';
import 'package:v2x/core/components/toolbar/main_toolbar.dart';
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/network/state/result_state.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';
import 'package:v2x/core/utils/snack_bar.dart';
import 'package:v2x/features/drivers/data/remote/response/remote_driver_model.dart';
import 'package:v2x/features/drivers/presentation/adddriver/add_driver_view_model.dart';

class AddDriverScreen extends StatefulWidget {
  final Function() onRefresh;
  final RemoteDriverModel? selectedDriver;

  const AddDriverScreen({super.key, required this.onRefresh, this.selectedDriver});

  @override
  State<AddDriverScreen> createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  final viewModel = getIt<AddDriverViewModel>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    firstNameController.addListener(_updateButtonState);
    lastNameController.addListener(_updateButtonState);
    emailController.addListener(_updateButtonState);
    usernameController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
    viewModel.addDriverState.addListener(_handleAddDriverNavigation);
    viewModel.updateDriverState.addListener(_handleUpdateDriverNavigation);
    _prefillIfEditMode();
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleAddDriverNavigation() {
    final state = viewModel.addDriverState.value;
    if (state is Success<bool?>) {
      showSnackBarDefault(context, 'driver_added_successfully'.tr());
      viewModel.addDriverState.value = Idle();
      GoRouter.of(context).pop();
      widget.onRefresh();
    }
  }

  void _handleUpdateDriverNavigation() {
    final state = viewModel.updateDriverState.value;
    if (state is Success<bool?>) {
      showSnackBarDefault(context, 'driver_updated_successfully'.tr());
      viewModel.updateDriverState.value = Idle();
      GoRouter.of(context).pop();
      widget.onRefresh();
    }
  }

  void _updateButtonState() {
    viewModel.errorMessage = null;
    viewModel.validateAddDriverButton(
      firstNameController.text,
      lastNameController.text,
      emailController.text,
      usernameController.text,
      passwordController.text,
      widget.selectedDriver != null,
    );
  }

  void _onSubmitClick() {
    if (widget.selectedDriver != null) {
      viewModel.updateDriver(
        widget.selectedDriver?.id ?? '',
        firstNameController.text,
        lastNameController.text,
        emailController.text,
        usernameController.text,
        passwordController.text.trim().isEmpty ? null : passwordController.text,
      );
      return;
    }

    viewModel.addDriver(
      firstNameController.text,
      lastNameController.text,
      emailController.text,
      usernameController.text,
      passwordController.text,
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
                  widget.selectedDriver != null
                      ? 'edit_driver'.tr()
                      : 'add_driver'.tr(),
              showBackButton: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  _buildSubTitle(),
                  const SizedBox(height: 24),
                  AppTextFieldDefault(
                    hint: 'enter_first_name'.tr(),
                    label: 'first_name'.tr(),
                    controller: firstNameController,
                    validator: (value) => null,
                  ),
                  const SizedBox(height: 16),
                  AppTextFieldDefault(
                    hint: 'enter_last_name'.tr(),
                    label: 'last_name'.tr(),
                    controller: lastNameController,
                    validator: (value) => null,
                  ),
                  const SizedBox(height: 16),
                  AppTextFieldDefault(
                    hint: 'enter_email'.tr(),
                    label: 'email'.tr(),
                    controller: emailController,
                    validator: (value) => null,
                  ),
                  const SizedBox(height: 16),
                  AppTextFieldDefault(
                    hint: 'enter_user_name'.tr(),
                    label: 'user_name'.tr(),
                    controller: usernameController,
                    validator: (value) => null,
                  ),
                  const SizedBox(height: 16),
                  AppTextFieldDefault(
                    hint:
                        widget.selectedDriver != null
                            ? 'enter_new_password'.tr()
                            : 'enter_password'.tr(),
                    label:
                        widget.selectedDriver != null
                            ? 'new_password'.tr()
                            : 'password'.tr(),
                    controller: passwordController,
                    obscureText: true,
                    validator: (value) => null,
                  ),
                  const SizedBox(height: 24),
                  ValueListenableBuilder<ResultState<bool?>>(
                    valueListenable:
                        widget.selectedDriver != null
                            ? viewModel.updateDriverState
                            : viewModel.addDriverState,
                    builder: (context, state, _) {
                      return AppFilledButton(
                        label:
                            widget.selectedDriver != null
                                ? 'edit'.tr()
                                : 'add_driver'.tr(),
                        isLoading: state is Loading,
                        isEnabled: viewModel.isButtonEnabled,
                        onClick: _onSubmitClick,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildSubTitle() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Text(
      widget.selectedDriver != null
          ? 'edit_driver_sub_title'.tr()
          : 'add_driver_sub_title'.tr(),
      textAlign: TextAlign.start,
      style: AppStyles.textSize14.copyWith(color: AppColors.neutral30),
    ),
  );

  void _prefillIfEditMode() {
    final selectedDriver = widget.selectedDriver;
    if (selectedDriver == null) return;

    final fullName = (selectedDriver.fullName ?? '').trim();
    final parts = fullName.isEmpty ? <String>[] : fullName.split(RegExp(r'\s+'));
    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    firstNameController.text = firstName;
    lastNameController.text = lastName;
    emailController.text = selectedDriver.email ?? '';
    usernameController.text = selectedDriver.username ?? '';
    _updateButtonState();
  }
}
