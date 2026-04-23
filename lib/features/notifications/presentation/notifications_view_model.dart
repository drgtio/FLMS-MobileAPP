import 'package:flutter/foundation.dart';
import 'package:v2x/features/notifications/data/local/notification_local_repository.dart';
import 'package:v2x/features/notifications/domain/models/notification_record.dart';

class NotificationsViewModel extends ChangeNotifier {
  final NotificationLocalRepository _repo = NotificationLocalRepository();

  List<NotificationRecord> _records = [];
  List<NotificationRecord> get records => _records;

  int get unreadCount => _records.where((r) => !r.isRead).length;

  Future<void> load() async {
    _records = await _repo.getAll();
    notifyListeners();
  }

  Future<void> markAllAsRead() async {
    await _repo.markAllAsRead();
    _records = _records.map((r) => r.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    _records.removeWhere((r) => r.id == id);
    notifyListeners();
  }
}
