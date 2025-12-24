import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkConnectivityService {
  NetworkConnectivityService._();
  static final instance = NetworkConnectivityService._();

  final ValueNotifier<bool> isOffline = ValueNotifier<bool>(false);

  // NOTE: v6 returns List<ConnectivityResult>
  StreamSubscription<List<ConnectivityResult>>? _connSub;
  StreamSubscription<InternetStatus>? _reachSub;

  // keep last interface snapshot (list)
  List<ConnectivityResult> _lastConn = const [ConnectivityResult.none];

  final InternetConnection _checker = InternetConnection();

  Future<void> init() async {
    await _connSub?.cancel();
    await _reachSub?.cancel();

    // initial state
    final connList = await Connectivity().checkConnectivity(); // List<ConnectivityResult>
    _lastConn = connList;

    final hasIface = _hasInterface(connList);
    final reachable = await _checker.hasInternetAccess; // bool

    isOffline.value = !hasIface || !reachable;

    // interface changes
    _connSub = Connectivity().onConnectivityChanged.listen((results) async {
      _lastConn = results;
      final hasIfaceNow = _hasInterface(results);
      if (!hasIfaceNow) {
        isOffline.value = true;
      } else {
        final ok = await _checker.hasInternetAccess;
        isOffline.value = !ok;
      }
    });

    // real internet reachability changes
    _reachSub = _checker.onStatusChange.listen((status) {
      final ok = status == InternetStatus.connected;
      final hasIfaceNow = _hasInterface(_lastConn);
      isOffline.value = !hasIfaceNow || !ok;
    });
  }

  bool _hasInterface(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    // offline only if the list contains ONLY 'none'
    return results.any((r) => r != ConnectivityResult.none);
  }

  void dispose() {
    _connSub?.cancel();
    _reachSub?.cancel();
  }

  // Optional manual nudges from your network layer:
  void markOffline() => isOffline.value = true;
  void markOnline() {
    if (_hasInterface(_lastConn)) isOffline.value = false;
  }
}
