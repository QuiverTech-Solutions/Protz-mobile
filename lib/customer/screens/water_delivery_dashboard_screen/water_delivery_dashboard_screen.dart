import 'package:flutter/material.dart';
import '../towing_services_dashboard_screen/towing_services_dashboard.dart';

class WaterDeliveryDashboard extends StatelessWidget {
  const WaterDeliveryDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // Render the unified dashboard with Water selected by default
    return const TowingServicesDashboardScreen(
      initialService: ServiceType.water,
    );
  }
}
