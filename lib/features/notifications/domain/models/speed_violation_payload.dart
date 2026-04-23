class SpeedViolationPayload {
  final String eventId;
  final String violationId;
  final int vehicleId;
  final String vehicleName;
  final double latitude;
  final double longitude;
  final double speedKmH;
  final double limitKmH;
  final String provider;
  final String? roadRef;
  final String englishTitle;
  final String englishBody;
  final String arabicTitle;
  final String arabicBody;

  const SpeedViolationPayload({
    required this.eventId,
    required this.violationId,
    required this.vehicleId,
    required this.vehicleName,
    required this.latitude,
    required this.longitude,
    required this.speedKmH,
    required this.limitKmH,
    required this.provider,
    this.roadRef,
    required this.englishTitle,
    required this.englishBody,
    required this.arabicTitle,
    required this.arabicBody,
  });

  static SpeedViolationPayload? tryParse(Map<String, dynamic> data) {
    try {
      return SpeedViolationPayload(
        eventId: data['eventId'] as String? ?? '',
        violationId: data['violationId'] as String? ?? '',
        vehicleId: int.tryParse(data['vehicleId']?.toString() ?? '') ?? 0,
        vehicleName: data['vehicleName'] as String? ?? '',
        latitude: double.tryParse(data['latitude']?.toString() ?? '') ?? 0.0,
        longitude: double.tryParse(data['longitude']?.toString() ?? '') ?? 0.0,
        speedKmH: double.tryParse(data['speedKmH']?.toString() ?? '') ?? 0.0,
        limitKmH: double.tryParse(data['limitKmH']?.toString() ?? '') ?? 0.0,
        provider: data['provider'] as String? ?? '',
        roadRef: data['roadRef'] as String?,
        englishTitle: data['englishTitle'] as String? ?? 'Speed limit exceeded',
        englishBody: data['englishBody'] as String? ?? '',
        arabicTitle: data['arabicTitle'] as String? ?? 'تجاوز حد السرعة',
        arabicBody: data['arabicBody'] as String? ?? '',
      );
    } catch (_) {
      return null;
    }
  }
}
