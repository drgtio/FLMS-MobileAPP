import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/navigation/navigation_router.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/features/splash/splash_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final viewModel = getIt<SplashViewModel>();

  @override
  void initState() {
    super.initState();
    _handleRedirect();
  }

  Future<void> _handleRedirect() async {
    await Future.delayed(const Duration(milliseconds: 800));

    // final hasChosenLang = await hasChosenLanguage();
    if (!mounted) return;
    // if (!hasChosenLang) {
    //   GoRouter.of(context).go(AppRoutes.selectLanguage);
    //   return;
    // }

    final user = await viewModel.getUserModel();

    if (!mounted) return;
    if (user?.token == null) {
      GoRouter.of(context).go(AppRoutes.login);
      return;
    }
    if (!mounted) return;

    GoRouter.of(context).go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: viewModel,
      builder:
          (context, _) => Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Icon(Icons.directions_car, color: AppColors.primary),
              // Image.asset(
              //   'lib/core/assets/res/png/logo_with_buffer.png',
              // ),
            ),
          ),
    );
  }
}
