import 'package:flutter/material.dart';
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/services/fcm/fcm_token_service.dart';
import 'package:v2x/core/theme/app_colors.dart';
import 'package:v2x/core/theme/app_style.dart';
import 'package:v2x/features/notifications/domain/models/speed_violation_payload.dart';

class SpeedViolationBanner extends StatelessWidget {
  const SpeedViolationBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final service = getIt<FcmTokenService>();
    return ValueListenableBuilder<SpeedViolationPayload?>(
      valueListenable: service.incomingNotification,
      builder: (context, payload, _) {
        if (payload == null) return const SizedBox.shrink();
        final isArabic = Localizations.localeOf(context).languageCode == 'ar';
        final title = isArabic ? payload.arabicTitle : payload.englishTitle;
        final body = isArabic ? payload.arabicBody : payload.englishBody;

        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                color: AppColors.primaryDark,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    service.incomingNotification.value = null;
                    getIt<FcmTokenService>().incomingNotification.value = null;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.speed,
                          color: AppColors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                title,
                                style: AppStyles.textSize14.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (body.isNotEmpty)
                                Text(
                                  body,
                                  style: AppStyles.textSize12.copyWith(
                                    color: AppColors.white.withOpacity(0.85),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.white,
                            size: 18,
                          ),
                          onPressed: () =>
                              service.incomingNotification.value = null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
