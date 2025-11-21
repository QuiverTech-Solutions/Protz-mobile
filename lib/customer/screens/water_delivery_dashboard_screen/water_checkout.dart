import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../shared/utils/pages.dart';
import '../../../shared/providers/api_service_provider.dart';
import '../../../shared/providers/service_types_provider.dart';
import '../../../shared/providers/service_providers_provider.dart';
import '../../../shared/utils/app_constants.dart';
import '../towing_services_dashboard_screen/widgets/checkout_actions.dart';
import '../../../shared/widgets/notifications_icon_button.dart';
import '../towing_services_dashboard_screen/widgets/towtruck_entry.dart';

class WaterCheckout extends ConsumerStatefulWidget {
  final Map<String, dynamic>? waterData;
  const WaterCheckout({super.key, this.waterData});

  @override
  ConsumerState<WaterCheckout> createState() => _WaterCheckoutState();
}

class _WaterCheckoutState extends ConsumerState<WaterCheckout> {
  late Map<String, dynamic> data;
  int selectedOptionIndex = -1;
  GoogleMapController? _mapController;
  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude),
    zoom: 12.5,
  );
  final Set<Marker> _markers =  {
    Marker(
      markerId: MarkerId('delivery'),
      position: LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude),
      infoWindow: InfoWindow(title: 'Delivery area'),
    ),
  };

  @override
  void initState() {
    super.initState();
    data = widget.waterData ?? {
      'pickupLocation': 'Accra Newtown',
      'destination': 'Mr. Krabbs Mechanic Shop, Danfa',
      'quantity': '0',
      'instructions': '',
    };
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
              initialCameraPosition: _initialCamera,
              markers: _markers,
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (c) => _mapController = c,
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
                      final pickup = Uri.encodeComponent('${data['pickupLocation'] ?? ''}');
                      final dest = Uri.encodeComponent('${data['destination'] ?? ''}');
                      context.go('${AppRoutes.waterDeliveryScreen2}?pickupLocation=$pickup&destination=$dest');
                    },
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Water Delivery',
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
                      'Select a Water Delivery Provider',
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
                          final providersState = ref.watch(serviceProvidersProvider);
                          final waterType = ref.watch(waterServiceTypeProvider);
                          final waterTypeId = waterType?.id;
                          if (waterTypeId != null && !providersState.isLoading && providersState.providers.isEmpty) {
                            ref.read(serviceProvidersProvider.notifier).loadActiveProvidersByTypeId(
                              serviceTypeId: waterTypeId,
                              latitude: AppConstants.defaultLatitude,
                              longitude: AppConstants.defaultLongitude,
                              limit: 20,
                            );
                          }
                          if (providersState.isLoading) {
                            return const Center(child: CircularProgressIndicator());
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
                                  subtitle: 'Will deliver in approximately ${p.estimatedArrival ?? '-'} mins',
                                  price: 'GHS ${p.basePrice.toStringAsFixed(0)}',
                                  oldPrice: null,
                                  imageAsset: 'assets/images/water_tank.png',
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

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              final pickup = Uri.encodeComponent('${data['pickupLocation'] ?? ''}');
              context.go('${AppRoutes.waterDeliveryScreen2}?pickupLocation=$pickup&destination=${Uri.encodeComponent('${data['destination'] ?? ''}')}');
            },
            child: const Icon(Icons.arrow_back, color: Color(0xFF086788)),
          ),
          const SizedBox(width: 6),
          const Text('Water Delivery', style: TextStyle(color: Color(0xFF1B7B8C), fontSize: 20, fontWeight: FontWeight.w600)),
          const Spacer(),
          const NotificationsIconButton(),
        ],
      ),
    );
  }

  Widget _summaryChips() {
    return Row(
      children: [
        Expanded(child: _chip('To', (data['destination'] ?? '').toString())),
        const SizedBox(width: 8),
        Expanded(child: _chip('Quantity', '${data['quantity'] ?? '0'} Gallons')),
      ],
    );
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
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a provider')));
            return;
          }
          final api = ref.read(apiServiceProvider);
          final profileRes = await api.getProfileMe();
          if (!profileRes.success || profileRes.data == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch profile: ${profileRes.message}')));
            return;
          }
          final profileId = (profileRes.data!['id'] ?? profileRes.data!['profile_id'] ?? '').toString();
          if (profileId.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile id missing')));
            return;
          }
          await ref.read(serviceTypesProvider.notifier).refresh();
          final water = ref.read(waterServiceTypeProvider);
          if (water == null) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Water service type unavailable')));
            return;
          }
          final quantityGallons = int.tryParse((data['quantity'] ?? '0').toString()) ?? 0;
          if (quantityGallons < 1) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a valid water quantity')));
            return;
          }
          final now = DateTime.now().toUtc().toIso8601String();
          final baseReq = {
            'profile_id': profileId,
            'service_type_id': water.id,
            'pickup_address': ((data['pickupLocation'] ?? '').toString().isEmpty ? 'Water Supplier Station' : (data['pickupLocation'] ?? '').toString()),
            'pickup_latitude': AppConstants.defaultLatitude,
            'pickup_longitude': AppConstants.defaultLongitude,
            'destination_address': (data['destination'] ?? '').toString(),
            'destination_lat': AppConstants.defaultLatitude,
            'destination_lng': AppConstants.defaultLongitude,
            'special_instructions': (data['instructions'] ?? '').toString(),
            'requested_at': now,
          };
          final createRes = await api.createServiceRequestV1(data: baseReq);
          if (!createRes.success || createRes.data == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create request: ${createRes.message}')));
            return;
          }
          final sr = createRes.data!;
          final serviceRequestId = (sr['id'] ?? sr['service_request_id'] ?? '').toString();
          final waterPayload = {
            'service_request_id': serviceRequestId,
            'quantity_gallons': quantityGallons,
            'water_type': 'potable',
            'delivery_method': (data['deliveryMethod'] ?? 'polytank').toString(),
          };
          final waterRes = await api.createWaterRequest(data: waterPayload);
          if (!waterRes.success) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create water details: ${waterRes.message}')));
            return;
          }
          final providersState = ref.read(serviceProvidersProvider);
          final amount = (selectedOptionIndex >= 0 && providersState.providers.isNotEmpty && selectedOptionIndex < providersState.providers.length)
              ? providersState.providers[selectedOptionIndex].basePrice
              : 0.0;
          final nextData = {
            ...data,
            'serviceRequestId': serviceRequestId,
            'requestNumber': (sr['request_number'] ?? '').toString(),
            'selectedProviderIndex': selectedOptionIndex,
            'amount': amount,
          };
          context.go(AppRoutes.waterCheckout2, extra: nextData);
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
}