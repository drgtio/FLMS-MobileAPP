import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:v2x/core/components/button/filled_button.dart';
import 'package:v2x/core/components/edittext/edit_text_default.dart';
import 'package:v2x/core/components/edittext/edit_text_password.dart';
import 'package:v2x/core/components/toolbar/main_toolbar.dart';
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/navigation/navigation_router.dart';
import 'package:v2x/core/network/state/result_state.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';
import 'package:v2x/core/utils/snack_bar.dart';
import 'package:v2x/features/auth/domain/models/user_entity.dart';
import 'package:v2x/features/auth/presentation/login/login_view_model.dart';

class LoginScreen extends StatefulWidget {
  final String? redirectAfterAuth;
  const LoginScreen({super.key, this.redirectAfterAuth});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final viewModel = getIt<LoginViewModel>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userNameController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
    viewModel.loginState.addListener(_handleLoginNavigation);
  }

  void _handleLoginNavigation() async {
    final state = viewModel.loginState.value;
    if (state is Success<UserEntity?>) {
      if (state.data == null) return;
      viewModel.saveUser(state.data!);
      showSnackBarDefault(context, "Successfully logged in");
      viewModel.loginState.value = Idle();
      GoRouter.of(context).push(AppRoutes.home);
    }
  }

  void _updateButtonState() {
    viewModel.errorMessage = null;
    viewModel.validateLoginButton(
      userNameController.text,
      passwordController.text,
    );
  }

  @override
  void dispose() {
    viewModel.loginState.removeListener(_handleLoginNavigation);
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onLoginClick() {
    viewModel.login(userNameController.text, passwordController.text);
  }

  Widget _buildLoginButton({bool isLoading = false}) {
    return AppFilledButton(
      label: 'login'.tr(),
      isLoading: isLoading,
      isEnabled: viewModel.isButtonEnabled,
      onClick: _onLoginClick,
    );
  }

  Widget _buildTitle() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Text(
      'title_login'.tr(),
      textAlign: TextAlign.start,
      style: AppStyles.textSize21,
    ),
  );

  Widget _buildSubTitle() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Text(
      'sub_title_login'.tr(),
      textAlign: TextAlign.start,
      style: AppStyles.textSize14.copyWith(color: AppColors.neutral30),
    ),
  );

  Widget _buildCreateAccount() => InkWell(
    onTap: () => GoRouter.of(context).push(AppRoutes.register),
    child: Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      child: Text(
        'create_new_account'.tr(),
        textAlign: TextAlign.center,
        style: AppStyles.textSize16.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else {
            exit(0);
          }
        }
      },
      child: AnimatedBuilder(
        animation: viewModel,
        builder:
            (context, _) => Scaffold(
              backgroundColor: AppColors.white,
              appBar: const MainToolbar(title: '', showBackButton: false),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    _buildTitle(),
                    const SizedBox(height: 8),
                    _buildSubTitle(),
                    const SizedBox(height: 24),
                    AppTextFieldDefault(
                      hint: 'enter_user_name'.tr(),
                      label: 'user_name'.tr(),
                      controller: userNameController,
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
                      valueListenable: viewModel.loginState,
                      builder: (context, state, _) {
                        if (state is Loading) {
                          return _buildLoginButton(isLoading: true);
                        }
                        return _buildLoginButton();
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildCreateAccount(),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
