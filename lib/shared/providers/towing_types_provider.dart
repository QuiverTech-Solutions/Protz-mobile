import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/towing_type.dart';
import 'api_service_provider.dart';

part 'towing_types_provider.g.dart';

@riverpod
class TowingTypes extends _$TowingTypes {
  @override
  AsyncValue<List<TowingTypePublic>> build() {
    _load();
    return const AsyncValue.loading();
  }

  Future<void> _load() async {
    final api = ref.read(apiServiceProvider);
    final res = await api.getActiveTowingTypes();
    if (res.success && res.data != null) {
      state = AsyncValue.data(res.data!);
    } else {
      state = AsyncValue.error(res.message, StackTrace.current);
    }
  }

  Future<void> refresh() => _load();
}