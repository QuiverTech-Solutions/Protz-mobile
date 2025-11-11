import 'dart:convert';

import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/api_response.dart';
import '../models/dashboard_data.dart';
import '../models/service_provider.dart';
import '../models/service_request.dart';
import '../utils/app_constants.dart';
import 'token_storage.dart';

/// Main API service class for handling all HTTP requests
///
/// This service provides a centralized way to interact with the backend API
/// with proper error handling, request/response interceptors, and type safety.
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late final Dio _dio;
  bool _isInitialized = false;

  /// Initialize the API service with configuration
  void initialize() {
    if (_isInitialized) return; // Prevent double initialization

    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-API-Version': AppConstants.apiVersion,
      },
    ));

    // Add interceptors
    // Order matters: auth first so logging shows final headers
    _dio.interceptors.add(_createAuthInterceptor());
    _dio.interceptors.add(_createErrorInterceptor());
    _dio.interceptors.add(_createLoggingInterceptor());

    _isInitialized = true;
  }

  /// Get dashboard data for the home screen
  /// Get dashboard data for the home screen
  Future<ApiResponse<DashboardData>> getDashboardData() async {
    if (!_isInitialized) {
      initialize();
    }

    try {
      // Check if user has a valid token before making the API call
      final tokenStorage = TokenStorage.instance;
      final hasValidToken = await tokenStorage.hasValidToken();

      if (!hasValidToken) {
        return ApiResponse.error(
          message: 'User not authenticated',
          statusCode: 401,
        );
      }

      final response = await _dio.get('/users/me');

      if (response.statusCode == 200) {
        final body = response.data;

        DashboardData? dashboardData;
        // If API wraps data, prefer that
        if (body is Map<String, dynamic>) {
          if (body.containsKey('data') && body['data'] is Map<String, dynamic>) {
            dashboardData = DashboardData.fromJson(
                body['data'] as Map<String, dynamic>);
          } else {
            // Server returns raw user object for /users/me
            dashboardData = _buildDashboardDataFromUser(body);
          }
        } else if (body is String) {
          // Some servers return stringified JSON; attempt to parse
          try {
            final parsed = jsonDecode(body);
            if (parsed is Map<String, dynamic>) {
              if (parsed.containsKey('data') &&
                  parsed['data'] is Map<String, dynamic>) {
                dashboardData = DashboardData.fromJson(
                    parsed['data'] as Map<String, dynamic>);
              } else {
                dashboardData = _buildDashboardDataFromUser(parsed);
              }
            }
          } catch (_) {
            // Fall through to error below
          }
        }

        if (dashboardData != null) {
          return ApiResponse.success(
            message: 'Dashboard data retrieved successfully',
            data: dashboardData,
            statusCode: response.statusCode,
          );
        }

        return ApiResponse.error(
          message: 'Unexpected response format from /users/me',
          statusCode: response.statusCode,
        );
      } else {
        final message = response.data is Map<String, dynamic>
            ? (response.data['message']?.toString() ??
                'Failed to load dashboard data')
            : 'Failed to load dashboard data';
        return ApiResponse.error(
          message: message,
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      // If it's a 401 error, clear tokens since they're invalid
      if (e.response?.statusCode == 401) {
        await TokenStorage.instance.clearTokens();
      }
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Convert a raw /users/me JSON into our DashboardData with sensible defaults
  DashboardData _buildDashboardDataFromUser(Map<String, dynamic> userJson) {
    // Compose display name
    final firstName = (userJson['first_name'] ?? '').toString().trim();
    final lastName = (userJson['last_name'] ?? '').toString().trim();
    final name = [firstName, lastName]
        .where((p) => p.isNotEmpty)
        .join(' ')
        .trim();

    final userInfo = UserInfo(
      id: (userJson['id'] ?? userJson['user_id'] ?? '').toString(),
      name: name.isNotEmpty ? name : (userJson['email'] ?? '').toString(),
      email: (userJson['email'] ?? '').toString(),
      phoneNumber: (userJson['phone_number'] ?? '') as String?,
      profileImageUrl: (userJson['profile_photo_url'] ?? '') as String?,
      lastLoginAt: null,
      isVerified:
          (userJson['email_verified'] == true) || (userJson['phone_verified'] == true),
    );

    final wallet = WalletInfo(
      balance: 0.0,
      currency: 'GHS',
      recentTransactions: const [],
      isActive: true,
    );

    final stats = DashboardStats(
      totalOrders: 0,
      completedOrders: 0,
      activeOrders: 0,
      totalSpent: 0.0,
      currency: 'GHS',
      favoriteProviders: 0,
    );

    final availability = ServiceAvailability(
      towingAvailable: true,
      waterDeliveryAvailable: true,
      maintenanceMessage: null,
      estimatedWaitTimes: const {},
    );

    return DashboardData(
      user: userInfo,
      wallet: wallet,
      recentOrders: const [],
      nearbyProviders: const [],
      activeRequests: const [],
      stats: stats,
      promotions: const [],
      serviceAvailability: availability,
    );
  }

  /// Get available service providers by type and location
  Future<ApiResponse<List<ServiceProvider>>> getServiceProviders({
    required String serviceType,
    double? latitude,
    double? longitude,
    double? radius,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'service_type': serviceType,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (radius != null) 'radius': radius,
      };

      final response =
          await _dio.get('/providers', queryParameters: queryParams);

      if (response.statusCode == 200) {
        final List<dynamic> providersJson = response.data['data'];
        final providers = providersJson
            .map((json) => ServiceProvider.fromJson(json))
            .toList();

        return ApiResponse.success(
          message:
              response.data['message'] ?? 'Providers retrieved successfully',
          data: providers,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          message:
              response.data['message'] ?? 'Failed to load service providers',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Create a new service request
  Future<ApiResponse<ServiceRequest>> createServiceRequest({
    required String serviceType,
    required Map<String, dynamic> requestData,
  }) async {
    try {
      final payload = {
        'service_type': serviceType,
        ...requestData,
      };

      final response = await _dio.post('/requests', data: payload);

      if (response.statusCode == 201) {
        final serviceRequest = ServiceRequest.fromJson(response.data['data']);
        return ApiResponse.success(
          message: response.data['message'] ??
              'Service request created successfully',
          data: serviceRequest,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          message:
              response.data['message'] ?? 'Failed to create service request',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Get user's service request history
  Future<ApiResponse<List<ServiceRequest>>> getServiceHistory({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
      };

      final response =
          await _dio.get('/requests/history', queryParameters: queryParams);

      if (response.statusCode == 200) {
        final List<dynamic> requestsJson = response.data['data'];
        final requests =
            requestsJson.map((json) => ServiceRequest.fromJson(json)).toList();

        return ApiResponse.success(
          message: response.data['message'] ??
              'Service history retrieved successfully',
          data: requests,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          message: response.data['message'] ?? 'Failed to load service history',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Update service request status
  Future<ApiResponse<ServiceRequest>> updateServiceRequest({
    required String requestId,
    required Map<String, dynamic> updateData,
  }) async {
    try {
      final response = await _dio.put('/requests/$requestId', data: updateData);

      if (response.statusCode == 200) {
        final serviceRequest = ServiceRequest.fromJson(response.data['data']);
        return ApiResponse.success(
          message: response.data['message'] ??
              'Service request updated successfully',
          data: serviceRequest,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          message:
              response.data['message'] ?? 'Failed to update service request',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Create logging interceptor for debugging
  Interceptor _createLoggingInterceptor() {
    return LogInterceptor(
      requestBody: kDebugMode,
      responseBody: kDebugMode,
      requestHeader: kDebugMode,
      responseHeader: false,
      error: kDebugMode,
      logPrint: (obj) {
        if (kDebugMode) {
          debugPrint('[API] $obj');
        }
      },
    );
  }

  /// Create authentication interceptor
  /// Create authentication interceptor
  Interceptor _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add authentication token if available
        final authHeader = await TokenStorage.instance.getAuthorizationHeader();
        if (authHeader != null) {
          options.headers['Authorization'] = authHeader;
          if (kDebugMode) {
            debugPrint(
                '[API] Added Authorization header: ${authHeader.substring(0, 20)}...');
          }
        } else {
          if (kDebugMode) {
            debugPrint('[API] No authorization token available');
          }
        }

        // Also attach Cookie-based auth to mirror browser behavior
        final cookieHeader = await TokenStorage.instance.getCookieHeader();
        if (cookieHeader != null) {
          options.headers['Cookie'] = cookieHeader;
          if (kDebugMode) {
            debugPrint('[API] Added Cookie header: access_token=<redacted>');
          }
        }

        // Add browser-like headers for compatibility with server behavior
        options.headers['User-Agent'] =
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36';
        options.headers['Referer'] =
            'https://protz-d3f3c6008874.herokuapp.com/docs';
        options.headers['Accept-Language'] = 'en-US,en;q=0.9';

        handler.next(options);
      },
    );
  }

  /// Create error handling interceptor
  Interceptor _createErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        debugPrint('[API Error] ${error.message}');
        handler.next(error);
      },
    );
  }

  /// Handle Dio errors and convert to ApiResponse
  ApiResponse<T> _handleDioError<T>(DioException error) {
    final int? statusCode = error.response?.statusCode;

    String defaultMessage;
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        defaultMessage =
            'Connection timeout. Please check your internet connection.';
        break;
      case DioExceptionType.badResponse:
        defaultMessage = 'Server error occurred';
        break;
      case DioExceptionType.cancel:
        defaultMessage = 'Request was cancelled';
        break;
      case DioExceptionType.connectionError:
        defaultMessage = 'No internet connection. Please check your network.';
        break;
      case DioExceptionType.badCertificate:
        defaultMessage = 'Certificate verification failed';
        break;
      case DioExceptionType.unknown:
      default:
        defaultMessage = 'An unexpected error occurred';
        break;
    }

    final String message = _extractErrorMessage(error.response?.data) ??
        (error.message ?? defaultMessage);

    return ApiResponse.error(
      message: message,
      error: error.message,
      statusCode: statusCode,
    );
  }

  /// Safely extract a message from various server response formats
  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ??
          data['detail']?.toString() ??
          data['error']?.toString();
    }

    if (data is String && data.isNotEmpty) {
      // Attempt to parse as JSON first
      try {
        final parsed = jsonDecode(data);
        if (parsed is Map<String, dynamic>) {
          return parsed['message']?.toString() ??
              parsed['detail']?.toString() ??
              parsed['error']?.toString() ??
              data; // fallback to raw string
        }
      } catch (_) {
        // Not JSON, treat as plain string
        return data;
      }
    }

    return null;
  }
}
