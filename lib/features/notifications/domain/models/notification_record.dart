import 'dart:convert';

import 'package:v2x/features/notifications/domain/models/speed_violation_payload.dart';

class NotificationRecord {
  final String id;
  final SpeedViolationPayload payload;
  final DateTime receivedAt;
  final bool isRead;

  const NotificationRecord({
    required this.id,
    required this.payload,
    required this.receivedAt,
    required this.isRead,
  });

  NotificationRecord copyWith({bool? isRead}) => NotificationRecord(
        id: id,
        payload: payload,
        receivedAt: receivedAt,
        isRead: isRead ?? this.isRead,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'receivedAt': receivedAt.toIso8601String(),
        'isRead': isRead,
        'eventId': payload.eventId,
        'violationId': payload.violationId,
        'vehicleId': payload.vehicleId,
        'vehicleName': payload.vehicleName,
        'latitude': payload.latitude,
        'longitude': payload.longitude,
        'speedKmH': payload.speedKmH,
        'limitKmH': payload.limitKmH,
        'provider': payload.provider,
        'roadRef': payload.roadRef,
        'englishTitle': payload.englishTitle,
        'englishBody': payload.englishBody,
        'arabicTitle': payload.arabicTitle,
        'arabicBody': payload.arabicBody,
      };

  factory NotificationRecord.fromJson(Map<String, dynamic> json) {
    final payload = SpeedViolationPayload(
      eventId: json['eventId'] as String? ?? '',
      violationId: json['violationId'] as String? ?? '',
      vehicleId: (json['vehicleId'] as num?)?.toInt() ?? 0,
      vehicleName: json['vehicleName'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      speedKmH: (json['speedKmH'] as num?)?.toDouble() ?? 0.0,
      limitKmH: (json['limitKmH'] as num?)?.toDouble() ?? 0.0,
      provider: json['provider'] as String? ?? '',
      roadRef: json['roadRef'] as String?,
      englishTitle: json['englishTitle'] as String? ?? '',
      englishBody: json['englishBody'] as String? ?? '',
      arabicTitle: json['arabicTitle'] as String? ?? '',
      arabicBody: json['arabicBody'] as String? ?? '',
    );
    return NotificationRecord(
      id: json['id'] as String? ?? '',
      payload: payload,
      receivedAt: DateTime.tryParse(json['receivedAt'] as String? ?? '') ??
          DateTime.now(),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  static NotificationRecord fromPayload(SpeedViolationPayload payload) =>
      NotificationRecord(
        id: payload.eventId.isNotEmpty
            ? payload.eventId
            : DateTime.now().millisecondsSinceEpoch.toString(),
        payload: payload,
        receivedAt: DateTime.now(),
        isRead: false,
      );

  static List<NotificationRecord> listFromJsonString(String raw) {
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => NotificationRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static String listToJsonString(List<NotificationRecord> records) =>
      jsonEncode(records.map((r) => r.toJson()).toList());
}
