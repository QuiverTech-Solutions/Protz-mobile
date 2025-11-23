import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'token_storage.dart';
import '../utils/app_constants.dart';

class DioClient {
  static const String _baseUrl = AppConstants.baseUrl;
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(milliseconds: 500);

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
        'ngrok-skip-browser-warning': 'true',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',
      },
      validateStatus: (status) => status != null && status < 500,
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Retry interceptor - handles ngrok interstitial page
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add ngrok bypass headers
          options.headers['ngrok-skip-browser-warning'] = 'true';
          options.headers['Ngrok-Skip-Browser-Warning'] = '69420';
          
          final token = await _tokenStorage.getAccessToken();
          final tokenType = await _tokenStorage.getTokenType();

          if (kDebugMode) {
            print('[DIO] Request URL: ${options.baseUrl}${options.path}');
            print('[DIO] Retrieved token: ${token != null ? '${token.substring(0, 20)}...' : 'null'}');
            print('[DIO] Retrieved token type: $tokenType');
          }

          if (token != null) {
            final scheme = (tokenType == null || tokenType.isEmpty)
                ? 'Bearer'
                : (tokenType.toLowerCase() == 'bearer' ? 'Bearer' : tokenType);
            final authHeader = '$scheme $token';
            options.headers['Authorization'] = authHeader;

            if (kDebugMode) {
              print('[DIO] Authorization header set: ${authHeader.substring(0, 30)}...');
            }
          }
          
          final cookieHeader = await _tokenStorage.getCookieHeader();
          if (cookieHeader != null) {
            options.headers['Cookie'] = cookieHeader;
            if (kDebugMode) {
              print('[DIO] Cookie header set: access_token=<redacted>');
            }
          }

          options.headers['Referer'] = 'https://protz-d3f3c6008874.herokuapp.com/docs';
          options.headers['Accept-Language'] = 'en-US,en;q=0.9';
          
          handler.next(options);
        },
        onResponse: (response, handler) async {
          // Check if response is HTML (ngrok interstitial)
          if (response.data is String) {
            final responseData = response.data as String;
            if (responseData.trim().startsWith('<!DOCTYPE html>') && 
                (responseData.contains('ngrok') || responseData.contains('ERR_NGROK'))) {
              
              if (kDebugMode) {
                print('[DIO] ⚠️ Received ngrok interstitial page - will retry');
              }
              
              // Get retry count from extra data
              final retryCount = response.requestOptions.extra['retryCount'] as int? ?? 0;
              
              if (retryCount < _maxRetries) {
                if (kDebugMode) {
                  print('[DIO] 🔄 Retry attempt ${retryCount + 1}/$_maxRetries');
                }
                
                // Wait before retrying
                await Future.delayed(_retryDelay * (retryCount + 1));
                
                // Clone request options with updated retry count
                final newOptions = response.requestOptions.copyWith(
                  extra: {
                    ...response.requestOptions.extra,
                    'retryCount': retryCount + 1,
                  },
                );
                
                try {
                  // Retry the request
                  final retryResponse = await _dio.fetch(newOptions);
                  handler.resolve(retryResponse);
                  return;
                } catch (e) {
                  if (kDebugMode) {
                    print('[DIO] ❌ Retry failed: $e');
                  }
                  // If retry fails, continue with original error
                }
              } else {
                if (kDebugMode) {
                  print('[DIO] ❌ Max retries reached. ngrok interstitial persists.');
                }
              }
              
              // Reject with custom error after all retries exhausted
              handler.reject(
                DioException(
                  requestOptions: response.requestOptions,
                  response: response,
                  type: DioExceptionType.badResponse,
                  error: Exception(
                    'ngrok interstitial page persists after $_maxRetries retries. '
                    'Please visit ${_baseUrl.replaceAll('/api/v1', '')} in your browser, '
                    'click "Visit Site", then restart the app.'
                  ),
                ),
                true,
              );
              return;
            }
          }
          
          if (kDebugMode) {
            print('[DIO] ✅ Valid JSON response received');
          }
          handler.next(response);
        },
        onError: (error, handler) async {
          // Check if error response is HTML
          if (error.response?.data is String) {
            final responseData = error.response!.data as String;
            if (responseData.contains('<!DOCTYPE html>') && responseData.contains('ngrok')) {
              if (kDebugMode) {
                print('[DIO] ⚠️ Error response is ngrok HTML - will retry');
              }
              
              final retryCount = error.requestOptions.extra['retryCount'] as int? ?? 0;
              
              if (retryCount < _maxRetries) {
                if (kDebugMode) {
                  print('[DIO] 🔄 Retry attempt ${retryCount + 1}/$_maxRetries');
                }
                
                await Future.delayed(_retryDelay * (retryCount + 1));
                
                final newOptions = error.requestOptions.copyWith(
                  extra: {
                    ...error.requestOptions.extra,
                    'retryCount': retryCount + 1,
                  },
                );
                
                try {
                  final retryResponse = await _dio.fetch(newOptions);
                  handler.resolve(retryResponse);
                  return;
                } catch (e) {
                  if (kDebugMode) {
                    print('[DIO] ❌ Retry failed: $e');
                  }
                }
              }
            }
          }
          
          // Handle 401 unauthorized
          if (error.response?.statusCode == 401) {
            final data = error.response?.data;
            String message = '';
            if (data is Map<String, dynamic>) {
              message = (data['detail'] ?? data['message'] ?? data['error'] ?? '')
                  .toString()
                  .toLowerCase();
            } else if (data is String) {
              message = data.toLowerCase();
            }

            final shouldClear = message.contains('expired') ||
                message.contains('invalid credential') ||
                message.contains('invalid token') ||
                message.contains('token expired');

            if (shouldClear) {
              await _tokenStorage.clearTokens();
              if (kDebugMode) {
                print('[DIO] Token expired or invalid, cleared stored token');
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

    // Check if response is HTML (ngrok issue)
    if (error.response?.data is String) {
      final responseData = error.response!.data as String;
      if (responseData.contains('<!DOCTYPE html>') && 
          (responseData.contains('ngrok') || responseData.contains('ERR_NGROK'))) {
        return Exception(
          'Unable to connect to server. The service is showing a security warning page.\n\n'
          'Quick fix: Open ${_baseUrl.replaceAll('/api/v1', '')} in your phone browser, '
          'click "Visit Site", then restart this app.'
        );
      }
    }

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
              message = responseData is Map && responseData.containsKey('message')
                  ? responseData['message']
                  : 'Bad request';
              break;
            case 401:
              message = 'Unauthorized. Please login again.';
              break;
            case 403:
              message = 'Forbidden. You don\'t have permission to access this resource.';
              break;
            case 404:
              message = 'Resource not found.';
              break;
            case 422:
              message = responseData is Map && responseData.containsKey('message')
                  ? responseData['message']
                  : 'Validation error';
              break;
            case 500:
              message = 'Internal server error. Please try again later.';
              break;
            default:
              message = responseData is Map && responseData.containsKey('message')
                  ? responseData['message']
                  : 'Something went wrong';
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