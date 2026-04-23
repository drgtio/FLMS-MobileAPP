import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/navigation/navigation_router.dart';
import 'package:v2x/core/storage/secure_storage_user.dart';
import 'package:v2x/features/notifications/data/local/notification_local_repository.dart';
import 'package:v2x/features/notifications/domain/models/speed_violation_payload.dart';
import 'package:v2x/features/notifications/domain/usecases/register_device_use_case.dart';

@lazySingleton
class FcmTokenService {
  final SecureStorageService _storage;
  final NotificationLocalRepository _localRepo = NotificationLocalRepository();
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _pendingToken;

  final ValueNotifier<SpeedViolationPayload?> incomingNotification =
      ValueNotifier(null);
  final ValueNotifier<int> unreadCount = ValueNotifier(0);

  FcmTokenService(this._storage);

  Future<void> init() async {
    await _createAndroidChannel();
    await _localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (_) => _navigateToVehicles(),
    );

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    _pendingToken = await FirebaseMessaging.instance.getToken();

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      _pendingToken = newToken;
      _tryRegisterToken(newToken);
    });

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    _handleInitialMessage();
    _refreshUnreadCount();
  }

  Future<void> registerAfterLogin() async {
    final token = _pendingToken;
    if (token == null || token.isEmpty) return;
    await _tryRegisterToken(token);
  }

  Future<void> _tryRegisterToken(String token) async {
    final user = await _storage.getUser();
    if (user?.token == null) return;

    try {
      final useCase = getIt<RegisterDeviceUseCase>();
      await useCase(
        registrationId: token,
        platform: Platform.isAndroid ? 'Android' : 'IOS',
      );
      debugPrint('[FCM] Token registered successfully');
    } catch (e) {
      debugPrint('[FCM] Token registration failed: $e — retrying in 5s');
      Future.delayed(
        const Duration(seconds: 5),
        () => _tryRegisterToken(token),
      );
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    if (message.data['type'] != 'speed_limit_exceeded') return;
    final payload = SpeedViolationPayload.tryParse(message.data);
    if (payload == null) return;
    incomingNotification.value = payload;
    _localRepo.save(payload).then((_) => _refreshUnreadCount());
    Future.delayed(const Duration(seconds: 5), () {
      if (incomingNotification.value == payload) {
        incomingNotification.value = null;
      }
    });
  }

  Future<void> _refreshUnreadCount() async {
    unreadCount.value = await _localRepo.unreadCount();
  }

  Future<void> refreshUnreadCount() => _refreshUnreadCount();

  void _handleNotificationTap(RemoteMessage message) {
    if (message.data['type'] != 'speed_limit_exceeded') return;
    _navigateToVehicles();
  }

  void _navigateToVehicles() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router.go(AppRoutes.vehicles);
    });
  }

  Future<void> _handleInitialMessage() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message == null) return;
    if (message.data['type'] != 'speed_limit_exceeded') return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToVehicles();
    });
  }

  Future<void> _createAndroidChannel() async {
    if (!Platform.isAndroid) return;
    const channel = AndroidNotificationChannel(
      'speed_violations',
      'Speed Violations',
      description: 'Speed limit violation alerts',
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }
}
