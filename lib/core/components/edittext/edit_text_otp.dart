import 'package:flutter/material.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';

class AppTextFieldOtp extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String)? onChangeValue;
  final Color borderColor;
  final String? errorMessage;

  const AppTextFieldOtp({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChangeValue,
    this.errorMessage,
    this.borderColor = AppColors.neutral10,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.phone,
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      maxLength: 1,
      style: AppStyles.textSizeStyle.copyWith(fontSize: 26, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        filled: false,
        counterText: '',
        contentPadding: const EdgeInsets.all(8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: errorMessage != null ? AppColors.red : borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: errorMessage != null ? AppColors.red : borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      onChanged: onChangeValue,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
    );
  }
}
