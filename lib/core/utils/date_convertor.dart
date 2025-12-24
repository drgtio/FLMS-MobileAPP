import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/notifiers/locale_notifier.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateConvertor {

  static bool _localized = false;

  static void _ensureLocales() {
    if (_localized) return;
    // Register the locales you need
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    timeago.setLocaleMessages('ar_short', timeago.ArShortMessages());
    timeago.setLocaleMessages('en', timeago.EnMessages());
    timeago.setLocaleMessages('en_short', timeago.EnShortMessages());
    _localized = true;
  }

 static String formatTimeAgo(String? isoDate) {
    _ensureLocales();

    final localeNotifier = getIt<LocaleNotifier>();
    if (isoDate == null) return '-';

    final date = DateTime.tryParse(isoDate);
    if (date == null) return '-';

    // Normalize locale to what timeago expects
    final lang = localeNotifier.value.languageCode.toLowerCase(); // 'ar', 'en', etc.

    return timeago.format(
      date,
      allowFromNow: true,
      locale: lang, // e.g. 'ar' or 'ar_short'
    );
    // Optionally: timeago.setDefaultLocale(timeagoLocale); if you want a global default
  }

}
