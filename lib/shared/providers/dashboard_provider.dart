import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/dashboard_data.dart';
import '../models/service_request.dart';
import 'api_service_provider.dart';
import '../../auth/services/new_auth_service.dart';

part 'dashboard_provider.g.dart';

/// State class for dashboard data with loading and error states
/// 
/// This class encapsulates the dashboard data along with its loading
/// and error states, providing a comprehensive state management solution
/// for the home screen.
class DashboardState {
  final DashboardData? data;
  final bool isLoading;
  final String? error;
  final DateTime? lastUpdated;

  const DashboardState({
    this.data,
    this.isLoading = false,
    this.error,
    this.lastUpdated,
  });

  DashboardState copyWith({
    DashboardData? data,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return DashboardState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Check if data needs to be refreshed (older than 5 minutes)
  bool get needsRefresh {
    if (lastUpdated == null) return true;
    return DateTime.now().difference(lastUpdated!).inMinutes > 5;
  }

  /// Check if we have valid data
  bool get hasData => data != null && error == null;

  /// Check if we're in an error state
  bool get hasError => error != null;
}

final onlineStatusProvider = StateProvider<bool>((ref) => false);

/// Dashboard data provider with automatic refresh and error handling
/// 
/// This provider manages the dashboard data state, including loading,
/// error handling, and automatic refresh functionality. It provides
/// a reactive way to access dashboard data throughout the application.
/// 
/// Features:
/// - Automatic data loading on first access
/// - Error handling with user-friendly messages
/// - Manual refresh capability
/// - Automatic refresh when data is stale
/// - Loading state management
/// 
/// Usage:
/// ```dart
/// // Watch for dashboard state changes
/// final dashboardState = ref.watch(dashboardProvider);
/// 
/// // Manually refresh data
/// ref.read(dashboardProvider.notifier).refresh();
/// 
/// // Check loading state
/// if (dashboardState.isLoading) {
///   return CircularProgressIndicator();
/// }
/// 
/// // Handle error state
/// if (dashboardState.hasError) {
///   return ErrorWidget(dashboardState.error!);
/// }
/// 
/// // Use data
/// final dashboard = dashboardState.data!;
/// ```
@riverpod
class Dashboard extends _$Dashboard {
  @override
  DashboardState build() {
    // Schedule data loading after the provider is initialized
    Future.microtask(() => _loadDashboardData());
    return const DashboardState(isLoading: true);
  }

  /// Load dashboard data from API
  Future<void> _loadDashboardData() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      // Check if user is authenticated before making API call
      final authService = AuthService();
      final isAuthenticated = await authService.isAuthenticated();
      
      if (!isAuthenticated) {
        // User is not authenticated, set empty state
        state = DashboardState(
          data: null,
          isLoading: false,
          lastUpdated: DateTime.now(),
          error: null,
        );
        return;
      }
      
      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.getDashboardData();
      
      if (response.success && response.data != null) {
        state = DashboardState(
          data: response.data,
          isLoading: false,
          lastUpdated: DateTime.now(),
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load dashboard data: ${e.toString()}',
      );
    }
  }

  /// Manually refresh dashboard data
  /// 
  /// This method can be called to force a refresh of the dashboard data,
  /// useful for pull-to-refresh functionality or when user explicitly
  /// requests fresh data.
  Future<void> refresh() async {
    await _loadDashboardData();
  }

  /// Load data if it's stale or missing
  /// 
  /// This method checks if the current data needs refreshing and loads
  /// new data if necessary. It's useful for ensuring data freshness
  /// without forcing unnecessary API calls.
  Future<void> loadIfNeeded() async {
    if (state.needsRefresh) {
      await _loadDashboardData();
    }
  }

  /// Clear error state
  /// 
  /// This method clears any error state, useful when user acknowledges
  /// an error and wants to try again.
  void clearError() {
    if (state.hasError) {
      state = state.copyWith(error: null);
    }
  }
}

/// Provider for recent orders from dashboard data
/// 
/// This provider extracts and provides access to recent orders from
/// the dashboard data, making it easy to display order history in
/// various parts of the application.
/// 
/// Usage:
/// ```dart
/// final recentOrders = ref.watch(recentOrdersProvider);
/// ```
@riverpod
List<ServiceRequest> recentOrders(RecentOrdersRef ref) {
  final dashboardState = ref.watch(dashboardProvider);
  return dashboardState.data?.recentOrders ?? [];
}

/// Provider for wallet information from dashboard data
/// 
/// This provider extracts and provides access to wallet information
/// from the dashboard data, making it easy to display wallet balance
/// and transaction history.
/// 
/// Usage:
/// ```dart
/// final walletInfo = ref.watch(walletInfoProvider);
/// ```
@riverpod
WalletInfo? walletInfo(WalletInfoRef ref) {
  final dashboardState = ref.watch(dashboardProvider);
  return dashboardState.data?.wallet;
}

/// Provider for user information from dashboard data
/// 
/// This provider extracts and provides access to user information
/// from the dashboard data, making it easy to display user details
/// in the header and other components.
/// 
/// Usage:
/// ```dart
/// final userInfo = ref.watch(userInfoProvider);
/// ```
@riverpod
UserInfo? userInfo(UserInfoRef ref) {
  final dashboardState = ref.watch(dashboardProvider);
  return dashboardState.data?.user;
}

/// Provider for service availability from dashboard data
/// 
/// This provider extracts and provides access to service availability
/// information, making it easy to show/hide service options based on
/// current availability.
/// 
/// Usage:
/// ```dart
/// final serviceAvailability = ref.watch(serviceAvailabilityProvider);
/// ```
@riverpod
ServiceAvailability? serviceAvailability(ServiceAvailabilityRef ref) {
  final dashboardState = ref.watch(dashboardProvider);
  return dashboardState.data?.serviceAvailability;
}
