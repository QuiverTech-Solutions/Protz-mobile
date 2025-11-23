import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../shared/utils/env.dart';
import '../../core/utils/size_utils.dart';
import '../../../shared/widgets/custom_sliver_app_bar.dart';
import '../../../shared/utils/pages.dart';

class WaterDeliveryScreen1 extends StatefulWidget {
  final String? destination;
  
  const WaterDeliveryScreen1({
    super.key,
    this.destination,
  });
  
  @override
  State<WaterDeliveryScreen1> createState() => _WaterDeliveryScreen1State();
}

class _WaterDeliveryScreen1State extends State<WaterDeliveryScreen1> {
  final TextEditingController _destinationController = TextEditingController();
  GoogleMapController? _mapController;
  final List<Map<String, dynamic>> _suggestions = [];
  Timer? _debounce;
  double? _selectedLat;
  double? _selectedLng;
  
  // Default location (Accra, Ghana)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(5.6037, -0.1870),
    zoom: 14.0,
  );

  final Set<Marker> _markers = {};

  @override
  void dispose() {
    _destinationController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: 'Water Delivery',
            onBackPressed: () => context.go(AppRoutes.waterDeliveryDashboard),
            onHistoryPressed: () {
              context.push(AppRoutes.history);
            },
          ),
          SliverFillRemaining(
            child: Stack(
              children: [
                // Map background
                _buildMapView(),
                
                // Bottom sheet
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _buildBottomSection(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
          // Dimming overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
  Widget _buildBottomSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            const Text(
              'To where should the water be delivered?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 20),

            _buildDestinationInput(),
            const SizedBox(height: 8),
            _suggestionsList(),
            const SizedBox(height: 20),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E5EA),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _destinationController,
        style: TextStyle(
          fontSize: 16,
          color: const Color(0xFF1C1C1E),
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: 'Enter the destination for the water delivery',
          hintStyle: TextStyle(
            fontSize: 14,
            color: const Color(0xFF8E8E93),
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.flag_outlined,
            color: const Color(0xFF8E8E93),
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        onChanged: (val) {
          _onQueryChanged(val);
        },
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (_destinationController.text.trim().isEmpty) {
            _showSnackBar('Please enter delivery address');
            return;
          }
          
          // Navigate to next screen
          final pickupLocation = '';
          final destination = _destinationController.text.trim();
          context.go('/water-delivery-screen2?pickupLocation=${Uri.encodeComponent(pickupLocation)}&destination=${Uri.encodeComponent(destination)}');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B7A8A),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Continue',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildHomeIndicator() {
    return SizedBox(
      height: SizeUtils.height * 0.04,
      child: Center(
        child: Container(
          width: SizeUtils.width * 0.35,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  void _onQueryChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (q.trim().length < 2) {
        setState(() => _suggestions.clear());
        return;
      }
      _fetchSuggestions(q.trim());
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    try {
      final dio = Dio(BaseOptions(headers: {'User-Agent': 'protz-app'}));
      final apiKey = Env.googleMapsApiKey;
      if (apiKey.isNotEmpty) {
        final resp = await dio.get(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json',
          queryParameters: {
            'input': query,
            'key': apiKey,
            'components': 'country:gh',
            'types': 'geocode',
          },
        );
        final List preds = resp.data is Map<String, dynamic>
            ? (resp.data['predictions'] ?? [])
            : [];
        final list = preds
            .map<Map<String, dynamic>>((p) => {
                  'title': p['description']?.toString() ?? '',
                  'placeId': p['place_id']?.toString() ?? '',
                })
            .where((m) => (m['title'] as String).isNotEmpty && (m['placeId'] as String).isNotEmpty)
            .toList();
        setState(() => _suggestions..clear()..addAll(list));
      } else {
        final resp = await dio.get(
          'https://nominatim.openstreetmap.org/search',
          queryParameters: {'format': 'json', 'q': query, 'limit': 5, 'countrycodes': 'gh'},
        );
        final List data = resp.data is List ? resp.data as List : [];
        final list = data
            .map<Map<String, dynamic>>((e) => {
                  'title': e['display_name']?.toString() ?? '',
                  'lat': double.tryParse(e['lat']?.toString() ?? ''),
                  'lng': double.tryParse(e['lon']?.toString() ?? ''),
                })
            .where((m) => m['lat'] != null && m['lng'] != null)
            .toList();
        setState(() => _suggestions..clear()..addAll(list));
      }
    } catch (_) {
      setState(() => _suggestions.clear());
    }
  }

  Widget _suggestionsList() {
    if (_suggestions.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E5EA)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _suggestions.length,
        itemBuilder: (context, i) {
          final s = _suggestions[i];
          return ListTile(
            dense: true,
            title: Text(s['title'] as String, maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () async {
              _destinationController.text = s['title'] as String;
              final apiKey = Env.googleMapsApiKey;
              if (apiKey.isNotEmpty && s['placeId'] != null) {
                try {
                  final dio = Dio(BaseOptions(headers: {'User-Agent': 'protz-app'}));
                  final details = await dio.get(
                    'https://maps.googleapis.com/maps/api/place/details/json',
                    queryParameters: {
                      'place_id': s['placeId'] as String,
                      'fields': 'geometry',
                      'key': apiKey,
                    },
                  );
                  final res = details.data['result'] ?? {};
                  final loc = res['geometry']?['location'] ?? {};
                  _selectedLat = (loc['lat'] as num?)?.toDouble();
                  _selectedLng = (loc['lng'] as num?)?.toDouble();
                } catch (_) {}
              } else {
                _selectedLat = s['lat'] as double?;
                _selectedLng = s['lng'] as double?;
              }
              _updateMapToSelected();
              setState(() => _suggestions.clear());
            },
          );
        },
      ),
    );
  }

  void _updateMapToSelected() {
    if (_mapController == null || _selectedLat == null || _selectedLng == null) return;
    final pos = LatLng(_selectedLat!, _selectedLng!);
    setState(() {
      _markers
        ..clear()
        ..add(Marker(
          markerId: const MarkerId('destination'),
          position: pos,
          infoWindow: InfoWindow(title: _destinationController.text.trim().isNotEmpty ? _destinationController.text.trim() : 'Destination'),
        ));
    });
    _mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: pos,
      zoom: 15,
    )));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF1B7A8A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
