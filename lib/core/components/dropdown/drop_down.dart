import 'package:flutter/material.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';

class AppDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final String hint;
  final VoidCallback onTap;
  final Color borderColor;
  final bool? isEnabled;
  final EdgeInsetsGeometry containerPadding;
  final EdgeInsetsGeometry contentPadding;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.hint,
    this.value,
    required this.onTap,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    this.containerPadding = const EdgeInsets.only(left: 24, right: 24),
    this.borderColor = AppColors.neutral10,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: containerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppStyles.textSize14),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color:
                        isEnabled == true ? borderColor : AppColors.neutral10,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color:
                        isEnabled == true ? borderColor : AppColors.neutral10,
                  ),
                ),
                contentPadding: contentPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value ?? hint,
                    style: AppStyles.textSize14.copyWith(
                      color:
                          value == null
                              ? AppColors.neutral30
                              : AppColors.primaryDark,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.neutral40,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
