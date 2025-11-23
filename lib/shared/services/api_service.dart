import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/api_response.dart';
import '../models/dashboard_data.dart';
import '../models/service_provider.dart';
import '../models/location_tracking.dart';
import '../models/service_request.dart';
import '../models/service_type.dart';
import '../models/towing_type.dart';
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
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(milliseconds: 500);

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
        // CRITICAL: ngrok bypass headers
        'ngrok-skip-browser-warning': '69420',
        'Ngrok-Skip-Browser-Warning': 'true',
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',
      },
      validateStatus: (status) => status != null && status < 500,
    ));

    // Add interceptors
    // Order matters: ngrok handler first, then auth, then error, then logging
    _dio.interceptors.add(_createNgrokRetryInterceptor());
    _dio.interceptors.add(_createAuthInterceptor());
    _dio.interceptors.add(_createErrorInterceptor());
    _dio.interceptors.add(_createLoggingInterceptor());

    _isInitialized = true;
  }

  /// Refresh runtime configuration if constants changed (e.g., baseUrl)
  void refreshConfigIfNeeded() {
    if (!_isInitialized) {
      initialize();
      return;
    }
    if (_dio.options.baseUrl != AppConstants.baseUrl) {
      _dio.options.baseUrl = AppConstants.baseUrl;
    }
    _dio.options.connectTimeout = AppConstants.apiTimeout;
    _dio.options.receiveTimeout = AppConstants.apiTimeout;
    _dio.options.sendTimeout = AppConstants.apiTimeout;
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-API-Version': AppConstants.apiVersion,
      'ngrok-skip-browser-warning': '69420',
      'Ngrok-Skip-Browser-Warning': 'true',
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',
      ..._dio.options.headers,
    };
  }

  /// Create ngrok retry interceptor (handles HTML interstitial pages)
  Interceptor _createNgrokRetryInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        // Ensure ngrok bypass headers are ALWAYS present
        options.headers['ngrok-skip-browser-warning'] = '69420';
        options.headers['Ngrok-Skip-Browser-Warning'] = 'true';
        handler.next(options);
      },
      onResponse: (response, handler) async {
        // Check if response is HTML (ngrok interstitial)
        if (response.data is String) {
          final responseData = response.data as String;
          if (responseData.trim().startsWith('<!DOCTYPE html>') &&
              (responseData.contains('ngrok') ||
                  responseData.contains('ERR_NGROK'))) {
            if (kDebugMode) {
              debugPrint(
                  '[API] ⚠️ Received ngrok interstitial page - will retry');
            }

            // Get retry count
            final retryCount =
                response.requestOptions.extra['retryCount'] as int? ?? 0;

            if (retryCount < _maxRetries) {
              if (kDebugMode) {
                debugPrint(
                    '[API] 🔄 Retry attempt ${retryCount + 1}/$_maxRetries');
              }

              // Wait before retrying
              await Future.delayed(_retryDelay * (retryCount + 1));

              // Clone request with updated retry count
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
                  debugPrint('[API] ❌ Retry failed: $e');
                }
              }
            } else {
              if (kDebugMode) {
                debugPrint(
                    '[API] ❌ Max retries reached. ngrok interstitial persists.');
              }
            }

            // Reject with custom error after all retries exhausted
            handler.reject(
              DioException(
                requestOptions: response.requestOptions,
                response: response,
                type: DioExceptionType.badResponse,
                error: Exception(
                    'Unable to connect to server. The service is showing a security warning page.\n\n'
                    'Quick fix: Open ${AppConstants.baseUrl.replaceAll('/api/v1', '')} in your phone browser, '
                    'click "Visit Site", then restart this app.'),
              ),
              true,
            );
            return;
          }
        }

        if (kDebugMode) {
          debugPrint('[API] ✅ Valid response received');
        }
        handler.next(response);
      },
      onError: (error, handler) async {
        // Check if error response is HTML
        if (error.response?.data is String) {
          final responseData = error.response!.data as String;
          if (responseData.contains('<!DOCTYPE html>') &&
              responseData.contains('ngrok')) {
            if (kDebugMode) {
              debugPrint('[API] ⚠️ Error response is ngrok HTML - will retry');
            }

            final retryCount =
                error.requestOptions.extra['retryCount'] as int? ?? 0;

            if (retryCount < _maxRetries) {
              if (kDebugMode) {
                debugPrint(
                    '[API] 🔄 Retry attempt ${retryCount + 1}/$_maxRetries');
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
                  debugPrint('[API] ❌ Retry failed: $e');
                }
              }
            }
          }
        }

        handler.next(error);
      },
    );
  }

  /// Create authentication interceptor
  Interceptor _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Ensure ngrok headers are present (double insurance)
        options.headers['ngrok-skip-browser-warning'] = '69420';
        options.headers['Ngrok-Skip-Browser-Warning'] = 'true';

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
        if (kDebugMode) {
          debugPrint('[API Error] ${error.message}');
          debugPrint('[API Error Type] ${error.type}');
          if (error.response != null) {
            debugPrint('[API Error Status] ${error.response?.statusCode}');
            debugPrint('[API Error Data] ${error.response?.data}');
          }
        }
        handler.next(error);
      },
    );
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
          if (body.containsKey('data') &&
              body['data'] is Map<String, dynamic>) {
            dashboardData =
                DashboardData.fromJson(body['data'] as Map<String, dynamic>);
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
    final name =
        [firstName, lastName].where((p) => p.isNotEmpty).join(' ').trim();

    final userInfo = UserInfo(
      id: (userJson['id'] ?? userJson['user_id'] ?? '').toString(),
      name: name.isNotEmpty ? name : (userJson['email'] ?? '').toString(),
      email: (userJson['email'] ?? '').toString(),
      phoneNumber: (userJson['phone_number'] ?? '') as String?,
      profileImageUrl: (userJson['profile_photo_url'] ?? '') as String?,
      lastLoginAt: null,
      isVerified: (userJson['email_verified'] == true) ||
          (userJson['phone_verified'] == true),
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

  /// Get active service types
  Future<ApiResponse<List<ServiceTypePublic>>> getActiveServiceTypes() async {
    try {
      final response = await _dio.get('/service-types/active');
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as List<dynamic>
            : (response.data as List<dynamic>);
        final list = items
            .map((e) => ServiceTypePublic.fromJson(e as Map<String, dynamic>))
            .toList();
        return ApiResponse.success(
          message: 'Active service types retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load active service types',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<ServiceTypePublic>> getServiceTypeByCode(
      String code) async {
    try {
      final response = await _dio.get('/service-types/code/$code');
      if (response.statusCode == 200) {
        final Map<String, dynamic> item = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        final st = ServiceTypePublic.fromJson(item);
        return ApiResponse.success(
          message: 'Service type retrieved successfully',
          data: st,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load service type',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Get active towing types
  Future<ApiResponse<List<TowingTypePublic>>> getActiveTowingTypes() async {
    try {
      final response = await _dio.get('/towing-types/active');
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as List<dynamic>
            : (response.data as List<dynamic>);
        final list = items
            .map((e) => TowingTypePublic.fromJson(e as Map<String, dynamic>))
            .toList();
        return ApiResponse.success(
          message: 'Active towing types retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load active towing types',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Get active providers (new endpoint per docs)
  Future<ApiResponse<List<ServiceProvider>>> getActiveProviders({
    required String serviceTypeId,
    double? latitude,
    double? longitude,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'service_type_id': serviceTypeId,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (limit != null) 'limit': limit,
      };
      final response = await _dio.get('/service-providers/active',
          queryParameters: queryParams);
      if (response.statusCode == 200) {
        final List<dynamic> providersJson =
            response.data is Map<String, dynamic>
                ? (response.data['data'] ?? response.data) as List<dynamic>
                : (response.data as List<dynamic>);
        final providers = providersJson
            .map((json) => _mapBackendProvider(json as Map<String, dynamic>))
            .toList();
        return ApiResponse.success(
          message: 'Active providers retrieved successfully',
          data: providers,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load active providers',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  ServiceProvider _mapBackendProvider(Map<String, dynamic> json) {
    final id = (json['id'] ?? '').toString();
    final name = (json['business_name'] ?? 'Provider').toString();
    final isAvailable = json['is_available'] == true;
    final ratingStr = (json['rating'] ?? '0').toString();
    final rating = double.tryParse(ratingStr) ?? 0.0;
    final latStr = (json['current_latitude'] ?? '').toString();
    final lngStr = (json['current_longitude'] ?? '').toString();
    final lat = double.tryParse(latStr);
    final lng = double.tryParse(lngStr);

    return ServiceProvider(
      id: id,
      name: name,
      serviceType: '',
      phoneNumber: '',
      email: null,
      address: '',
      currentLocation: (lat != null && lng != null)
          ? LocationCoordinates(latitude: lat, longitude: lng)
          : null,
      serviceAreas: const [],
      basePrice: 0,
      pricePerUnit: 0,
      currency: 'GHS',
      rating: rating,
      reviewCount: (json['total_completed_jobs'] is int)
          ? json['total_completed_jobs'] as int
          : 0,
      estimatedArrival: null,
      isAvailable: isAvailable,
      profileImageUrl: null,
      vehicles: null,
      operatingHours: null,
    );
  }

  /// Latest location for a provider
  Future<ApiResponse<LocationTracking>> getLatestProviderLocation(
      String providerId) async {
    try {
      final response = await _dio
          .get('/api/v1/location-tracking/provider/$providerId/latest');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        final item = LocationTracking.fromJson(body);
        return ApiResponse.success(
          message: 'Latest provider location retrieved',
          data: item,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load latest provider location',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Location history for a request
  Future<ApiResponse<List<LocationTracking>>> getRequestLocationHistory(
    String requestId, {
    int? limit,
  }) async {
    try {
      final response = await _dio.get(
          '/api/v1/location-tracking/request/$requestId/history',
          queryParameters: {
            if (limit != null) 'limit': limit,
          });
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is List
            ? (response.data as List<dynamic>)
            : (response.data is Map<String, dynamic>
                ? ((response.data as Map<String, dynamic>)['data'] ?? [])
                    as List<dynamic>
                : <dynamic>[]);
        final list = items
            .map((e) => LocationTracking.fromJson(e as Map<String, dynamic>))
            .toList();
        return ApiResponse.success(
          message: 'Request location history retrieved',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load request location history',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Location history for a provider within time range
  Future<ApiResponse<List<LocationTracking>>> getProviderLocationHistory(
    String providerId, {
    DateTime? start,
    DateTime? end,
    int? limit,
  }) async {
    try {
      final query = <String, dynamic>{
        if (start != null) 'start_time': start.toIso8601String(),
        if (end != null) 'end_time': end.toIso8601String(),
        if (limit != null) 'limit': limit,
      };
      final response = await _dio.get(
          '/api/v1/location-tracking/provider/$providerId/history',
          queryParameters: query);
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is List
            ? (response.data as List<dynamic>)
            : (response.data is Map<String, dynamic>
                ? ((response.data as Map<String, dynamic>)['data'] ?? [])
                    as List<dynamic>
                : <dynamic>[]);
        final list = items
            .map((e) => LocationTracking.fromJson(e as Map<String, dynamic>))
            .toList();
        return ApiResponse.success(
          message: 'Provider location history retrieved',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load provider location history',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Create towing-specific request after creating base service request
  Future<ApiResponse<void>> createTowingRequest({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.post('/towing-requests/', data: data);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResponse.success(
          message: 'Towing request created successfully',
          data: null,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to create towing request',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getTowingRequests({
    String? serviceRequestId,
    String? vehicleId,
    String? towingTypeId,
    String? vehicleCondition,
    bool? isEmergency,
    int? limit,
    int? offset,
  }) async {
    try {
      final query = <String, dynamic>{
        if (serviceRequestId != null) 'service_request_id': serviceRequestId,
        if (vehicleId != null) 'vehicle_id': vehicleId,
        if (towingTypeId != null) 'towing_type_id': towingTypeId,
        if (vehicleCondition != null) 'vehicle_condition': vehicleCondition,
        if (isEmergency != null) 'is_emergency': isEmergency,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      };
      final response =
          await _dio.get('/towing-requests/all', queryParameters: query);
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is List
            ? (response.data as List<dynamic>)
            : (response.data is Map<String, dynamic>
                ? ((response.data as Map<String, dynamic>)['data'] ?? [])
                    as List<dynamic>
                : <dynamic>[]);
        final list = items.map((e) => (e as Map<String, dynamic>)).toList();
        return ApiResponse.success(
          message: 'Towing requests retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load towing requests',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getEmergencyTowingRequests(
      {int? limit}) async {
    try {
      final response =
          await _dio.get('/towing-requests/emergency', queryParameters: {
        if (limit != null) 'limit': limit,
      });
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is List
            ? (response.data as List<dynamic>)
            : (response.data is Map<String, dynamic>
                ? ((response.data as Map<String, dynamic>)['data'] ?? [])
                    as List<dynamic>
                : <dynamic>[]);
        final list = items.map((e) => (e as Map<String, dynamic>)).toList();
        return ApiResponse.success(
          message: 'Emergency towing requests retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load emergency towing requests',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getTowingRequestsByCondition(
      String condition,
      {int? limit}) async {
    try {
      final response = await _dio
          .get('/towing-requests/condition/$condition', queryParameters: {
        if (limit != null) 'limit': limit,
      });
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is List
            ? (response.data as List<dynamic>)
            : (response.data is Map<String, dynamic>
                ? ((response.data as Map<String, dynamic>)['data'] ?? [])
                    as List<dynamic>
                : <dynamic>[]);
        final list = items.map((e) => (e as Map<String, dynamic>)).toList();
        return ApiResponse.success(
          message: 'Towing requests by condition retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load towing requests by condition',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getTowingRequestsByVehicle(
      String vehicleId,
      {int? limit}) async {
    try {
      final response = await _dio
          .get('/towing-requests/vehicle/$vehicleId', queryParameters: {
        if (limit != null) 'limit': limit,
      });
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is List
            ? (response.data as List<dynamic>)
            : (response.data is Map<String, dynamic>
                ? ((response.data as Map<String, dynamic>)['data'] ?? [])
                    as List<dynamic>
                : <dynamic>[]);
        final list = items.map((e) => (e as Map<String, dynamic>)).toList();
        return ApiResponse.success(
          message: 'Towing requests for vehicle retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load towing requests for vehicle',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getTowingRequestsByType(
      String towingTypeId,
      {int? limit}) async {
    try {
      final response = await _dio
          .get('/towing-requests/type/$towingTypeId', queryParameters: {
        if (limit != null) 'limit': limit,
      });
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is List
            ? (response.data as List<dynamic>)
            : (response.data is Map<String, dynamic>
                ? ((response.data as Map<String, dynamic>)['data'] ?? [])
                    as List<dynamic>
                : <dynamic>[]);
        final list = items.map((e) => (e as Map<String, dynamic>)).toList();
        return ApiResponse.success(
          message: 'Towing requests by type retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load towing requests by type',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> getTowingRequestById(
      String id) async {
    try {
      final response = await _dio.get('/towing-requests/$id');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Towing request retrieved successfully',
          data: body,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load towing request',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> updateTowingRequest(
      String id, Map<String, dynamic> update) async {
    try {
      final response = await _dio.patch('/towing-requests/$id', data: update);
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Towing request updated successfully',
          data: body,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to update towing request',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<void>> deleteTowingRequest(String id) async {
    try {
      final response = await _dio.delete('/towing-requests/$id');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return ApiResponse.success(
          message: 'Towing request deleted',
          data: null,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to delete towing request',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> getTowingRequestByServiceRequest(
      String serviceRequestId) async {
    try {
      final response =
          await _dio.get('/towing-requests/service-request/$serviceRequestId');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Towing request by service request retrieved successfully',
          data: body,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load towing request by service request',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> markTowingRequestEmergency(
      String id) async {
    try {
      final response = await _dio.patch('/towing-requests/$id/emergency');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Towing request marked as emergency',
          data: body,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to mark towing request as emergency',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> assignTowingType(
      String id, String towingTypeId) async {
    try {
      final response =
          await _dio.patch('/towing-requests/$id/assign-type/$towingTypeId');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Towing type assigned',
          data: body,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to assign towing type',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> updateTowingCondition(
      String id, String condition) async {
    try {
      final response =
          await _dio.patch('/towing-requests/$id/condition/$condition');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Towing condition updated',
          data: body,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to update towing condition',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Create water-specific request after creating base service request
  Future<ApiResponse<void>> createWaterRequest({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.post('/water-requests/', data: data);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResponse.success(
          message: 'Water request created successfully',
          data: null,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to create water request',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Get current user profile (ProfilePublic)
  Future<ApiResponse<Map<String, dynamic>>> getProfileMe() async {
    try {
      final response = await _dio.get('/profiles/me');
      if (response.statusCode == 200) {
        final data = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Profile retrieved successfully',
          data: data,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load profile',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Patch current user profile
  Future<ApiResponse<Map<String, dynamic>>> patchProfileMe(
      Map<String, dynamic> update) async {
    try {
      final response = await _dio.patch('/profiles/me', data: update);
      if (response.statusCode == 200) {
        final data = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Profile updated successfully',
          data: data,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to update profile',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> patchUserMe(
      Map<String, dynamic> update) async {
    try {
      final response = await _dio.patch('/users/me', data: update);
      if (response.statusCode == 200) {
        final data = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'User updated successfully',
          data: data,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to update user',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getPayments(
      {int? limit}) async {
    try {
      final response = await _dio.get('/payments/', queryParameters: {
        if (limit != null) 'limit': limit,
      });
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as List<dynamic>
            : (response.data as List<dynamic>);
        final list = items.map((e) => (e as Map<String, dynamic>)).toList();
        return ApiResponse.success(
          message: 'Payments retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load payments',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> createPayment({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.post('/payments/', data: data);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Payment created successfully',
          data: body,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to create payment',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> createWallet({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.post('/wallets/', data: data);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Wallet created successfully',
          data: body,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to create wallet',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> getMyMainWallet() async {
    try {
      final response = await _dio.get('/wallets/my-main-wallet');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Main wallet retrieved successfully',
          data: body,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load main wallet',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getMyWallets() async {
    try {
      final response = await _dio.get('/wallets/my-wallets');
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as List<dynamic>
            : (response.data as List<dynamic>);
        final list = items.map((e) => (e as Map<String, dynamic>)).toList();
        return ApiResponse.success(
          message: 'Wallets retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load wallets',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> creditWallet({
    required String walletId,
    required double amount,
    String? description,
  }) async {
    try {
      final response =
          await _dio.post('/wallets/$walletId/credit', queryParameters: {
        'amount': amount,
        if (description != null) 'description': description,
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Wallet credited successfully',
          data: body,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to credit wallet',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> debitWallet({
    required String walletId,
    required double amount,
    String? description,
  }) async {
    try {
      final response =
          await _dio.post('/wallets/$walletId/debit', queryParameters: {
        'amount': amount,
        if (description != null) 'description': description,
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Wallet debited successfully',
          data: body,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to debit wallet',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getPaymentsAll({
    String? profileId,
    String? serviceRequestId,
    String? paymentMethod,
    String? status,
    num? minAmount,
    num? maxAmount,
    String? startDate,
    String? endDate,
    int? limit,
    int? offset,
  }) async {
    try {
      final query = <String, dynamic>{
        if (profileId != null) 'profile_id': profileId,
        if (serviceRequestId != null) 'service_request_id': serviceRequestId,
        if (paymentMethod != null) 'payment_method': paymentMethod,
        if (status != null) 'status': status,
        if (minAmount != null) 'min_amount': minAmount,
        if (maxAmount != null) 'max_amount': maxAmount,
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      };
      final response = await _dio.get('/payments/all', queryParameters: query);
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is List
            ? (response.data as List<dynamic>)
            : (response.data is Map<String, dynamic>
                ? ((response.data as Map<String, dynamic>)['data'] ?? [])
                    as List<dynamic>
                : <dynamic>[]);
        final list = items.map((e) => (e as Map<String, dynamic>)).toList();
        return ApiResponse.success(
          message: 'Payments retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load payments',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getMyPayments(
      {String? status, String? paymentMethod, int? limit}) async {
    try {
      final response =
          await _dio.get('/payments/my-payments', queryParameters: {
        if (status != null) 'status': status,
        if (paymentMethod != null) 'payment_method': paymentMethod,
        if (limit != null) 'limit': limit,
      });
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is List
            ? (response.data as List<dynamic>)
            : (response.data is Map<String, dynamic>
                ? ((response.data as Map<String, dynamic>)['data'] ?? [])
                    as List<dynamic>
                : <dynamic>[]);
        final list = items.map((e) => (e as Map<String, dynamic>)).toList();
        return ApiResponse.success(
          message: 'My payments retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load my payments',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getPaymentsForServiceRequest(
      String serviceRequestId) async {
    try {
      final response =
          await _dio.get('/payments/service-request/$serviceRequestId');
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is List
            ? (response.data as List<dynamic>)
            : (response.data is Map<String, dynamic>
                ? ((response.data as Map<String, dynamic>)['data'] ?? [])
                    as List<dynamic>
                : <dynamic>[]);
        final list = items.map((e) => (e as Map<String, dynamic>)).toList();
        return ApiResponse.success(
          message: 'Payments for service request retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load payments for service request',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getPendingPayments(
      {int? limit}) async {
    try {
      final response = await _dio.get('/payments/pending', queryParameters: {
        if (limit != null) 'limit': limit,
      });
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is List
            ? (response.data as List<dynamic>)
            : (response.data is Map<String, dynamic>
                ? ((response.data as Map<String, dynamic>)['data'] ?? [])
                    as List<dynamic>
                : <dynamic>[]);
        final list = items.map((e) => (e as Map<String, dynamic>)).toList();
        return ApiResponse.success(
          message: 'Pending payments retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load pending payments',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getSuccessfulPayments(
      {int? limit}) async {
    try {
      final response = await _dio.get('/payments/successful', queryParameters: {
        if (limit != null) 'limit': limit,
      });
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is List
            ? (response.data as List<dynamic>)
            : (response.data is Map<String, dynamic>
                ? ((response.data as Map<String, dynamic>)['data'] ?? [])
                    as List<dynamic>
                : <dynamic>[]);
        final list = items.map((e) => (e as Map<String, dynamic>)).toList();
        return ApiResponse.success(
          message: 'Successful payments retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load successful payments',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getFailedPayments(
      {int? limit}) async {
    try {
      final response = await _dio.get('/payments/failed', queryParameters: {
        if (limit != null) 'limit': limit,
      });
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is List
            ? (response.data as List<dynamic>)
            : (response.data is Map<String, dynamic>
                ? ((response.data as Map<String, dynamic>)['data'] ?? [])
                    as List<dynamic>
                : <dynamic>[]);
        final list = items.map((e) => (e as Map<String, dynamic>)).toList();
        return ApiResponse.success(
          message: 'Failed payments retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load failed payments',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> getRecentPayments(
      {int? days, int? limit}) async {
    try {
      final response = await _dio.get('/payments/me', queryParameters: {
        if (days != null) 'days': days,
        if (limit != null) 'limit': limit,
      });
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is List
            ? (response.data as List<dynamic>)
            : (response.data is Map<String, dynamic>
                ? ((response.data as Map<String, dynamic>)['data'] ?? [])
                    as List<dynamic>
                : <dynamic>[]);
        final list = items.map((e) => (e as Map<String, dynamic>)).toList();
        return ApiResponse.success(
          message: 'Recent payments retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load recent payments',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> getPaymentById(String id) async {
    try {
      final response = await _dio.get('/payments/$id');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Payment retrieved successfully',
          data: body,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load payment',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> updatePayment(String id,
      {String? status, DateTime? processedAt}) async {
    try {
      final payload = <String, dynamic>{
        if (status != null) 'status': status,
        if (processedAt != null) 'processed_at': processedAt.toIso8601String(),
      };
      final response = await _dio.patch('/payments/$id', data: payload);
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Payment updated successfully',
          data: body,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to update payment',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<void>> deletePayment(String id) async {
    try {
      final response = await _dio.delete('/payments/$id');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return ApiResponse.success(
          message: 'Payment deleted',
          data: null,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to delete payment',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> getPaymentByReference(
      String paymentReference) async {
    try {
      final response = await _dio.get('/payments/reference/$paymentReference');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Payment by reference retrieved successfully',
          data: body,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load payment by reference',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> confirmPayment(String id) async {
    try {
      final response = await _dio.patch('/payments/$id/confirm');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Payment confirmed',
          data: body,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to confirm payment',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> failPayment(String id,
      {String? failureReason}) async {
    try {
      final response = await _dio.patch('/payments/$id/fail', queryParameters: {
        if (failureReason != null) 'failure_reason': failureReason,
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Payment marked as failed',
          data: body,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to mark payment as failed',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> refundPayment(String id,
      {String? refundReason}) async {
    try {
      final response =
          await _dio.patch('/payments/$id/refund', queryParameters: {
        if (refundReason != null) 'refund_reason': refundReason,
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Payment refunded',
          data: body,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to refund payment',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<void>> createServiceProvider({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.post('/service-providers/', data: data);
      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResponse.success(
          message: 'Service provider created successfully',
          data: null,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to create service provider',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> setWalletPin({
    required String pin,
  }) async {
    try {
      final response = await _dio.patch('/users/me', data: {
        'wallet_pin': pin,
      });
      if (response.statusCode == 200) {
        final data = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Wallet PIN set successfully',
          data: data,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to set wallet PIN',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
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

  /// Create service request per v1 docs
  Future<ApiResponse<Map<String, dynamic>>> createServiceRequestV1({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dio.post('/service-requests/', data: data);
      if (response.statusCode == 201) {
        final body = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Service request created successfully',
          data: body,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to create service request',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Get user's service request history
  Future<ApiResponse<List<ServiceRequest>>> getServiceHistory({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    // Deprecated in favor of getMyServiceRequests; keep for backward compatibility
    return getMyServiceRequests(
        status: status, limit: limit, offset: (page - 1) * limit);
  }

  /// New: Get current user's service requests per docs
  Future<ApiResponse<List<ServiceRequest>>> getMyServiceRequests({
    String? status,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        if (status != null) 'status': status,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      };
      final response = await _dio.get('/service-requests/my-requests',
          queryParameters: queryParams);
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is List
            ? (response.data as List<dynamic>)
            : (response.data is Map<String, dynamic>
                ? ((response.data as Map<String, dynamic>)['data'] ?? [])
                    as List<dynamic>
                : <dynamic>[]);
        final list = items
            .map((e) => _mapBackendServiceRequest(e as Map<String, dynamic>))
            .toList();
        return ApiResponse.success(
          message: 'My service requests retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load my service requests',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Provider: Get requests assigned to me
  Future<ApiResponse<List<ServiceRequest>>> getAssignedToMeRequests({
    String? status,
    int? limit,
  }) async {
    try {
      final response =
          await _dio.get('/service-requests/assigned-to-me', queryParameters: {
        if (status != null) 'status': status,
        if (limit != null) 'limit': limit,
      });
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is List
            ? (response.data as List<dynamic>)
            : (response.data is Map<String, dynamic>
                ? ((response.data as Map<String, dynamic>)['data'] ?? [])
                    as List<dynamic>
                : <dynamic>[]);
        final list = items
            .map((e) => _mapBackendServiceRequest(e as Map<String, dynamic>))
            .toList();
        return ApiResponse.success(
          message: 'Assigned requests retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load assigned requests',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Get pending requests
  Future<ApiResponse<List<ServiceRequest>>> getPendingRequests({
    String? serviceTypeId,
    int? limit,
  }) async {
    try {
      final response =
          await _dio.get('/service-requests/pending', queryParameters: {
        if (serviceTypeId != null) 'service_type_id': serviceTypeId,
        if (limit != null) 'limit': limit,
      });
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is List
            ? (response.data as List<dynamic>)
            : (response.data is Map<String, dynamic>
                ? ((response.data as Map<String, dynamic>)['data'] ?? [])
                    as List<dynamic>
                : <dynamic>[]);
        final list = items
            .map((e) => _mapBackendServiceRequest(e as Map<String, dynamic>))
            .toList();
        return ApiResponse.success(
          message: 'Pending requests retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load pending requests',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Get urgent requests
  Future<ApiResponse<List<ServiceRequest>>> getUrgentRequests(
      {int? limit}) async {
    try {
      final response =
          await _dio.get('/service-requests/urgent', queryParameters: {
        if (limit != null) 'limit': limit,
      });
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is List
            ? (response.data as List<dynamic>)
            : (response.data is Map<String, dynamic>
                ? ((response.data as Map<String, dynamic>)['data'] ?? [])
                    as List<dynamic>
                : <dynamic>[]);
        final list = items
            .map((e) => _mapBackendServiceRequest(e as Map<String, dynamic>))
            .toList();
        return ApiResponse.success(
          message: 'Urgent requests retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load urgent requests',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Get service request by ID
  Future<ApiResponse<ServiceRequest>> getServiceRequestById(String id) async {
    try {
      final response = await _dio.get('/service-requests/$id');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        final req = _mapBackendServiceRequest(body);
        return ApiResponse.success(
          message: 'Service request retrieved successfully',
          data: req,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load service request',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Get service request by request number
  Future<ApiResponse<ServiceRequest>> getServiceRequestByNumber(
      String requestNumber) async {
    try {
      final response =
          await _dio.get('/service-requests/request-number/$requestNumber');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        final req = _mapBackendServiceRequest(body);
        return ApiResponse.success(
          message: 'Service request retrieved successfully',
          data: req,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load service request',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Assign provider
  Future<ApiResponse<ServiceRequest>> assignServiceProvider({
    required String requestId,
    required String providerId,
  }) async {
    try {
      final response =
          await _dio.patch('/service-requests/$requestId/assign/$providerId');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        final req = _mapBackendServiceRequest(body);
        return ApiResponse.success(
          message: 'Provider assigned successfully',
          data: req,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to assign provider',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Update status
  Future<ApiResponse<ServiceRequest>> updateRequestStatus({
    required String requestId,
    required String status,
  }) async {
    try {
      final response =
          await _dio.patch('/service-requests/$requestId/status/$status');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        final req = _mapBackendServiceRequest(body);
        return ApiResponse.success(
          message: 'Status updated',
          data: req,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to update status',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Cancel request
  Future<ApiResponse<ServiceRequest>> cancelServiceRequest(
      String requestId) async {
    try {
      final response = await _dio.patch('/service-requests/$requestId/cancel');
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        final req = _mapBackendServiceRequest(body);
        return ApiResponse.success(
          message: 'Request cancelled',
          data: req,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to cancel request',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  ServiceRequest _mapBackendServiceRequest(Map<String, dynamic> json) {
    double _toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    ServiceRequestStatus _statusFrom(String? s) {
      switch (s) {
        case 'pending':
          return ServiceRequestStatus.pending;
        case 'assigned':
          return ServiceRequestStatus.assigned;
        case 'in_progress':
          return ServiceRequestStatus.inProgress;
        case 'completed':
          return ServiceRequestStatus.completed;
        case 'cancelled':
          return ServiceRequestStatus.cancelled;
        case 'confirmed':
          return ServiceRequestStatus.confirmed;
        default:
          return ServiceRequestStatus.pending;
      }
    }

    final pickup = LocationDetails(
      address: (json['pickup_address'] ?? '').toString(),
      latitude: _toDouble(json['pickup_latitude']),
      longitude: _toDouble(json['pickup_longitude']),
    );
    final destAddress = (json['destination_address'] ?? '').toString();
    final destination = destAddress.isNotEmpty
        ? LocationDetails(
            address: destAddress,
            latitude: _toDouble(json['destination_latitude']),
            longitude: _toDouble(json['destination_longitude']),
          )
        : null;
    return ServiceRequest(
      id: (json['id'] ?? '').toString(),
      serviceType: (json['service_type_id'] ?? '').toString(),
      status: _statusFrom(json['status']?.toString()),
      customerId: (json['profile_id'] ?? '').toString(),
      assignedProvider: null,
      pickupLocation: pickup,
      destinationLocation: destination,
      serviceDetails: {
        'request_number': json['request_number'],
        'distance_km': json['distance_km'],
        'special_instructions': json['special_instructions'],
      },
      estimatedCost: json.containsKey('estimated_price')
          ? _toDouble(json['estimated_price'])
          : null,
      finalCost: json.containsKey('final_price')
          ? _toDouble(json['final_price'])
          : null,
      currency: 'GHS',
      createdAt: DateTime.tryParse((json['created_at'] ?? '').toString()) ??
          DateTime.now(),
      updatedAt: DateTime.tryParse((json['updated_at'] ?? '').toString()) ??
          DateTime.now(),
      estimatedCompletionTime: null,
      completedAt: DateTime.tryParse((json['completed_at'] ?? '').toString()),
      notes: (json['special_instructions'] ?? '') as String?,
      urgencyLevel: 'low',
      paymentStatus: PaymentStatus.pending,
      imageUrls: null,
    );
  }

  /// Update service request status
  Future<ApiResponse<ServiceRequest>> updateServiceRequest({
    required String requestId,
    required Map<String, dynamic> updateData,
  }) async {
    try {
      final response =
          await _dio.patch('/service-requests/$requestId', data: updateData);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        final serviceRequest = _mapBackendServiceRequest(body);
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

  /// List notifications for the current user
  Future<ApiResponse<List<Map<String, dynamic>>>> getNotifications(
      {int? limit}) async {
    try {
      final response = await _dio.get('/notifications/', queryParameters: {
        if (limit != null) 'limit': limit,
      });
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as List<dynamic>
            : (response.data as List<dynamic>);
        final list = items.map((e) => (e as Map<String, dynamic>)).toList();
        return ApiResponse.success(
          message: 'Notifications retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load notifications',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Mark a single notification as read
  Future<ApiResponse<Map<String, dynamic>>> markNotificationRead(
      String id) async {
    try {
      final response =
          await _dio.patch('/notifications/$id', data: {'is_read': true});
      if (response.statusCode == 200) {
        final data = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Notification marked as read',
          data: data,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to mark notification as read',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Delete a notification
  Future<ApiResponse<void>> deleteNotification(String id) async {
    try {
      final response = await _dio.delete('/notifications/$id');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return ApiResponse.success(
          message: 'Notification deleted',
          data: null,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to delete notification',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Get messages for a request conversation (path form)
  Future<ApiResponse<List<Map<String, dynamic>>>> getMessagesForRequest({
    required String requestId,
    int? limit,
  }) async {
    try {
      final response =
          await _dio.get('/messages/request/$requestId', queryParameters: {
        if (limit != null) 'limit': limit,
      });
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as List<dynamic>
            : (response.data as List<dynamic>);
        final list = items.map((e) => (e as Map<String, dynamic>)).toList();
        return ApiResponse.success(
          message: 'Messages retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load messages',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Get conversation messages with another profile
  Future<ApiResponse<List<Map<String, dynamic>>>> getConversationMessages({
    required String otherProfileId,
    int? limit,
  }) async {
    try {
      final response = await _dio
          .get('/messages/conversation/$otherProfileId', queryParameters: {
        if (limit != null) 'limit': limit,
      });
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as List<dynamic>
            : (response.data as List<dynamic>);
        final list = items.map((e) => (e as Map<String, dynamic>)).toList();
        return ApiResponse.success(
          message: 'Conversation messages retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load conversation messages',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Send a message (supports text only for now)
  Future<ApiResponse<Map<String, dynamic>>> sendMessage({
    required String requestId,
    required String messageContent,
    String messageType = 'text',
    String? attachmentUrl,
    String? attachmentType,
  }) async {
    try {
      final payload = {
        'request_id': requestId,
        'message_type': messageType,
        'message_content': messageContent,
        if (attachmentUrl != null) 'attachment_url': attachmentUrl,
        if (attachmentType != null) 'attachment_type': attachmentType,
      };
      final response = await _dio.post('/messages/', data: payload);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Message sent',
          data: data,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to send message',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Get recent conversations for current user
  Future<ApiResponse<List<Map<String, dynamic>>>> getConversations(
      {int? limit}) async {
    try {
      final response =
          await _dio.get('/messages/conversations', queryParameters: {
        if (limit != null) 'limit': limit,
      });
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as List<dynamic>
            : (response.data as List<dynamic>);
        final list = items.map((e) => (e as Map<String, dynamic>)).toList();
        return ApiResponse.success(
          message: 'Conversations retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load conversations',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Mark single message as read
  Future<ApiResponse<Map<String, dynamic>>> markMessageRead(
      String messageId) async {
    try {
      final response = await _dio.patch('/messages/$messageId/read');
      if (response.statusCode == 200) {
        final data = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Message marked as read',
          data: data,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to mark message as read',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Mark conversation with another profile as read
  Future<ApiResponse<void>> markConversationRead(String otherProfileId) async {
    try {
      final response =
          await _dio.patch('/messages/conversation/$otherProfileId/read');
      if (response.statusCode == 200) {
        return ApiResponse.success(
          message: 'Conversation marked as read',
          data: null,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to mark conversation as read',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Get message threads for inbox (if available on backend)
  Future<ApiResponse<List<Map<String, dynamic>>>> getMessageThreads() async {
    try {
      final response = await _dio.get('/messages/threads');
      if (response.statusCode == 200) {
        final List<dynamic> items = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as List<dynamic>
            : (response.data as List<dynamic>);
        final list = items.map((e) => (e as Map<String, dynamic>)).toList();
        return ApiResponse.success(
          message: 'Threads retrieved successfully',
          data: list,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load threads',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> toggleMyAvailability(
      {bool? isAvailable}) async {
    try {
      if (isAvailable != null) {
        final response = await _dio.patch('/service-providers/me/availability', data: {
          //'is_available': isAvailable,
          'is_online': isAvailable,
        });
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = response.data
                  is Map<String, dynamic>
              ? (response.data['data'] ?? response.data) as Map<String, dynamic>
              : <String, dynamic>{};
          return ApiResponse.success(
            message: 'Availability updated',
            data: data,
            statusCode: response.statusCode,
          );
        }
        // Fallback: some deployments restrict provider profile updates; try user profile
        if (response.statusCode == 403) {
          final userResp = await _dio.patch('/users/me', data: {
            'is_online': isAvailable,
          });
          if (userResp.statusCode == 200) {
            final Map<String, dynamic> data =
                userResp.data is Map<String, dynamic>
                    ? (userResp.data['data'] ?? userResp.data)
                        as Map<String, dynamic>
                    : <String, dynamic>{};
            return ApiResponse.success(
              message: 'Availability updated',
              data: data,
              statusCode: userResp.statusCode,
            );
          }
          return ApiResponse.error(
            message: 'Failed to update availability',
            statusCode: userResp.statusCode,
          );
        }
        return ApiResponse.error(
          message: 'Failed to update availability',
          statusCode: response.statusCode,
        );
      }

      final response = await _dio.patch('/service-providers/me/availability');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Availability toggled',
          data: data,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to toggle availability',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      // If 403 on toggle, try updating via /users/me as a permissive fallback
      if (e.response?.statusCode == 403 && isAvailable != null) {
        try {
          final userResp = await _dio.patch('/users/me', data: {
            'is_available': isAvailable,
            'is_online': isAvailable,
          });
          if (userResp.statusCode == 200) {
            final Map<String, dynamic> data =
                userResp.data is Map<String, dynamic>
                    ? (userResp.data['data'] ?? userResp.data)
                        as Map<String, dynamic>
                    : <String, dynamic>{};
            return ApiResponse.success(
              message: 'Availability updated',
              data: data,
              statusCode: userResp.statusCode,
            );
          }
        } catch (_) {}
      }
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>>
      getMyServiceProviderProfile() async {
    try {
      final response = await _dio.get('/service-providers/me');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data is Map<String, dynamic>
            ? (response.data['data'] ?? response.data) as Map<String, dynamic>
            : <String, dynamic>{};
        return ApiResponse.success(
          message: 'Service provider profile retrieved',
          data: data,
          statusCode: response.statusCode,
        );
      }
      return ApiResponse.error(
        message: 'Failed to load service provider profile',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Create authentication interceptor
  /// Create authentication interceptor

  /// Handle Dio errors and convert to ApiResponse
  /// Handle Dio errors and convert to ApiResponse
  ApiResponse<T> _handleDioError<T>(DioException error) {
    final int? statusCode = error.response?.statusCode;

    // Check for ngrok HTML response
    if (error.response?.data is String) {
      final responseData = error.response!.data as String;
      if (responseData.contains('<!DOCTYPE html>') &&
          (responseData.contains('ngrok') ||
              responseData.contains('ERR_NGROK'))) {
        return ApiResponse.error(
          message:
              'Unable to connect to server. The service is showing a security warning page.\n\n'
              'Quick fix: Open ${AppConstants.baseUrl.replaceAll('/api/v1', '')} in your phone browser, '
              'click "Visit Site", then restart this app.',
          statusCode: statusCode,
          error: 'ngrok_interstitial_page',
        );
      }
    }

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
