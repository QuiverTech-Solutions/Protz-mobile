import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/service_provider.dart';
import 'api_service_provider.dart';

part 'service_providers_provider.g.dart';

/// Parameters for fetching service providers
class ServiceProvidersParams {
  final String serviceType;
  final double? latitude;
  final double? longitude;
  final double? radius;

  const ServiceProvidersParams({
    required this.serviceType,
    this.latitude,
    this.longitude,
    this.radius,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceProvidersParams &&
          runtimeType == other.runtimeType &&
          serviceType == other.serviceType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          radius == other.radius;

  @override
  int get hashCode =>
      serviceType.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      radius.hashCode;
}

/// State class for service providers with loading and error states
class ServiceProvidersState {
  final List<ServiceProvider> providers;
  final bool isLoading;
  final String? error;
  final DateTime? lastUpdated;
  final ServiceProvidersParams? lastParams;

  const ServiceProvidersState({
    this.providers = const [],
    this.isLoading = false,
    this.error,
    this.lastUpdated,
    this.lastParams,
  });

  ServiceProvidersState copyWith({
    List<ServiceProvider>? providers,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
    ServiceProvidersParams? lastParams,
  }) {
    return ServiceProvidersState(
      providers: providers ?? this.providers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      lastParams: lastParams ?? this.lastParams,
    );
  }

  /// Check if data needs to be refreshed (older than 2 minutes for location-based data)
  bool get needsRefresh {
    if (lastUpdated == null) return true;
    return DateTime.now().difference(lastUpdated!).inMinutes > 2;
  }

  /// Check if we have valid data
  bool get hasData => providers.isNotEmpty && error == null;

  /// Check if we're in an error state
  bool get hasError => error != null;

  /// Get available providers (filtered by availability)
  List<ServiceProvider> get availableProviders =>
      providers.where((provider) => provider.isAvailable).toList();

  /// Get providers sorted by rating (highest first)
  List<ServiceProvider> get providersByRating =>
      [...providers]..sort((a, b) => b.rating.compareTo(a.rating));

  /// Get providers sorted by estimated arrival time
  List<ServiceProvider> get providersByArrivalTime {
    final providersWithETA = providers
        .where((provider) => provider.estimatedArrival != null)
        .toList();
    providersWithETA.sort((a, b) => 
        a.estimatedArrival!.compareTo(b.estimatedArrival!));
    return providersWithETA;
  }
}

/// Service providers provider with location-based filtering
/// 
/// This provider manages service providers data with support for
/// location-based filtering, automatic refresh, and various sorting options.
/// It's designed to handle both towing and water delivery service providers.
/// 
/// Features:
/// - Location-based provider filtering
/// - Automatic data refresh for location-sensitive data
/// - Multiple sorting options (rating, arrival time, etc.)
/// - Error handling with retry capability
/// - Loading state management
/// - Availability filtering
/// 
/// Usage:
/// ```dart
/// // Watch for providers state changes
/// final providersState = ref.watch(serviceProvidersProvider);
/// 
/// // Load providers for specific service type and location
/// ref.read(serviceProvidersProvider.notifier).loadProviders(
///   ServiceProvidersParams(
///     serviceType: 'towing',
///     latitude: 5.6037,
///     longitude: -0.1870,
///     radius: 10.0,
///   ),
/// );
/// 
/// // Get available providers
/// final availableProviders = providersState.availableProviders;
/// ```
@riverpod
class ServiceProviders extends _$ServiceProviders {
  @override
  ServiceProvidersState build() {
    return const ServiceProvidersState();
  }

  /// Load service providers based on parameters
  Future<void> loadProviders(ServiceProvidersParams params) async {
    try {
      // Don't reload if we have recent data for the same parameters
      if (state.lastParams == params && !state.needsRefresh && state.hasData) {
        return;
      }

      state = state.copyWith(isLoading: true, error: null);
      
      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.getServiceProviders(
        serviceType: params.serviceType,
        latitude: params.latitude,
        longitude: params.longitude,
        radius: params.radius,
      );
      
      if (response.success && response.data != null) {
        state = ServiceProvidersState(
          providers: response.data!,
          isLoading: false,
          lastUpdated: DateTime.now(),
          lastParams: params,
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
        error: 'Failed to load service providers: ${e.toString()}',
      );
    }
  }

  /// Refresh current providers data
  Future<void> refresh() async {
    if (state.lastParams != null) {
      await loadProviders(state.lastParams!);
    }
  }

  /// Clear providers data
  void clear() {
    state = const ServiceProvidersState();
  }

  /// Clear error state
  void clearError() {
    if (state.hasError) {
      state = state.copyWith(error: null);
    }
  }

  /// Filter providers by minimum rating
  List<ServiceProvider> getProvidersByMinRating(double minRating) {
    return state.providers
        .where((provider) => provider.rating >= minRating)
        .toList();
  }

  /// Get providers within price range
  List<ServiceProvider> getProvidersInPriceRange(double minPrice, double maxPrice) {
    return state.providers
        .where((provider) => 
            provider.basePrice >= minPrice && provider.basePrice <= maxPrice)
        .toList();
  }
}

/// Provider for towing service providers
/// 
/// This is a convenience provider that automatically loads towing
/// service providers. It can be used when you specifically need
/// towing providers without manually specifying the service type.
/// 
/// Usage:
/// ```dart
/// final towingProviders = ref.watch(towingProvidersProvider);
/// ```
@riverpod
Future<List<ServiceProvider>> towingProviders(TowingProvidersRef ref) async {
  final serviceProviders = ref.watch(serviceProvidersProvider.notifier);
  
  await serviceProviders.loadProviders(
    const ServiceProvidersParams(serviceType: 'towing'),
  );
  
  final state = ref.watch(serviceProvidersProvider);
  if (state.hasError) {
    throw Exception(state.error);
  }
  
  return state.providers;
}

/// Provider for water delivery service providers
/// 
/// This is a convenience provider that automatically loads water delivery
/// service providers. It can be used when you specifically need water
/// delivery providers without manually specifying the service type.
/// 
/// Usage:
/// ```dart
/// final waterDeliveryProviders = ref.watch(waterDeliveryProvidersProvider);
/// ```
@riverpod
Future<List<ServiceProvider>> waterDeliveryProviders(WaterDeliveryProvidersRef ref) async {
  final serviceProviders = ref.watch(serviceProvidersProvider.notifier);
  
  await serviceProviders.loadProviders(
    const ServiceProvidersParams(serviceType: 'water_delivery'),
  );
  
  final state = ref.watch(serviceProvidersProvider);
  if (state.hasError) {
    throw Exception(state.error);
  }
  
  return state.providers;
}