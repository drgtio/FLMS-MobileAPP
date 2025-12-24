import 'package:dio/dio.dart';
import 'package:v2x/core/network/error/app_exception.dart';

class ErrorHandler {
  static AppException handle(dynamic error) {
    try {
      if (error is DioException) {
        if (error.type == DioExceptionType.connectionError) {
          return AppException(
            message: 'No internet connection.',
            exception: error,
          );
        }

        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout) {
          return AppException(
            message: 'Connection timeout.',
            exception: error,
          );
        }

        if (error.response != null && error.response!.data is Map<String, dynamic>) {
          final data = error.response!.data;
          
          // Fallback to generic message from backend
          final msg = data['errorMessage']?.toString() ?? 'Unknown API error.';
          return AppException(message: msg, exception: error);
        }

        // DioException but no response or malformed response
        return AppException(
          message: error.message ?? 'Unexpected network error.',
          exception: error,
        );
      }

      // Not a DioException (maybe logical failure or something else)
      return AppException(
        message: 'Unexpected error occurred.',
        exception: DioException(
          requestOptions: RequestOptions(path: ''),
          error: error,
        ),
      );
    } catch (e) {
      // Last layer of defense — prevent crashes inside ErrorHandler
      return AppException(
        message: 'Unexpected error in error handler.',
        exception: DioException(
          requestOptions: RequestOptions(path: ''),
          error: e,
        ),
      );
    }
  }
}
