import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:v2x/core/network/interceptors/header_interceptor.dart';
import 'package:v2x/core/network/interceptors/refresh_token_interceptor.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://v2x-backend-app-yumyj.ondigitalocean.app/app/api/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        requestHeader: true,
        error: true,
        logPrint: (obj) => _fullLog(obj),
      ),
    );
    dio.interceptors.add(HeaderInterceptor());
    dio.interceptors.add(RefreshTokenInterceptor(dio));

    return dio;
  }

  /// Splits very long lines + pretty-prints JSON.
  void _fullLog(Object obj, {int chunk = 800}) {
    String msg;

    // Pretty JSON if possible
    try {
      if (obj is Map || obj is List) {
        msg = const JsonEncoder.withIndent('  ').convert(obj);
      } else {
        final s = obj.toString();
        msg = _tryPrettyJsonString(s) ?? s;
      }
    } catch (_) {
      msg = obj.toString();
    }

    // Chunk to avoid truncation (~4KB per line limit on Android logcat)
    for (var i = 0; i < msg.length; i += chunk) {
      final end = (i + chunk < msg.length) ? i + chunk : msg.length;
      final part = msg.substring(i, end);
      // Use debugPrint (respects Flutter’s throttling) OR dev.log (taggable)
      debugPrint(part); // or: dev.log(part, name: tag);
    }
  }

  String? _tryPrettyJsonString(String s) {
    // If starts with JSON sigils, try to decode/encode with indent
    final trimmed = s.trimLeft();
    if (!(trimmed.startsWith('{') || trimmed.startsWith('['))) return null;
    try {
      final decoded = json.decode(s);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {
      return null;
    }
  }
}
