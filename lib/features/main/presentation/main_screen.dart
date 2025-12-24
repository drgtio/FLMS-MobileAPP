import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/navigation/navigation_router.dart';
import 'package:v2x/core/notifiers/locale_notifier.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';

class MainScreen extends StatelessWidget {
  final Widget child;
  const MainScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final localeNotifier = getIt<LocaleNotifier>();
    final String currentLocation =
        GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;
    int currentIndex = 0;
    if (currentLocation.contains('vehicles') == true) {
      currentIndex = 1;
    }
    if (currentLocation.contains('drivers') == true) {
      currentIndex = 2;
    }
    if (currentLocation.contains('more') == true) {
      currentIndex = 3;
    }
    return Scaffold(
      body: child,
      bottomNavigationBar: ValueListenableBuilder<Locale>(
        valueListenable: localeNotifier,
        builder: (context, _, __) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.white,
            unselectedItemColor: AppColors.neutral30,
            selectedItemColor: AppColors.primary,
            selectedLabelStyle: AppStyles.textSize14.copyWith(
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: AppStyles.textSize14,
            currentIndex: currentIndex,
            onTap: (index) {
              switch (index) {
                case 0:
                  context.go(AppRoutes.home);
                  break;
                case 1:
                  context.go(AppRoutes.vehicles);
                  break;
                case 2:
                  context.go(AppRoutes.drivers);
                  break;
                case 3:
                  context.go(AppRoutes.more);
                  break;
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                label: 'home'.tr(),
                activeIcon: const Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.drive_eta_outlined),
                label: 'vehicles'.tr(),
                activeIcon: const Icon(Icons.drive_eta),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.people_outline),
                label: 'drivers'.tr(),
                activeIcon: const Icon(Icons.people),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.more_horiz_outlined),
                label: 'more'.tr(),
                activeIcon: const Icon(Icons.more_horiz),
              ),
            ],
          );
        },
      ),
    );
  }
}
