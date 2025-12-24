import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';

class MainToolbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final IconData backIcon;

  const MainToolbar(
      {super.key,
      required this.title,
      this.showBackButton = true,
      this.actions,
      this.backIcon = Icons.arrow_back});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: AppStyles.textSize18.copyWith(
              fontWeight: FontWeight.bold, color: AppColors.primaryDark),
        ),
        leading: showBackButton
            ? IconButton(
                icon: Icon(backIcon, color: AppColors.primaryDark),
                onPressed: () => GoRouter.of(context).pop(context),
              )
            : null,
        actions: actions,
      ),
    ]);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
