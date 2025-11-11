import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/utils/size_utils.dart';
import '../../../shared/widgets/custom_sliver_app_bar.dart';

class TowingServicesScreen2 extends StatefulWidget {
  final String? pickupLocation;
  
  const TowingServicesScreen2({
    super.key,
    this.pickupLocation,
  });

  @override
  State<TowingServicesScreen2> createState() => _TowingServicesScreen2State();
}

class _TowingServicesScreen2State extends State<TowingServicesScreen2> {
  final TextEditingController _destinationController = TextEditingController();
  GoogleMapController? _mapController;
  
  // Default location (Accra, Ghana)
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(5.6037, -0.1870),
    zoom: 14.0,
  );

  // Sample markers
  final Set<Marker> _markers = {
    Marker(
      markerId: const MarkerId('church'),
      position: const LatLng(5.6100, -0.1950),
      infoWindow: const InfoWindow(title: "St. Paul's Roman Catholic Church"),
    ),
    Marker(
      markerId: const MarkerId('salon'),
      position: const LatLng(5.5980, -0.1800),
      infoWindow: const InfoWindow(title: "Jenni's Hair Salon"),
    ),
    Marker(
      markerId: const MarkerId('institute'),
      position: const LatLng(5.5900, -0.1920),
      infoWindow: const InfoWindow(title: "Accra Institute of Technology"),
    ),
  };

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
            title: 'Towing Services',
            onBackPressed: () => context.go('/towing_services_screen_1'),
            onHistoryPressed: () {
              // Handle info/help action
            },
          ),
          SliverFillRemaining(
            child: Stack(
              children: [
                // Map background
                //_buildMapView(),
                
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
              'Where are you towing this vehicle to?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            
            const Text(
              'Enter the destination address for the vehicle',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            
            _buildDestinationInput(),
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
          hintText: 'Enter destination address',
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
            _showSnackBar('Please enter destination address');
            return;
          }
          
          // Navigate to next screen
          final pickupLocation = widget.pickupLocation ?? '';
          final destination = _destinationController.text.trim();
          context.go('/towing-services/screen3?pickupLocation=${Uri.encodeComponent(pickupLocation)}&destination=${Uri.encodeComponent(destination)}');
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