import 'package:shared_preferences/shared_preferences.dart';
import 'package:v2x/features/notifications/domain/models/notification_record.dart';
import 'package:v2x/features/notifications/domain/models/speed_violation_payload.dart';

class NotificationLocalRepository {
  static const _key = 'notification_records';

  Future<List<NotificationRecord>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      return NotificationRecord.listFromJsonString(raw);
    } catch (_) {
      return [];
    }
  }

  Future<void> save(SpeedViolationPayload payload) async {
    final records = await getAll();
    final record = NotificationRecord.fromPayload(payload);
    // Deduplicate by id
    if (records.any((r) => r.id == record.id)) return;
    records.insert(0, record);
    await _persist(records);
  }

  Future<void> markAsRead(String id) async {
    final records = await getAll();
    final updated = records
        .map((r) => r.id == id ? r.copyWith(isRead: true) : r)
        .toList();
    await _persist(updated);
  }

  Future<void> markAllAsRead() async {
    final records = await getAll();
    final updated = records.map((r) => r.copyWith(isRead: true)).toList();
    await _persist(updated);
  }

  Future<void> delete(String id) async {
    final records = await getAll();
    records.removeWhere((r) => r.id == id);
    await _persist(records);
  }

  Future<int> unreadCount() async {
    final records = await getAll();
    return records.where((r) => !r.isRead).length;
  }

  Future<void> _persist(List<NotificationRecord> records) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, NotificationRecord.listToJsonString(records));
  }
}
