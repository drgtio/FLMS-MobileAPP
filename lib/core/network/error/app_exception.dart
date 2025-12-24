import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final DioException exception;
  final bool? showErrorDialog;

  AppException(
      {required this.message,
      this.showErrorDialog = true,
      required this.exception});
}
