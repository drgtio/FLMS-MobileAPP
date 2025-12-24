import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:v2x/core/components/button/filled_button.dart';
import 'package:v2x/core/components/edittext/edit_text_default.dart';
import 'package:v2x/core/components/edittext/edit_text_password.dart';
import 'package:v2x/core/components/edittext/edit_text_phone.dart';
import 'package:v2x/core/components/toolbar/main_toolbar.dart';
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/navigation/navigation_router.dart';
import 'package:v2x/core/network/state/result_state.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';
import 'package:v2x/core/utils/snack_bar.dart';
import 'package:v2x/features/auth/domain/models/user_entity.dart';
import 'package:v2x/features/auth/presentation/register/register_view_model.dart';

class RegisterScreen extends StatefulWidget {
  final String? redirectAfterAuth;
  const RegisterScreen({super.key, this.redirectAfterAuth});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final viewModel = getIt<RegisterViewModel>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userNameController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
    firstNameController.addListener(_updateButtonState);
    lastNameController.addListener(_updateButtonState);
    emailController.addListener(_updateButtonState);
    phoneNumberController.addListener(_updateButtonState);
    viewModel.registerState.addListener(_handleRegisterNavigation);
  }

  void _handleRegisterNavigation() async {
    final state = viewModel.registerState.value;
    if (state is Success<UserEntity?>) {
      if (state.data == null) return;
      viewModel.registerState.value = Idle();
      viewModel.saveUser(state.data!);
      showSnackBarDefault(context, "Successfully registered");
      GoRouter.of(context).push(AppRoutes.home);
    }
  }

  void _updateButtonState() {
    viewModel.errorMessage = null;
    viewModel.validateRegisterButton(
      phoneNumberController.text,
      firstNameController.text,
      lastNameController.text,
      emailController.text,
      passwordController.text,
      userNameController.text,
    );
  }

  @override
  void dispose() {
    viewModel.registerState.removeListener(_handleRegisterNavigation);
    userNameController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  void _onRegisterClick() {
    viewModel.register(
      phoneNumberController.text,
      firstNameController.text,
      lastNameController.text,
      emailController.text,
      passwordController.text,
      userNameController.text,
    );
  }

  Widget _buildRegisterButton({bool isLoading = false}) {
    return AppFilledButton(
      label: 'register'.tr(),
      isLoading: isLoading,
      isEnabled: viewModel.isButtonEnabled,
      onClick: _onRegisterClick,
    );
  }

  Widget _buildSubTitle() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Text(
      'sub_title_register'.tr(),
      textAlign: TextAlign.start,
      style: AppStyles.textSize16.copyWith(color: AppColors.neutral30),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder:
          (context, _) => Scaffold(
            backgroundColor: AppColors.white,
            appBar: MainToolbar(title: 'register'.tr(), showBackButton: true),
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
                  AppTextFieldPhone(
                    hint: 'enter_phone_number'.tr(),
                    label: 'phone_number'.tr(),
                    controller: phoneNumberController,
                    validator: (value) => null,
                  ),
                  const SizedBox(height: 16),
                  AppTextFieldDefault(
                    hint: 'enter_user_name'.tr(),
                    label: 'user_name'.tr(),
                    controller: userNameController,
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
                  AppTextFieldPassword(
                    hint: 'enter_password'.tr(),
                    label: 'password'.tr(),
                    errorMessage: viewModel.errorMessage,
                    controller: passwordController,
                    validator: (value) => null,
                  ),
                  const SizedBox(height: 24),
                  ValueListenableBuilder<ResultState<void>>(
                    valueListenable: viewModel.registerState,
                    builder: (context, state, _) {
                      if (state is Loading) {
                        return _buildRegisterButton(isLoading: true);
                      }
                      return _buildRegisterButton();
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
