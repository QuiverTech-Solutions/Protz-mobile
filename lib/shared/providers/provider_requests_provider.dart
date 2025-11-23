import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/service_request.dart';
import 'api_service_provider.dart';

part 'provider_requests_provider.g.dart';

class ProviderRequestsState {
  final List<ServiceRequest> active;
  final List<ServiceRequest> completed;
  final bool isLoading;
  final String? error;
  final DateTime? lastUpdated;

  const ProviderRequestsState({
    this.active = const [],
    this.completed = const [],
    this.isLoading = false,
    this.error,
    this.lastUpdated,
  });

  ProviderRequestsState copyWith({
    List<ServiceRequest>? active,
    List<ServiceRequest>? completed,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return ProviderRequestsState(
      active: active ?? this.active,
      completed: completed ?? this.completed,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  bool get hasError => error != null;
}

@riverpod
class ProviderRequests extends _$ProviderRequests {
  @override
  ProviderRequestsState build() {
    Future.microtask(() => loadActive());
    return const ProviderRequestsState(isLoading: true);
  }

  Future<void> loadActive() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final api = ref.read(apiServiceProvider);
      final profile = await api.getMyServiceProviderProfile();
      if (!profile.success) {
        state = state.copyWith(
          isLoading: false,
          error: profile.message.isNotEmpty ? profile.message : 'Insufficient permissions',
        );
        return;
      }
      /*final data = profile.data ?? const <String, dynamic>{};
      final bool isActive = data['is_active'] == true;
      final String verification = (data['verification_status'] ?? '').toString();
      final bool isApproved = verification.toLowerCase() == 'approved';
      if (!isActive || !isApproved) {
        state = state.copyWith(
          isLoading: false,
          error: !isActive
              ? 'Your provider account is not active.'
              : 'Your provider verification is not approved.',
        );
        return;
      }*/
      final assigned = await api.getAssignedToMeRequests(status: 'assigned');
      final inProgress = await api.getAssignedToMeRequests(status: 'in_progress');
      if (assigned.success || inProgress.success) {
        final List<ServiceRequest> list = [
          ...assigned.data ?? const <ServiceRequest>[],
          ...inProgress.data ?? const <ServiceRequest>[],
        ];
        state = state.copyWith(
          active: list,
          isLoading: false,
          lastUpdated: DateTime.now(),
        );
      } else {
        state = state.copyWith(isLoading: false, error: assigned.message.isNotEmpty ? assigned.message : inProgress.message);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load active requests: ${e.toString()}',
      );
    }
  }

  Future<void> loadCompleted() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final api = ref.read(apiServiceProvider);
      final res = await api.getAssignedToMeRequests(status: 'completed');
      if (res.success && res.data != null) {
        state = state.copyWith(
          completed: res.data!,
          isLoading: false,
          lastUpdated: DateTime.now(),
        );
      } else {
        state = state.copyWith(isLoading: false, error: res.message);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load completed requests: ${e.toString()}',
      );
    }
  }

  Future<void> start(String requestId) async {
    try {
      final api = ref.read(apiServiceProvider);
      final res = await api.updateRequestStatus(requestId: requestId, status: 'in_progress');
      if (res.success && res.data != null) {
        final updated = state.active.map((r) => r.id == requestId ? res.data! : r).toList();
        state = state.copyWith(active: updated, lastUpdated: DateTime.now());
      } else {
        state = state.copyWith(error: res.message);
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to start request: ${e.toString()}',
      );
    }
  }

  Future<void> complete(String requestId) async {
    try {
      final api = ref.read(apiServiceProvider);
      final res = await api.updateRequestStatus(requestId: requestId, status: 'completed');
      if (res.success && res.data != null) {
        final remaining = state.active.where((r) => r.id != requestId).toList();
        final completed = [res.data!, ...state.completed];
        state = state.copyWith(active: remaining, completed: completed, lastUpdated: DateTime.now());
      } else {
        state = state.copyWith(error: res.message);
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to complete request: ${e.toString()}',
      );
    }
  }

  Future<void> refresh() async {
    await loadActive();
    await loadCompleted();
  }

  void clearError() {
    if (state.hasError) {
      state = state.copyWith(error: null);
    }
  }
}