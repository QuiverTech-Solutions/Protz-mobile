// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recentOrdersHash() => r'e713c35047c6fb983a9c6b476fcfbb8931940de2';

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
///
/// Copied from [recentOrders].
@ProviderFor(recentOrders)
final recentOrdersProvider = AutoDisposeProvider<List<ServiceRequest>>.internal(
  recentOrders,
  name: r'recentOrdersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$recentOrdersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecentOrdersRef = AutoDisposeProviderRef<List<ServiceRequest>>;
String _$walletInfoHash() => r'ac259473f1375ae8347df5f174b5cb6af34ba40a';

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
///
/// Copied from [walletInfo].
@ProviderFor(walletInfo)
final walletInfoProvider = AutoDisposeProvider<WalletInfo?>.internal(
  walletInfo,
  name: r'walletInfoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$walletInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WalletInfoRef = AutoDisposeProviderRef<WalletInfo?>;
String _$userInfoHash() => r'6c63532b106f55712cfd47de1c49c580c1c97270';

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
///
/// Copied from [userInfo].
@ProviderFor(userInfo)
final userInfoProvider = AutoDisposeProvider<UserInfo?>.internal(
  userInfo,
  name: r'userInfoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserInfoRef = AutoDisposeProviderRef<UserInfo?>;
String _$serviceAvailabilityHash() =>
    r'1cfefbcd72ee5ed3fd91d7a1241b1de7a3eea2cd';

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
///
/// Copied from [serviceAvailability].
@ProviderFor(serviceAvailability)
final serviceAvailabilityProvider =
    AutoDisposeProvider<ServiceAvailability?>.internal(
  serviceAvailability,
  name: r'serviceAvailabilityProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$serviceAvailabilityHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ServiceAvailabilityRef = AutoDisposeProviderRef<ServiceAvailability?>;
String _$dashboardHash() => r'451ff6b8c22b501bfcd98b84db2323c4c0173e6a';

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
///
/// Copied from [Dashboard].
@ProviderFor(Dashboard)
final dashboardProvider =
    AutoDisposeNotifierProvider<Dashboard, DashboardState>.internal(
  Dashboard.new,
  name: r'dashboardProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dashboardHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Dashboard = AutoDisposeNotifier<DashboardState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
