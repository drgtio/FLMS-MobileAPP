import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/services/fcm/fcm_token_service.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';
import 'package:v2x/features/main/presentation/main_screen.dart';

class MainToolbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showMenuButton;
  final List<Widget>? actions;
  final IconData backIcon;

  const MainToolbar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.showMenuButton = false,
    this.actions,
    this.backIcon = Icons.arrow_back,
  });

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
        leading: showMenuButton
            ? _MenuButton()
            : showBackButton
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

class _MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: getIt<FcmTokenService>().unreadCount,
      builder: (context, count, _) {
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: AppColors.primaryDark),
              onPressed: () =>
                  MainScreen.scaffoldKey.currentState?.openDrawer(),
            ),
            if (count > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
