abstract class NotificationsRepository {
  Future<void> registerDevice({
    required String registrationId,
    required String platform,
  });
}
