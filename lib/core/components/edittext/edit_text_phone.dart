import 'package:flutter/material.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';

class AppTextFieldPhone extends StatelessWidget {
  final String hint;
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry containerPadding;
  final Color borderColor;
  final IconData? prefixIcon;
  final String? errorMessage;

  const AppTextFieldPhone({
    super.key,
    required this.hint,
    required this.label,
    required this.controller,
    this.validator,
    this.errorMessage,
    this.prefixIcon,
    this.obscureText = false,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    this.containerPadding = const EdgeInsets.only(left: 24, right: 24),
    this.borderColor = AppColors.neutral10,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: containerPadding,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            label,
            style: AppStyles.textSize14,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.phone,
            style: AppStyles.textSize14,
            maxLength: 10,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              errorText: errorMessage,
              counterText: '',
              errorStyle: AppStyles.textSize12.copyWith(color: AppColors.red),
              hintStyle:
                  AppStyles.textSize14.copyWith(color: AppColors.neutral30),
              filled: false,
              prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
              prefixIconColor: AppColors.primaryDark,
              contentPadding: contentPadding,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: errorMessage != null ? AppColors.red : borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
          ),
        ]));
  }
}
