import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v2x/features/notifications/domain/models/notification_record.dart';
import 'package:v2x/features/notifications/domain/models/speed_violation_payload.dart';
import 'package:v2x/firebase_options.dart';

// Must be top-level — runs in a separate isolate.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (message.data['type'] != 'speed_limit_exceeded') return;

  final payload = SpeedViolationPayload.tryParse(message.data);
  if (payload != null) {
    await _saveToLocalStorage(payload);
  }

  final title = _localizedTitle(message.data);
  final body = _localizedBody(message.data);

  if (Platform.isAndroid) {
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    await plugin.show(
      message.hashCode,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'speed_violations',
          'Speed Violations',
          channelDescription: 'Speed limit violation alerts',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}

Future<void> _saveToLocalStorage(SpeedViolationPayload payload) async {
  const key = 'notification_records';
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(key);
  final List<dynamic> list =
      raw != null && raw.isNotEmpty ? jsonDecode(raw) as List<dynamic> : [];
  final record = NotificationRecord.fromPayload(payload);
  if (list.any((e) => (e as Map<String, dynamic>)['id'] == record.id)) return;
  list.insert(0, record.toJson());
  await prefs.setString(key, jsonEncode(list));
}

String _localizedTitle(Map<String, dynamic> data) {
  final locale = Platform.localeName;
  if (locale.startsWith('ar')) {
    final ar = data['arabicTitle'] as String?;
    if (ar != null && ar.isNotEmpty) return ar;
  }
  return data['englishTitle'] as String? ?? 'Speed limit exceeded';
}

String _localizedBody(Map<String, dynamic> data) {
  final locale = Platform.localeName;
  if (locale.startsWith('ar')) {
    final ar = data['arabicBody'] as String?;
    if (ar != null && ar.isNotEmpty) return ar;
  }
  return data['englishBody'] as String? ?? '';
}
