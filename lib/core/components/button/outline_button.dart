import 'package:flutter/material.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';

class AppOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback onClick;
  final TextStyle? textStyle;
  final Color borderColor;
  final bool? isEnabled;
  final EdgeInsetsGeometry containerPadding;
  final EdgeInsetsGeometry contentPadding;

  const AppOutlinedButton(
      {super.key,
      required this.label,
      required this.onClick,
      this.textStyle,
      this.borderColor = AppColors.primary,
      this.containerPadding = const EdgeInsets.only(left: 24, right: 24),
      this.contentPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    final bool canClick = isEnabled == true;
    return Padding(
        padding: containerPadding,
        child: SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: canClick ? onClick : null,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: isEnabled == true ? borderColor : AppColors.neutral30,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: contentPadding
            ),
            child: Text(
              label,
              style: textStyle ??
                  AppStyles.textSize16.copyWith(
                      color: isEnabled == true
                          ? AppColors.primary
                          : AppColors.neutral40,
                      fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }
}
