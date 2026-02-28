import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';

class EmptyView extends StatelessWidget {
  final Future<void> Function() onRefresh;
  const EmptyView({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          const Icon(Icons.people_alt_outlined, size: 56, color: AppColors.primary),
          const SizedBox(height: 12),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'no_drivers_yet'.tr(),
                textAlign: TextAlign.center,
                style: AppStyles.textSize16.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
