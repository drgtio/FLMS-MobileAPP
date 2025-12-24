import 'package:flutter/material.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';

class EmptyView extends StatelessWidget {
  final Future<void> Function() onRefresh;
  const EmptyView({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 120),
          Icon(Icons.directions_car, size: 56, color: AppColors.primary),
          SizedBox(height: 12),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'No vehicles yet.\nPull down to refresh.',
                textAlign: TextAlign.center,
                style: AppStyles.textSize16.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ),
          SizedBox(height: 120),
        ],
      ),
    );
  }
}
