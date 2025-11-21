// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_types_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$towingServiceTypeHash() => r'cda06f987cdd6648bf40a906c6068ab3ec25d929';

/// See also [towingServiceType].
@ProviderFor(towingServiceType)
final towingServiceTypeProvider =
    AutoDisposeProvider<ServiceTypePublic?>.internal(
  towingServiceType,
  name: r'towingServiceTypeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$towingServiceTypeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TowingServiceTypeRef = AutoDisposeProviderRef<ServiceTypePublic?>;
String _$waterServiceTypeHash() => r'3d3e142d79d299b94ca63de2ef60da163b6b281c';

/// See also [waterServiceType].
@ProviderFor(waterServiceType)
final waterServiceTypeProvider =
    AutoDisposeProvider<ServiceTypePublic?>.internal(
  waterServiceType,
  name: r'waterServiceTypeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$waterServiceTypeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WaterServiceTypeRef = AutoDisposeProviderRef<ServiceTypePublic?>;
String _$serviceTypesHash() => r'280cc112fe9636edeb6c98001e57fb02363dcc50';

/// See also [ServiceTypes].
@ProviderFor(ServiceTypes)
final serviceTypesProvider = AutoDisposeNotifierProvider<ServiceTypes,
    AsyncValue<List<ServiceTypePublic>>>.internal(
  ServiceTypes.new,
  name: r'serviceTypesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$serviceTypesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ServiceTypes
    = AutoDisposeNotifier<AsyncValue<List<ServiceTypePublic>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
