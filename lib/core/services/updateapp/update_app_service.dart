import 'dart:async';

enum UpdateAvailability { none, soft, force }

class UpdateAppService {
  UpdateAppService._();
  static final UpdateAppService instance = UpdateAppService._();

  final _controller = StreamController<UpdateAvailability>.broadcast();
  Stream<UpdateAvailability> get stream => _controller.stream;

  bool _isShowing = false;            // prevent multiple dialogs at once
  bool _snoozedForThisSession = false; // reset on cold start only

  void notify(UpdateAvailability type) {
    if (type == UpdateAvailability.none) return;
    if (_snoozedForThisSession) return;
    if (_isShowing) return;
    _controller.add(type);
  }

  void markShowing(bool value) => _isShowing = value;
  void snoozeForThisSession() => _snoozedForThisSession = true;
}
