import 'dart:io';

import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/notifiers/locale_notifier.dart';
import 'package:v2x/core/storage/secure_storage_user.dart';

class HeaderInterceptor extends Interceptor {
  HeaderInterceptor();

  final storageService = getIt<SecureStorageService>();
  final localeNotifier = getIt<LocaleNotifier>();
  String? _versionHeader;
  String? _deviceType;

  Future<void> _ensureAppInfoLoaded() async {
    _deviceType = Platform.isAndroid
        ? 'AN'
        : Platform.isIOS
            ? 'IOS'
            : 'AN';

    if (_versionHeader == null) {
      final info = await PackageInfo.fromPlatform();
      _versionHeader = info.version;
    }
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final user = await storageService.getUser();
    final lang = localeNotifier.value;
    await _ensureAppInfoLoaded();

    options.headers.addAll({
      'Content-Type': 'application/json',
      if (user?.token != null)
        'Authorization': 'Bearer ${user!.token}',
      if (user?.refreshToken != null) 'refresh-token': '${user!.refreshToken}',
      'x-device-type': _deviceType,
      'x-app-type': 'C',
      'x-app-version': _versionHeader,
      'Accept-Language': lang.languageCode,
    });

    return super.onRequest(options, handler);
  }
}
