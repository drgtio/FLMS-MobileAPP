import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:v2x/core/components/button/filled_button.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';

class AppErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;

  const AppErrorDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'ok',
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
           const Icon(Icons.error_outline, size: 48, color: AppColors.red),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppStyles.textSize18.copyWith(color: AppColors.red, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppStyles.textSize14.copyWith(color: AppColors.neutral40),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppFilledButton(
              onClick: onPressed ?? () => Navigator.of(context).pop(),
              label: buttonText.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
