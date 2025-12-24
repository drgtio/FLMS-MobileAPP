import 'package:flutter/material.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';

class AppFilledButton extends StatelessWidget {
  final String label;
  final VoidCallback onClick;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final bool? isEnabled;
  final bool? isLoading;
  final bool fullWidth;
  final double borderRadius;
  final EdgeInsetsGeometry containerPadding;
  final EdgeInsetsGeometry contentPadding;

  const AppFilledButton(
      {super.key,
      required this.label,
      required this.onClick,
      this.backgroundColor = AppColors.primary,
      this.textStyle,
      this.containerPadding = const EdgeInsets.only(left: 24, right: 24),
      this.contentPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      this.borderRadius = 8,
      this.isEnabled = true,
      this.fullWidth = true,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final bool canClick = isEnabled == true && isLoading == false;
    return Padding(
        padding: containerPadding,
        child: SizedBox(
          width: fullWidth ? double.infinity : null,
          child: ElevatedButton(
            
            onPressed: canClick ? onClick : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isEnabled == true ? backgroundColor : AppColors.neutral30,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              padding: contentPadding,
            ),
            child: isLoading == true
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.white),
                    ),
                  )
                : Text(
                    label,
                    style: textStyle ??
                        AppStyles.textSize16.copyWith(
                            color: isEnabled == true
                                ? AppColors.white
                                : AppColors.neutral40,
                            fontWeight: FontWeight.bold),
                  ),
          ),
        ));
  }
}
