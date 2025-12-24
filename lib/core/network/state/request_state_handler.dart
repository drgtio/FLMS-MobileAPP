import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:v2x/core/components/error/app_error_dialog.dart';
import 'package:v2x/core/network/error/error_handler.dart';
import 'package:v2x/core/network/state/result_state.dart';
import 'package:v2x/core/services/networkconnectivity/network_connectivity_service.dart';
import 'package:v2x/main.dart';

class RequestStateHandler {
  static Future<void> run<T>({
    required Future<T?> Function() action,
    required ValueNotifier<ResultState<T?>> stateNotifier,
    bool showPopup = true,
  }) async {
    try {
      stateNotifier.value = Loading<T>();
      final result = await action();
      stateNotifier.value = Success<T?>(result);
      NetworkConnectivityService.instance.markOnline();
    } catch (e) {
      final error = ErrorHandler.handle(e);
      stateNotifier.value = Error<T>(error.message, error: error);
      final dio = error.exception;
      final isNetIssue = (dio.type == DioExceptionType.connectionError ||
          dio.type == DioExceptionType.connectionTimeout ||
          dio.type == DioExceptionType.receiveTimeout ||
          dio.type == DioExceptionType.sendTimeout);

      if (isNetIssue) {
        NetworkConnectivityService.instance.markOffline();
        return;
      }

      final shouldShowPopup = showPopup && error.showErrorDialog == true;
      if (shouldShowPopup) {
        _showPopup();
      }
    }
  }

  static void _showPopup() {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => AppErrorDialog(
            title: 'error'.tr(),
            message: 'error_sub_title'.tr(),
          ),
        );
      }
    });
  }
}
