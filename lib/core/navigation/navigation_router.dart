import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/features/auth/presentation/login/login_screen.dart';
import 'package:v2x/features/auth/presentation/login/login_view_model.dart';
import 'package:v2x/features/auth/presentation/register/register_screen.dart';
import 'package:v2x/features/auth/presentation/register/register_view_model.dart';
import 'package:v2x/features/home/presentation/home_screen.dart';
import 'package:v2x/features/home/presentation/home_view_model.dart';
import 'package:v2x/features/main/presentation/main_screen.dart';
import 'package:v2x/features/main/presentation/main_view_model.dart';
import 'package:v2x/features/splash/splash_screen.dart';
import 'package:v2x/features/vehicles/data/remote/response/remote_vehicle_model.dart';
import 'package:v2x/features/vehicles/domain/utils/constant_vehicles.dart';
import 'package:v2x/features/vehicles/presentation/addeditvehicle/add_edit_vehicle_screen.dart';
import 'package:v2x/features/vehicles/presentation/addeditvehicle/add_edit_vehicle_view_model.dart';
import 'package:v2x/features/vehicles/presentation/lookup/lookup_list_screen.dart';
import 'package:v2x/features/vehicles/presentation/lookup/lookup_list_viewmodel.dart';
import 'package:v2x/features/vehicles/presentation/vehicles_list_screen.dart';
import 'package:v2x/features/vehicles/presentation/vehicles_list_view_model.dart';
import 'package:v2x/main.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.splash,
  navigatorKey: navigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: GlobalKey<NavigatorState>(),
      builder:
          (context, state, child) => ChangeNotifierProvider<MainViewModel>(
            create: (_) => getIt<MainViewModel>(),
            child: MainScreen(child: child),
          ),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          builder: (context, state) {
            return ChangeNotifierProvider<HomeViewModel>(
              create: (_) => getIt<HomeViewModel>(),
              child: const HomeScreen(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.vehicles,
          name: 'vehicles',
          builder: (context, state) {
            return ChangeNotifierProvider<VehiclesListViewModel>(
              create: (_) => getIt<VehiclesListViewModel>(),
              child: const VehiclesListScreen(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.home,
          name: 'drivers',
          builder: (context, state) {
            return ChangeNotifierProvider<HomeViewModel>(
              create: (_) => getIt<HomeViewModel>(),
              child: const HomeScreen(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.more,
          name: 'more',
          builder:
              (context, state) => ChangeNotifierProvider<HomeViewModel>(
                create: (_) => getIt<HomeViewModel>(),
                child: const HomeScreen(),
              ),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder:
          (context, state) => ChangeNotifierProvider<LoginViewModel>(
            create: (_) => getIt<LoginViewModel>(),
            child: const LoginScreen(),
          ),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) {
        return ChangeNotifierProvider<RegisterViewModel>(
          create: (_) => getIt<RegisterViewModel>(),
          child: RegisterScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.lookupList,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;
        final selectedValue = data?[ConstantVehicles.selectedValue] as int?;
        final onItemSelected =
            data?[ConstantVehicles.onItemSelected] as Function(Maker)?;

        return ChangeNotifierProvider<LookupListViewModel>(
          create: (_) => getIt<LookupListViewModel>(),
          child: LookupListScreen(
            title: 'select_vehicle_maker'.tr(),
            selectedValue: selectedValue,
            onItemSelected: onItemSelected ?? (_) {},
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.addVehicle,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;
        final selectedVehicle =
            data?[ConstantVehicles.selectedVehicle] as RemoteVehicleModel?;
        final onRefresh = data?[ConstantVehicles.onRefresh] as Function();
        return ChangeNotifierProvider<AddEditVehicleViewModel>(
          create: (_) => getIt<AddEditVehicleViewModel>(),
          child: AddEditVehicleScreen(
            selectedVehicle: selectedVehicle,
            onRefresh: onRefresh,
          ),
        );
      },
    ),
  ],
);

class AppRoutes {
  static const splash = '/lib/features/splash/presentation';
  static const login = '/lib/features/auth/presentation/login';
  static const register = '/lib/features/auth/presentation/register';
  static const home = '/lib/features/home/presentation';
  static const more = '/lib/features/more/presentation';
  static const vehicles = '/lib/features/vehicles/presentation';
  static const addVehicle = '/lib/features/vehicles/presentation/addeditvehicle';
  static const drivers = '/lib/features/drivers/presentation';
  static const static = '/lib/features/more/presentation/static';
  static const lookupList = '/lib/features/vehicles/presentation/lookup';
  static const contactUs = '/lib/features/more/presentation/contactus';
}
