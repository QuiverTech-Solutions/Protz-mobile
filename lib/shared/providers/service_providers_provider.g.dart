// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_providers_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$towingProvidersHash() => r'5bf17cb5da25e9794ec38e2b8858be3811ade6dc';

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
///
/// Copied from [towingProviders].
@ProviderFor(towingProviders)
final towingProvidersProvider =
    AutoDisposeFutureProvider<List<ServiceProvider>>.internal(
  towingProviders,
  name: r'towingProvidersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$towingProvidersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TowingProvidersRef
    = AutoDisposeFutureProviderRef<List<ServiceProvider>>;
String _$waterDeliveryProvidersHash() =>
    r'18c7e374aea9769f237a51978aff7d933e1327e3';

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
///
/// Copied from [waterDeliveryProviders].
@ProviderFor(waterDeliveryProviders)
final waterDeliveryProvidersProvider =
    AutoDisposeFutureProvider<List<ServiceProvider>>.internal(
  waterDeliveryProviders,
  name: r'waterDeliveryProvidersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$waterDeliveryProvidersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WaterDeliveryProvidersRef
    = AutoDisposeFutureProviderRef<List<ServiceProvider>>;
String _$serviceProvidersHash() => r'a2db63a25666262f8d631fe4ae6011d388867c0b';

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
///
/// Copied from [ServiceProviders].
@ProviderFor(ServiceProviders)
final serviceProvidersProvider = AutoDisposeNotifierProvider<ServiceProviders,
    ServiceProvidersState>.internal(
  ServiceProviders.new,
  name: r'serviceProvidersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$serviceProvidersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ServiceProviders = AutoDisposeNotifier<ServiceProvidersState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
