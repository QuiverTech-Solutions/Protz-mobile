import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../shared/utils/pages.dart';
import 'widgets/towtruck_entry.dart';

class TowingCheckout extends StatefulWidget {
  final Map<String, dynamic>? towingData;

  const TowingCheckout({super.key, this.towingData});

  @override
  State<TowingCheckout> createState() => _TowingCheckoutState();
}

class _TowingCheckoutState extends State<TowingCheckout> {
  late Map<String, dynamic> data;
  int selectedOptionIndex = -1;
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('pickup'),
      position: LatLng(5.6037, -0.1870),
      infoWindow: InfoWindow(title: 'Accra New Town'),
    ),
    const Marker(
      markerId: MarkerId('destination'),
      position: LatLng(5.6140, -0.2460),
      infoWindow: InfoWindow(title: 'Mechanic shop'),
    ),
  };

  @override
  void initState() {
    super.initState();
    // Provide safe defaults if no data was passed
    data = widget.towingData ?? {
      'from': 'Accra Newtown',
      'to': 'Mr. Krabbs Mechanic Shop, Danfa',
      'vehicleType': 'Sedan',
      'urgency': 'Standard',
      'specialRequirements': 'None',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Map background
          /*Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(5.6037, -0.1870),
                zoom: 12.5,
              ),
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              polylines: {
                const Polyline(
                  polylineId: PolylineId('route'),
                  points: [
                    LatLng(5.6037, -0.1870),
                    LatLng(5.6140, -0.2460),
                  ],
                  color: Color(0xFF9AA4AA),
                  width: 4,
                ),
              },
              markers: _markers,
              onMapCreated: (c) => _mapController = c,
            ),
          ),*/

          // Top actions overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF086788)),
                    onPressed: () {
                      final from = Uri.encodeComponent('${data['from'] ?? ''}');
                      final to = Uri.encodeComponent('${data['to'] ?? ''}');
                      context.go('${AppRoutes.towingServicesScreen3}?pickupLocation=$from&destination=$to');
                    },
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Towing Services',
                    style: TextStyle(
                      color: Color(0xFF1B7B8C),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.history, color: Color(0xFF1B7B8C)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          // Draggable bottom sheet
          DraggableScrollableSheet(
            minChildSize: 0.35,
            initialChildSize: 0.45,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(color: Color(0x22000000), blurRadius: 12, offset: Offset(0, -4)),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    // Home indicator
                    Container(
                      width: 56,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select a Towing Service',
                      style: TextStyle(
                        color: Color(0xFF0F7F90),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        children: [
                          ..._buildProviderCards(),
                          const SizedBox(height: 90), // padding so last card isn't under overlay
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Fixed Proceed button overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                height: 100,
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _proceedButton(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Provider dataset and UI
  List<Map<String, dynamic>> _providers() => [
        {
          'title': 'Trucks4YourCars Towing Services',
          'eta': 2,
          'current': 276,
          'old': 290,
          'asset': 'assets/images/towing.png',
        },
        {
          'title': 'Owusu–Sasraku Towing Services',
          'eta': 17,
          'current': 310,
          'old': 350,
          'asset': 'assets/images/towing.png',
        },
        {
          'title': 'Fabrizio Trucks',
          'eta': 21,
          'current': 342,
          'old': null,
          'asset': 'assets/images/towing.png',
        },
        {
          'title': 'OperationClearRoads Towing',
          'eta': 30,
          'current': 389,
          'old': null,
          'asset': 'assets/images/towing.png',
        },
        {
          'title': 'Manaf Ibrahim & Co Towtrucks',
          'eta': 39,
          'current': 403,
          'old': null,
          'asset': 'assets/images/towing.png',
        },
      ];

  List<Widget> _buildProviderCards() {
    final items = _providers();
    return List.generate(items.length, (index) {
      final o = items[index];
      return Padding(
        padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 12),
        child: TowtruckEntry(
          title: o['title'] as String,
          subtitle: 'Will arrive at pickup in approximately ${o['eta']} mins',
          price: 'GHS ${o['current']}',
          oldPrice: o['old'] != null ? 'GHS ${o['old']}' : null,
          imageAsset: o['asset'] as String,
          selected: selectedOptionIndex == index,
          onTap: () => setState(() => selectedOptionIndex = index),
          onSelectPressed: () => setState(() => selectedOptionIndex = index),
        ),
      );
    });
  }

  Widget _chip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black87, fontSize: 12))),
        ],
      ),
    );
  }

  // Bottom sheet proceed button
  Widget _proceedButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF086788),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
          if (selectedOptionIndex < 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a towing service first')),
            );
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Proceeding to checkout with option #${selectedOptionIndex + 1}')),
          );
          // TODO: Navigate to payment screen when available
          // context.go(AppRoutes.payment);
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Proceed to checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded),
          ],
        ),
      ),
    );
  }

  // Removed summary/fare widgets to match design with map + sheet

  Widget _fareRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontWeight: bold ? FontWeight.w600 : FontWeight.w400))),
          Text(value, style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _payButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF086788),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment flow coming soon'), behavior: SnackBarBehavior.floating),
          );
          // Navigate to payment route when implemented
          // context.go(AppRoutes.payment);
        },
        child: const Text('Pay Now', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}