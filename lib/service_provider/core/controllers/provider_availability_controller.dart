import 'package:flutter/foundation.dart';

/// Controller managing the provider's availability (online/offline) state.
/// Keeps UI and business logic separate and testable.
class ProviderAvailabilityController extends ChangeNotifier {
  ProviderAvailabilityController({bool initialOnline = true})
      : _isOnline = initialOnline;

  bool _isOnline;

  bool get isOnline => _isOnline;

  /// Toggle availability and notify listeners.
  void toggle() {
    _isOnline = !_isOnline;
    notifyListeners();
  }

  /// Explicitly set availability status.
  void setOnline(bool value) {
    if (_isOnline == value) return;
    _isOnline = value;
    notifyListeners();
  }
}