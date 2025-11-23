// Create a new file: lib/shared/services/dio_config_helper.dart

import 'package:dio/dio.dart';

/// Global helper to ensure ALL Dio instances have ngrok bypass headers
class DioConfigHelper {
  /// Apply ngrok bypass configuration to any Dio instance
  static void applyNgrokBypass(Dio dio) {
    // Add to base options
    dio.options.headers['ngrok-skip-browser-warning'] = '69420';
    dio.options.headers['Ngrok-Skip-Browser-Warning'] = 'true';
    
    // Add interceptor to ensure it's in EVERY request
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Force add ngrok headers to every single request
          options.headers['ngrok-skip-browser-warning'] = '69420';
          options.headers['Ngrok-Skip-Browser-Warning'] = 'true';
          handler.next(options);
        },
      ),
    );
  }
  
  /// Create a properly configured Dio instance
  static Dio createConfiguredDio({
    required String baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    Map<String, dynamic>? headers,
  }) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout ?? const Duration(seconds: 30),
      receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
      sendTimeout: sendTimeout ?? const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': '69420',
        'Ngrok-Skip-Browser-Warning': 'true',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36',
        ...?headers,
      },
    ));
    
    // Apply ngrok bypass interceptor
    applyNgrokBypass(dio);
    
    return dio;
  }
}

// Extension to add ngrok bypass to existing Options
extension OptionsNgrokExtension on Options {
  Options withNgrokBypass() {
    return copyWith(
      headers: {
        ...?headers,
        'ngrok-skip-browser-warning': '69420',
        'Ngrok-Skip-Browser-Warning': 'true',
      },
    );
  }
}