import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:v2x/core/components/button/filled_button.dart';
import 'package:v2x/core/services/networkconnectivity/network_connectivity_service.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';

class NoInternetOverlay extends StatelessWidget {
  final Widget child;
  const NoInternetOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final svc = NetworkConnectivityService.instance;
    return ValueListenableBuilder<bool>(
      valueListenable: svc.isOffline,
      builder: (_, offline, __) {
        return Stack(
          children: [
            child,
            if (offline)
              Positioned.fill(
                child: Material(
                  color: Colors.white,
                  child: SafeArea(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.wifi_off,
                              size: 72,
                              color: AppColors.neutral30,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'no_internet_connection'.tr(),
                              textAlign: TextAlign.center,
                              style: AppStyles.textSize21.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'check_internet_connection'.tr(),
                              textAlign: TextAlign.center,
                              style: AppStyles.textSize14.copyWith(
                                color: AppColors.neutral30,
                              ),
                            ),
                            const SizedBox(height: 24),
                            AppFilledButton(
                              onClick: () async {
                                await NetworkConnectivityService.instance
                                    .init();
                              },
                              label: 'try_again'.tr(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
