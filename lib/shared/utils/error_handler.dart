import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../exceptions/auth_exceptions.dart';

class ErrorHandler {
  /// Convert DioException to appropriate AuthException
  static AuthException handleDioError(DioException error) {
    if (kDebugMode) {
      print('DioException: ${error.type} - ${error.message}');
      print('Response: ${error.response?.data}');
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('Connection timeout. Please check your internet connection.');

      case DioExceptionType.badResponse:
        return _handleResponseError(error);

      case DioExceptionType.cancel:
        return const AuthException('Request was cancelled');

      case DioExceptionType.connectionError:
        return const NetworkException('No internet connection. Please check your network settings.');

      case DioExceptionType.badCertificate:
        return const NetworkException('SSL certificate error');

      case DioExceptionType.unknown:
      default:
        return AuthException('An unexpected error occurred: ${error.message}');
    }
  }

  /// Handle HTTP response errors
  static AuthException _handleResponseError(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    // Try to extract error message from response
    String errorMessage = 'An error occurred';
    String? errorCode;
    Map<String, List<String>>? fieldErrors;

    if (responseData is Map<String, dynamic>) {
      // Common error message fields
      errorMessage = responseData['message'] ?? 
                    responseData['error'] ?? 
                    responseData['detail'] ?? 
                    errorMessage;
      
      errorCode = responseData['code']?.toString();
      
      // Handle validation errors
      if (responseData['errors'] is Map) {
        fieldErrors = {};
        final errors = responseData['errors'] as Map<String, dynamic>;
        errors.forEach((key, value) {
          if (value is List) {
            fieldErrors![key] = value.map((e) => e.toString()).toList();
          } else {
            fieldErrors![key] = [value.toString()];
          }
        });
      }
    } else if (responseData is String) {
      errorMessage = responseData;
    }

    switch (statusCode) {
      case 400:
        if (fieldErrors != null) {
          return ValidationException(errorMessage, fieldErrors: fieldErrors);
        }
        return AuthException(errorMessage, code: errorCode, statusCode: statusCode);

      case 401:
        // Check for specific authentication errors
        if (errorCode == 'TOKEN_EXPIRED' || errorMessage.toLowerCase().contains('expired')) {
          return TokenExpiredException(errorMessage);
        }
        if (errorCode == 'INVALID_CREDENTIALS' || errorMessage.toLowerCase().contains('credential')) {
          return InvalidCredentialsException(errorMessage);
        }
        return UnauthorizedException(errorMessage);

      case 403:
        if (errorCode == 'ACCOUNT_NOT_VERIFIED' || errorMessage.toLowerCase().contains('not verified')) {
          return AccountNotVerifiedException(errorMessage);
        }
        if (errorCode == 'ACCOUNT_DISABLED' || errorMessage.toLowerCase().contains('disabled')) {
          return AccountDisabledException(errorMessage);
        }
        return AuthException(errorMessage, code: errorCode, statusCode: statusCode);

      case 404:
        return AuthException('Resource not found', code: errorCode, statusCode: statusCode);

      case 409:
        if (errorCode == 'USER_EXISTS' || errorMessage.toLowerCase().contains('already exists')) {
          return UserAlreadyExistsException(errorMessage);
        }
        return AuthException(errorMessage, code: errorCode, statusCode: statusCode);

      case 422:
        if (errorCode == 'INVALID_OTP' || errorMessage.toLowerCase().contains('otp')) {
          return InvalidOtpException(errorMessage);
        }
        if (fieldErrors != null) {
          return ValidationException(errorMessage, fieldErrors: fieldErrors);
        }
        return AuthException(errorMessage, code: errorCode, statusCode: statusCode);

      case 429:
        return RateLimitException(errorMessage);

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          'Server error. Please try again later.',
          statusCode: statusCode,
        );

      default:
        return ServerException(errorMessage, statusCode: statusCode);
    }
  }

  /// Handle general exceptions
  static AuthException handleGeneralError(dynamic error) {
    if (error is AuthException) {
      return error;
    }
    
    if (error is DioException) {
      return handleDioError(error);
    }

    if (kDebugMode) {
      print('General error: $error');
    }

    return AuthException('An unexpected error occurred: ${error.toString()}');
  }

  /// Get user-friendly error message
  static String getUserFriendlyMessage(AuthException exception) {
    switch (exception.code) {
      case 'INVALID_CREDENTIALS':
        return 'Invalid username or password. Please try again.';
      case 'UNAUTHORIZED':
        return 'Please log in to continue.';
      case 'TOKEN_EXPIRED':
        return 'Your session has expired. Please log in again.';
      case 'ACCOUNT_NOT_VERIFIED':
        return 'Please verify your account to continue.';
      case 'ACCOUNT_DISABLED':
        return 'Your account has been disabled. Please contact support.';
      case 'USER_EXISTS':
        return 'An account with this email or phone already exists.';
      case 'INVALID_OTP':
        return 'Invalid or expired verification code. Please try again.';
      case 'NETWORK_ERROR':
        return 'Please check your internet connection and try again.';
      case 'RATE_LIMIT':
        return 'Too many attempts. Please wait before trying again.';
      case 'VALIDATION_ERROR':
        return 'Please check your input and try again.';
      default:
        return exception.message;
    }
  }
}