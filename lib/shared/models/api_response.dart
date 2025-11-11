import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

/// Generic API response wrapper for all API calls
/// 
/// This model provides a consistent structure for handling API responses
/// across the application, including success/error states and data payload.
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  /// Indicates if the API call was successful
  final bool success;
  
  /// Response message from the API
  final String message;
  
  /// The actual data payload (can be null for error responses)
  final T? data;
  
  /// Error details if the request failed
  final String? error;
  
  /// HTTP status code
  final int? statusCode;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
    this.statusCode,
  });

  /// Factory constructor for JSON deserialization
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  /// Convert to JSON
  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);

  /// Factory constructor for successful responses
  factory ApiResponse.success({
    required String message,
    required T data,
    int? statusCode,
  }) =>
      ApiResponse(
        success: true,
        message: message,
        data: data,
        statusCode: statusCode,
      );

  /// Factory constructor for error responses
  factory ApiResponse.error({
    required String message,
    String? error,
    int? statusCode,
  }) =>
      ApiResponse(
        success: false,
        message: message,
        error: error,
        statusCode: statusCode,
      );
}