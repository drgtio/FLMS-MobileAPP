import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/navigation/navigation_router.dart';
import 'package:v2x/core/notifiers/locale_notifier.dart';
import 'package:v2x/core/services/fcm/fcm_token_service.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';

class MainScreen extends StatelessWidget {
  static final scaffoldKey = GlobalKey<ScaffoldState>();

  final Widget child;
  const MainScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final localeNotifier = getIt<LocaleNotifier>();
    final fcm = getIt<FcmTokenService>();
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
      key: scaffoldKey,
      drawer: _AppDrawer(fcm: fcm),
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

class _AppDrawer extends StatelessWidget {
  final FcmTokenService fcm;
  const _AppDrawer({required this.fcm});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              color: AppColors.primaryDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      color: AppColors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'V2X Fleet',
                    style: AppStyles.textSize18.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Notifications tile
            ValueListenableBuilder<int>(
              valueListenable: fcm.unreadCount,
              builder: (context, count, _) {
                return ListTile(
                  leading: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.notifications_outlined,
                        color: AppColors.primaryDark,
                        size: 26,
                      ),
                      if (count > 0)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            decoration: const BoxDecoration(
                              color: AppColors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              count > 99 ? '99+' : '$count',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Text(
                    'notifications'.tr(),
                    style: AppStyles.textSize16.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: count > 0
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : null,
                  onTap: () {
                    Navigator.of(context).pop();
                    context.push(AppRoutes.notifications);
                  },
                );
              },
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
          ],
        ),
      ),
    );
  }
}
