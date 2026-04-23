import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/services/fcm/fcm_token_service.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';
import 'package:v2x/features/notifications/domain/models/notification_record.dart';
import 'package:v2x/features/notifications/presentation/notifications_view_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationsViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = NotificationsViewModel();
    _vm.load().then((_) {
      // Reset badge after loading
      getIt<FcmTokenService>().refreshUnreadCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _vm,
      child: Consumer<NotificationsViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: AppColors.neutral2,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'notifications'.tr(),
                style: AppStyles.textSize18.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                if (vm.unreadCount > 0)
                  TextButton(
                    onPressed: () async {
                      await vm.markAllAsRead();
                      getIt<FcmTokenService>().refreshUnreadCount();
                    },
                    child: Text(
                      'mark_all_read'.tr(),
                      style: AppStyles.textSize12.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            body: vm.records.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    itemCount: vm.records.length,
                    itemBuilder: (context, index) {
                      return _NotificationCard(
                        record: vm.records[index],
                        onDismiss: () => vm.delete(vm.records[index].id),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.neutral5,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              size: 40,
              color: AppColors.neutral30,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'no_notifications'.tr(),
            style: AppStyles.textSize16.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.neutral40,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'no_notifications_subtitle'.tr(),
            style: AppStyles.textSize12.copyWith(color: AppColors.neutral30),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationRecord record;
  final VoidCallback onDismiss;

  const _NotificationCard({
    required this.record,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final title = isArabic ? record.payload.arabicTitle : record.payload.englishTitle;
    final body = isArabic ? record.payload.arabicBody : record.payload.englishBody;

    return Dismissible(
      key: Key(record.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: AppColors.white, size: 24),
      ),
      onDismissed: (_) => onDismiss(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: record.isRead
              ? AppColors.white
              : AppColors.primary.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(
              color: record.isRead ? Colors.transparent : AppColors.primary,
              width: 3,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.speed,
                  color: AppColors.red,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: AppStyles.textSize14.copyWith(
                              fontWeight: record.isRead
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!record.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 6, top: 4),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    if (body.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        body,
                        style: AppStyles.textSize12.copyWith(
                          color: AppColors.neutral40,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.directions_car_outlined,
                          size: 13,
                          color: AppColors.neutral30,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          record.payload.vehicleName,
                          style: AppStyles.textSize12.copyWith(
                            color: AppColors.neutral30,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          timeago.format(record.receivedAt),
                          style: AppStyles.textSize12.copyWith(
                            color: AppColors.neutral30,
                          ),
                        ),
                      ],
                    ),
                    if (record.payload.speedKmH > 0) ...[
                      const SizedBox(height: 6),
                      _SpeedChip(
                        speed: record.payload.speedKmH,
                        limit: record.payload.limitKmH,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpeedChip extends StatelessWidget {
  final double speed;
  final double limit;

  const _SpeedChip({required this.speed, required this.limit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.speed, size: 12, color: AppColors.red),
          const SizedBox(width: 4),
          Text(
            '${speed.toStringAsFixed(0)} / ${limit.toStringAsFixed(0)} km/h',
            style: AppStyles.textSize12.copyWith(
              color: AppColors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
