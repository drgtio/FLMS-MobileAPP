import 'package:flutter/material.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';

class AppTextFieldPassword extends StatefulWidget {
  final String hint;
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry containerPadding;
  final Color borderColor;
  final String? errorMessage;

  const AppTextFieldPassword({
    super.key,
    required this.hint,
    required this.label,
    required this.controller,
    this.validator,
    this.errorMessage,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    this.containerPadding = const EdgeInsets.only(left: 24, right: 24),
    this.borderColor = AppColors.neutral10,
  });

  @override
  State<AppTextFieldPassword> createState() => _AppTextFieldPasswordState();
}

class _AppTextFieldPasswordState extends State<AppTextFieldPassword> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.containerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: AppStyles.textSize14),
          const SizedBox(height: 8),
          TextFormField(
            controller: widget.controller,
            style: AppStyles.textSize14,
            keyboardType: TextInputType.visiblePassword,
            obscureText: _obscure,
            maxLength: 55,
            validator: widget.validator,
            decoration: InputDecoration(
              hintText: widget.hint,
              errorText: widget.errorMessage,
              counterText: '',
              errorStyle:
                  AppStyles.textSize12.copyWith(color: AppColors.red),
              hintStyle:
                  AppStyles.textSize14.copyWith(color: AppColors.neutral30),
              contentPadding: widget.contentPadding,
              filled: false,

              // 🔒 Suffix icon: show/hide password
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.primaryDark,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: widget.errorMessage != null
                      ? AppColors.red
                      : widget.borderColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: widget.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
          ),
        ],
      ),
    );
  }
}
