import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'token_storage.dart';

class DioClient {
  static const String _baseUrl =
      'https://protz-d3f3c6008874.herokuapp.com/api/v1';

  late final Dio _dio;
  final TokenStorage _tokenStorage = TokenStorage.instance;

  DioClient() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Token interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.getAccessToken();
          final tokenType = await _tokenStorage.getTokenType();

          if (kDebugMode) {
            print('[DIO] Request URL: ${options.baseUrl}${options.path}');
            print(
                '[DIO] Retrieved token: ${token != null ? '${token.substring(0, 20)}...' : 'null'}');
            print('[DIO] Retrieved token type: $tokenType');
          }

          if (token != null) {
            // Build Authorization with saved token_type (default to Bearer)
            final scheme = (tokenType == null || tokenType.isEmpty)
                ? 'Bearer'
                : (tokenType.toLowerCase() == 'bearer' ? 'Bearer' : tokenType);
            final authHeader = '$scheme $token';
            options.headers['Authorization'] = authHeader;

            if (kDebugMode) {
              print(
                  '[DIO] Authorization header set: ${authHeader.substring(0, 30)}...');
              print('[DIO] Full headers: ${options.headers}');
            }
          } else {
            if (kDebugMode) {
              print(
                  '[DIO] No token found, proceeding without Authorization header');
            }
          }
          // Also attach Cookie-based auth to mirror browser behavior
          final cookieHeader = await _tokenStorage.getCookieHeader();
          if (cookieHeader != null) {
            options.headers['Cookie'] = cookieHeader;
            if (kDebugMode) {
              print('[DIO] Cookie header set: access_token=<redacted>');
            }
          }

          // Add browser-like headers for compatibility
          options.headers['User-Agent'] =
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36';
          options.headers['Referer'] =
              'https://protz-d3f3c6008874.herokuapp.com/docs';
          options.headers['Accept-Language'] = 'en-US,en;q=0.9';
          handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 unauthorized errors more selectively
          if (error.response?.statusCode == 401) {
            final data = error.response?.data;
            String message = '';
            if (data is Map<String, dynamic>) {
              message =
                  (data['detail'] ?? data['message'] ?? data['error'] ?? '')
                      .toString()
                      .toLowerCase();
            } else if (data is String) {
              message = data.toLowerCase();
            }

            // Only clear tokens when clearly expired/invalid
            final shouldClear = message.contains('expired') ||
                message.contains('invalid credential') ||
                message.contains('invalid token') ||
                message.contains('token expired');

            if (shouldClear) {
              await _tokenStorage.clearTokens();
              if (kDebugMode) {
                print('Token expired or invalid, cleared stored token');
              }
            } else {
              if (kDebugMode) {
                print(
                    '[DIO] 401 received; preserving tokens. Message: $message');
              }
            }
          }
          handler.next(error);
        },
      ),
    );

    // Logging interceptor for debug mode
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
          logPrint: (object) {
            debugPrint('[DIO] $object');
          },
        ),
      );
    }
  }

  // Token management methods for backward compatibility
  Future<void> setToken(String token) async {
    await _tokenStorage.saveToken(
      accessToken: token,
      tokenType: 'Bearer',
    );
  }

  Future<void> clearToken() async {
    await _tokenStorage.clearTokens();
  }

  // GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException error) {
    String message;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout. Please check your internet connection.';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Send timeout. Please try again.';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Receive timeout. Please try again.';
        break;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;

        if (statusCode != null) {
          switch (statusCode) {
            case 400:
              message = responseData?['message'] ?? 'Bad request';
              break;
            case 401:
              message = 'Unauthorized. Please login again.';
              break;
            case 403:
              message =
                  'Forbidden. You don\'t have permission to access this resource.';
              break;
            case 404:
              message = 'Resource not found.';
              break;
            case 422:
              message = responseData?['message'] ?? 'Validation error';
              break;
            case 500:
              message = 'Internal server error. Please try again later.';
              break;
            default:
              message = responseData?['message'] ?? 'Something went wrong';
          }
        } else {
          message = 'Something went wrong';
        }
        break;
      case DioExceptionType.cancel:
        message = 'Request was cancelled';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection. Please check your network.';
        break;
      case DioExceptionType.badCertificate:
        message = 'Certificate error. Please try again.';
        break;
      case DioExceptionType.unknown:
      default:
        message = 'Something went wrong. Please try again.';
        break;
    }

    if (kDebugMode) {
      print('DioError: $message');
      print('Error details: ${error.toString()}');
    }

    return Exception(message);
  }
}
