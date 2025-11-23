import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import '../../../shared/utils/env.dart';
import '../../../shared/utils/pages.dart';
import 'widgets/towtruck_entry.dart';
import '../../../shared/providers/api_service_provider.dart';
import '../../../shared/providers/service_types_provider.dart';
import '../../../shared/providers/service_providers_provider.dart';

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
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  bool _providersRequested = false;

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
      'pickupLat': 5.6037,
      'pickupLng': -0.1870,
      'destinationLat': 5.6140,
      'destinationLng': -0.2460,
    };
    _configureRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Map background
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _asDouble(data['pickupLat'], 5.6037),
                  _asDouble(data['pickupLng'], -0.1870),
                ),
                zoom: 12.5,
              ),
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              polylines: _polylines,
              markers: _markers,
              onMapCreated: (c) {
                _mapController = c;
                _fitBounds();
              },
            ),
          ),

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
                      final dLat = Uri.encodeComponent('${data['destinationLat'] ?? ''}');
                      final dLng = Uri.encodeComponent('${data['destinationLng'] ?? ''}');
                      context.go('${AppRoutes.towingServicesScreen3}?pickupLocation=$from&destination=$to&destinationLat=$dLat&destinationLng=$dLng');
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
                      child: Consumer(
                        builder: (context, ref, _) {
                          final types = ref.watch(serviceTypesProvider);
                          final towingType = ref.watch(towingServiceTypeProvider);
                          final providersState = ref.watch(serviceProvidersProvider);

                          // Trigger load when we have serviceTypeId
                          final towingTypeId = towingType?.id;
                          if (!_providersRequested && towingTypeId != null && !providersState.isLoading && providersState.providers.isEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              final lat = _asDouble(data['pickupLat'], 5.6037);
                              final lng = _asDouble(data['pickupLng'], -0.1870);
                              ref.read(serviceProvidersProvider.notifier).loadActiveProvidersByTypeId(
                                serviceTypeId: towingTypeId,
                                latitude: lat,
                                longitude: lng,
                                limit: 20,
                              );
                              _providersRequested = true;
                            });
                          }

                          if (types.isLoading || providersState.isLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (types.hasError) {
                            return Center(child: Text('Failed to load service types'));
                          }
                          if (providersState.hasError) {
                            return Center(child: Text(providersState.error ?? 'Failed to load providers'));
                          }

                          final items = providersState.providers;
                          if (items.isEmpty) {
                            return const Center(child: Text('No providers available'));
                          }
                          return ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final p = items[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 12),
                                child: TowtruckEntry(
                                  title: p.name,
                                  subtitle: 'Will arrive at pickup in approximately ${p.estimatedArrival ?? '-'} mins',
                                  price: 'GHS ${p.basePrice.toStringAsFixed(0)}',
                                  oldPrice: null,
                                  imageAsset: 'assets/images/towing.png',
                                  selected: selectedOptionIndex == index,
                                  onTap: () => setState(() => selectedOptionIndex = index),
                                  onSelectPressed: () => setState(() => selectedOptionIndex = index),
                                ),
                              );
                            },
                          );
                        },
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
                    child: Consumer(builder: (context, ref, _) {
                      return _proceedButton(ref);
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _configureRoute() {
    final pickupLat = _asDouble(data['pickupLat'], 5.6037);
    final pickupLng = _asDouble(data['pickupLng'], -0.1870);
    final destLat = _asDouble(data['destinationLat'], 5.6140);
    final destLng = _asDouble(data['destinationLng'], -0.2460);
    final pickup = LatLng(pickupLat, pickupLng);
    final dest = LatLng(destLat, destLng);
    _markers
      ..clear()
      ..add(Marker(markerId: const MarkerId('pickup'), position: pickup, infoWindow: InfoWindow(title: (data['from'] ?? '').toString())))
      ..add(Marker(markerId: const MarkerId('destination'), position: dest, infoWindow: InfoWindow(title: (data['to'] ?? '').toString())));
    _polylines.clear();
    _loadRoadPolyline(pickup, dest);
  }

  void _fitBounds() {
    final pickupLat = _asDouble(data['pickupLat'], 5.6037);
    final pickupLng = _asDouble(data['pickupLng'], -0.1870);
    final destLat = _asDouble(data['destinationLat'], 5.6140);
    final destLng = _asDouble(data['destinationLng'], -0.2460);
    final southWest = LatLng(
      pickupLat < destLat ? pickupLat : destLat,
      pickupLng < destLng ? pickupLng : destLng,
    );
    final northEast = LatLng(
      pickupLat > destLat ? pickupLat : destLat,
      pickupLng > destLng ? pickupLng : destLng,
    );
    final bounds = LatLngBounds(southwest: southWest, northeast: northEast);
    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
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
  Widget _proceedButton(WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF086788),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () async {
          if (selectedOptionIndex < 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a towing service first')),
            );
            return;
          }
          final api = ref.read(apiServiceProvider);
          // Get profile_id
          final profileRes = await api.getProfileMe();
          if (!profileRes.success || profileRes.data == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to fetch profile: ${profileRes.message}')),
            );
            return;
          }
          final profileId = (profileRes.data!['id'] ?? profileRes.data!['profile_id'] ?? '').toString();
          if (profileId.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile id missing')));
            return;
          }
          // Get service type id
          final towingType = ref.read(towingServiceTypeProvider);
          if (towingType == null) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Towing service type unavailable')));
            return;
          }
          // Compose base service request
          final now = DateTime.now().toUtc().toIso8601String();
          final pickupLat = _asDouble(data['pickupLat'], 5.6037);
          final pickupLng = _asDouble(data['pickupLng'], -0.1870);
          final destLat = _asDouble(data['destinationLat'], 5.6140);
          final destLng = _asDouble(data['destinationLng'], -0.2460);
          final baseReq = {
            'profile_id': profileId,
            'service_type_id': towingType.id,
            'pickup_address': (data['from'] ?? '').toString(),
            'pickup_latitude': pickupLat,
            'pickup_longitude': pickupLng,
            'destination_address': (data['to'] ?? '').toString(),
            'destination_lat': destLat,
            'destination_lng': destLng,
            'special_instructions': (data['specialRequirements'] ?? '').toString(),
            'requested_at': now,
          };
          final createRes = await api.createServiceRequestV1(data: baseReq);
          if (!createRes.success || createRes.data == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to create request: ${createRes.message}')),
            );
            return;
          }
          final sr = createRes.data!;
          final serviceRequestId = (sr['id'] ?? sr['service_request_id'] ?? '').toString();
          final requestNumber = (sr['request_number'] ?? '').toString();
          // Create towing-specific request
          final towingPayload = {
            'service_request_id': serviceRequestId,
            'vehicle_id': null,
            'towing_type_id': data['towingTypeId'],
            'vehicle_condition': 'accident',
            'is_emergency': false,
          };
          final towingRes = await api.createTowingRequest(data: towingPayload);
          if (!towingRes.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to create towing details: ${towingRes.message}')),
            );
            return;
          }
          final towingDetailsRes = await api.getTowingRequestByServiceRequest(serviceRequestId);
          final towingRequestId = towingDetailsRes.success ? (towingDetailsRes.data?['id']?.toString() ?? '') : '';
          final nextData = {
            ...data,
            'serviceRequestId': serviceRequestId,
            'requestNumber': requestNumber,
            'selectedProviderIndex': selectedOptionIndex,
            if (towingRequestId.isNotEmpty) 'towingRequestId': towingRequestId,
          };
          context.go(AppRoutes.towingCheckout2, extra: nextData);
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

  double _asDouble(dynamic v, double fallback) {
    if (v is num) return v.toDouble();
    if (v is String) {
      final parsed = double.tryParse(v);
      if (parsed != null) return parsed;
    }
    return fallback;
  }

  Future<void> _loadRoadPolyline(LatLng origin, LatLng destination) async {
    try {
      if (Env.googleMapsApiKey.isNotEmpty) {
        final dio = Dio(BaseOptions(headers: {'User-Agent': 'protz-app'}));
        final resp = await dio.get(
          'https://maps.googleapis.com/maps/api/directions/json',
          queryParameters: {
            'origin': '${origin.latitude},${origin.longitude}',
            'destination': '${destination.latitude},${destination.longitude}',
            'mode': 'driving',
            'key': Env.googleMapsApiKey,
          },
        );
        final routes = resp.data is Map<String, dynamic> ? (resp.data['routes'] as List?) : null;
        if (routes != null && routes.isNotEmpty) {
          final overview = routes.first['overview_polyline'] as Map<String, dynamic>?;
          final pointsStr = overview?['points'] as String?;
          final points = pointsStr != null ? _decodePolyline(pointsStr) : <LatLng>[];
          if (points.isNotEmpty) {
            setState(() {
              _polylines.add(Polyline(
                polylineId: const PolylineId('route'),
                points: points,
                color: const Color(0xFF1B7A8A),
                width: 5,
              ));
            });
            return;
          }
        }
      }
    } catch (_) {}
    setState(() {
      _polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        points: [origin, destination],
        color: const Color(0xFF9AA4AA),
        width: 4,
      ));
    });
  }

  List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      final latD = lat / 1e5;
      final lngD = lng / 1e5;
      poly.add(LatLng(latD, lngD));
    }
    return poly;
  }
  }
