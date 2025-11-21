import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/api_service.dart';

part 'api_service_provider.g.dart';

/// Provider for the API service singleton
/// 
/// This provider ensures that the same instance of ApiService is used
/// throughout the application, providing a centralized way to access
/// all API functionality.
/// 
/// Usage:
/// ```dart
/// final apiService = ref.read(apiServiceProvider);
/// final result = await apiService.getDashboardData();
/// ```
@riverpod
ApiService apiService(ApiServiceRef ref) {
  final service = ApiService();
  service.initialize();
  service.refreshConfigIfNeeded();
  return service;
}