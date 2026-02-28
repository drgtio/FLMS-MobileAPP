import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:v2x/core/components/button/filled_button.dart';
import 'package:v2x/core/components/button/outline_button.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';
import 'package:v2x/features/drivers/data/remote/response/remote_driver_model.dart';

class DriverItem extends StatelessWidget {
  final RemoteDriverModel item;
  final VoidCallback? onClickEditDriver;
  final VoidCallback? onClickDeleteDriver;

  const DriverItem({
    super.key,
    required this.item,
    this.onClickEditDriver,
    this.onClickDeleteDriver,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = item.active == true;
    final Color statusColor = isActive ? AppColors.green : AppColors.neutral40;
    final String statusLabel = isActive ? 'active'.tr() : 'inactive'.tr();
    final String title =
        (item.fullName ?? '').isNotEmpty
            ? item.fullName!
            : ((item.username ?? '').isNotEmpty ? item.username! : 'driver'.tr());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Material(
        color: AppColors.white,
        elevation: 1.5,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, height: double.infinity, color: statusColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DriverAvatar(name: item.fullName, username: item.username),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyles.textSize14.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '@${item.username ?? '-'}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyles.textSize14.copyWith(
                                    color: AppColors.neutral40,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          _StatusBadge(color: statusColor, label: statusLabel),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if ((item.email ?? '').isNotEmpty)
                            _ChipLabel(
                              icon: Icons.email_outlined,
                              label: item.email ?? '',
                            ),
                          // _ChipLabel(
                          //   icon: Icons.badge_outlined,
                          //   label: '${'type'.tr()}: ${item.type ?? '-'}',
                          // ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if ((item.createdDate ?? '').isNotEmpty)
                            Text(
                              '${'created'.tr()}: ${item.createdDate}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.textSize14.copyWith(
                                color: AppColors.neutral40,
                              ),
                            ),
                          if ((item.lastLoginDate ?? '').isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                '${'last_login'.tr()}: ${item.lastLoginDate}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyles.textSize14.copyWith(
                                  color: AppColors.neutral40,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: AppFilledButton(
                              containerPadding: const EdgeInsets.only(right: 8),
                              contentPadding: const EdgeInsets.all(8),
                              label: 'edit'.tr(),
                              onClick: () => onClickEditDriver?.call(),
                            ),
                          ),
                          Expanded(
                            child: AppOutlinedButton(
                              containerPadding: const EdgeInsets.only(left: 8),
                              borderColor: AppColors.red,
                              textStyle: AppStyles.textSize16.copyWith(
                                color: AppColors.red,
                                fontWeight: FontWeight.bold,
                              ),
                              contentPadding: const EdgeInsets.all(8),
                              label: 'delete_driver'.tr(),
                              onClick: () => onClickDeleteDriver?.call(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DriverAvatar extends StatelessWidget {
  final String? name;
  final String? username;

  const _DriverAvatar({required this.name, required this.username});

  @override
  Widget build(BuildContext context) {
    final base = (name ?? username ?? '').trim();
    final String initial =
        base.isNotEmpty ? base.characters.first.toUpperCase() : '?';

    return CircleAvatar(
      radius: 22,
      backgroundColor: AppColors.secondary.withAlpha(10),
      child: Text(
        initial,
        style: AppStyles.textSize18.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final Color color;
  final String label;

  const _StatusBadge({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.6), width: 0.7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppStyles.textSize14.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ChipLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppStyles.textSize14.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
