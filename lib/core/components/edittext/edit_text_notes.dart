import 'package:flutter/material.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';

class AppTextFieldNotes extends StatelessWidget {
  final String hint;
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry containerPadding;
  final Color borderColor;
  final String? errorMessage;

  const AppTextFieldNotes({
    super.key,
    required this.hint,
    required this.label,
    required this.controller,
    this.validator,
    this.errorMessage,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    this.containerPadding = const EdgeInsets.only(left: 16, right: 16),
    this.borderColor = AppColors.neutral10,
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
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.multiline,
            style: AppStyles.textSize14,
            maxLines: 4,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              errorText: errorMessage,
              errorStyle: AppStyles.textSize12.copyWith(color: AppColors.red),
              hintStyle:
                  AppStyles.textSize14.copyWith(color: AppColors.neutral30),
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
        ],
      ),
    );
  }
}
