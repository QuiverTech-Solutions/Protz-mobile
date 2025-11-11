import 'package:flutter_test/flutter_test.dart';
import 'package:protz/service_provider/core/controllers/provider_availability_controller.dart';

void main() {
  group('ProviderAvailabilityController', () {
    test('initial state is respected', () {
      final c1 = ProviderAvailabilityController(initialOnline: true);
      expect(c1.isOnline, isTrue);
      final c2 = ProviderAvailabilityController(initialOnline: false);
      expect(c2.isOnline, isFalse);
    });

    test('toggle switches state and notifies listeners', () {
      final controller = ProviderAvailabilityController(initialOnline: true);
      int notified = 0;
      controller.addListener(() => notified++);
      controller.toggle();
      expect(controller.isOnline, isFalse);
      expect(notified, 1);
      controller.toggle();
      expect(controller.isOnline, isTrue);
      expect(notified, 2);
    });

    test('setOnline sets specific value and notifies when changed', () {
      final controller = ProviderAvailabilityController(initialOnline: true);
      int notified = 0;
      controller.addListener(() => notified++);
      controller.setOnline(true);
      expect(controller.isOnline, isTrue);
      expect(notified, 0); // unchanged
      controller.setOnline(false);
      expect(controller.isOnline, isFalse);
      expect(notified, 1);
    });
  });
}