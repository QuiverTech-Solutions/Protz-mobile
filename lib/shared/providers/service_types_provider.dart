import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/service_type.dart';
import 'api_service_provider.dart';

part 'service_types_provider.g.dart';

@riverpod
class ServiceTypes extends _$ServiceTypes {
  @override
  AsyncValue<List<ServiceTypePublic>> build() {
    _load();
    return const AsyncValue.loading();
  }

  Future<void> _load() async {
    final api = ref.read(apiServiceProvider);
    final res = await api.getActiveServiceTypes();
    if (res.success && res.data != null) {
      state = AsyncValue.data(res.data!);
    } else {
      state = AsyncValue.error(res.message, StackTrace.current);
    }
  }

  Future<void> refresh() => _load();
}

@riverpod
ServiceTypePublic? towingServiceType(TowingServiceTypeRef ref) {
  final async = ref.watch(serviceTypesProvider);
  return async.maybeWhen(
    data: (types) {
      try {
        return types.firstWhere((t) => t.code.toUpperCase() == 'TOWING');
      } catch (_) {
        return null;
      }
    },
    orElse: () => null,
  );
}

@riverpod
ServiceTypePublic? waterServiceType(WaterServiceTypeRef ref) {
  final async = ref.watch(serviceTypesProvider);
  return async.maybeWhen(
    data: (types) {
      try {
        return types.firstWhere((t) => t.code.toUpperCase() == 'WATER');
      } catch (_) {
        return null;
      }
    },
    orElse: () => null,
  );
}