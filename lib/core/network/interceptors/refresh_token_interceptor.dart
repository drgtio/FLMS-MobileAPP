import 'dart:async';
import 'package:dio/dio.dart';
import 'package:v2x/core/di/service_locator.dart';
import 'package:v2x/core/storage/secure_storage_user.dart';
import 'package:v2x/features/auth/domain/models/user_entity.dart';
import 'package:v2x/core/network/models/base_response.dart'; // <-- adjust path if different

class RefreshTokenInterceptor extends Interceptor {
  final SecureStorageService storageService = getIt<SecureStorageService>();
  final Dio _dio;

  bool _isRefreshing = false;
  final List<Function(String)> _tokenQueue = [];

  RefreshTokenInterceptor(this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip login & refresh API
    if (options.path.contains('user/authenticate') ||
        options.path.contains('user/refreshToken')) {
      return handler.next(options);
    }

    final user = await storageService.getUser();

    if (user != null && user.token?.isNotEmpty == true) {
      options.headers['Authorization'] = 'Bearer ${user.token}';
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Check for application-level 401 in response body
    final data = response.data;
    if (data is Map<String, dynamic> && data['errorCode'] == 401) {
      final requestOptions = response.requestOptions;

      // Skip refresh endpoint to prevent loops
      if (requestOptions.path.contains('user/refreshToken')) {
        return handler.next(response);
      }

      try {
        if (_isRefreshing) {
          final newToken = await _waitForNewToken();
          final retryResponse = await _retryRequest(requestOptions, newToken);
          return handler.resolve(retryResponse);
        }

        _isRefreshing = true;
        final newToken = await _refreshToken();
        _isRefreshing = false;

        final retryResponse = await _retryRequest(requestOptions, newToken);
        return handler.resolve(retryResponse);
      } catch (e) {
        _isRefreshing = false;
        _tokenQueue.clear();
        await storageService.clearUser();
        return handler.next(response);
      }
    }

    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final requestOptions = err.requestOptions;

    // Prevent infinite refresh loops
    if (requestOptions.path.contains('user/refreshToken')) {
      return handler.next(err);
    }

    try {
      // If refresh is already happening → wait for result
      if (_isRefreshing) {
        final newToken = await _waitForNewToken();
        final retryResponse = await _retryRequest(requestOptions, newToken);
        return handler.resolve(retryResponse);
      }

      _isRefreshing = true;

      final newToken = await _refreshToken();

      _isRefreshing = false;

      final retryResponse = await _retryRequest(requestOptions, newToken);
      return handler.resolve(retryResponse);
    } catch (e) {
      _isRefreshing = false;
      _tokenQueue.clear();

      await storageService.clearUser(); // logout user

      return handler.next(err);
    }
  }

  /// -------------------------
  /// REFRESH TOKEN
  /// -------------------------
  Future<String> _refreshToken() async {
    final user = await storageService.getUser();

    if (user == null || user.refreshToken?.isEmpty == true) {
      throw Exception("No refresh token saved");
    }

    final refreshToken = user.refreshToken!;

    // Use separate Dio instance (avoid interceptor loop)
    final refreshDio = Dio(BaseOptions(baseUrl: _dio.options.baseUrl));

    final response = await refreshDio.post('user/refreshToken/$refreshToken');

    // response.data is Map<String, dynamic> → BaseResponse<UserEntity>
    final baseResponse = BaseResponse<UserEntity>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => UserEntity.fromJson(json as Map<String, dynamic>),
    );

    if (baseResponse.success != true || baseResponse.data == null) {
      throw Exception(baseResponse.errorMessage ?? 'Refresh token failed');
    }

    final refreshedUser = baseResponse.data!;
    final newAccessToken = refreshedUser.token ?? '';
    if (newAccessToken.isEmpty) {
      throw Exception('Refresh response has no token');
    }

    // Save updated user from backend (includes new token & refreshToken)
    await storageService.saveUser(refreshedUser);

    // Notify any waiting requests
    for (var callback in _tokenQueue) {
      callback(newAccessToken);
    }
    _tokenQueue.clear();

    return newAccessToken;
  }

  /// -------------------------
  /// RETRY ORIGINAL REQUEST
  /// -------------------------
  Future<Response> _retryRequest(
    RequestOptions requestOptions,
    String newAccessToken,
  ) async {
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $newAccessToken',
      },
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
    );

    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  /// -------------------------
  /// WAIT FOR TOKEN WHILE REFRESHING
  /// -------------------------
  Future<String> _waitForNewToken() {
    final completer = Completer<String>();
    _tokenQueue.add((String token) {
      completer.complete(token);
    });
    return completer.future;
  }
}
