import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../shared/utils/app_constants.dart';
import '../../../shared/utils/pages.dart';
import '../../../shared/providers/api_service_provider.dart';
import '../../../shared/providers/service_types_provider.dart';

class WaterDeliveryScreen2 extends StatefulWidget {
  final String? pickupLocation;
  final String? destination;

  const WaterDeliveryScreen2({
    super.key,
    this.pickupLocation,
    this.destination,
  });

  @override
  State<WaterDeliveryScreen2> createState() => _WaterDeliveryScreen2State();
}

class _WaterDeliveryScreen2State extends State<WaterDeliveryScreen2> {
  String? selectedVehicle;
  String? selectedUrgency;
  String? selectedRequirement;
  String? selectedDeliveryMethod;
  final TextEditingController _instructionsController = TextEditingController();

  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            expandedHeight: 0,
            leading: GestureDetector(
              onTap: () {
                final pickupLocation = widget.pickupLocation ?? '';
                context.go(
                    '/water-delivery-screen1?pickupLocation=${Uri.encodeComponent(pickupLocation)}');
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black87,
                size: 18,
              ),
            ),
            title: Text(
              'Water Delivery',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2E7D7B),
              ),
            ),
            centerTitle: false,
            actions: [
              GestureDetector(
                onTap: () {
                  context.push(AppRoutes.history);
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.history,
                    color: Color(AppConstants.primaryColorValue),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          SliverFillRemaining(
            child: Column(
          children: [
            // App Bar
            
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // From/To Section
                    _buildLocationSection(),
        
                    const SizedBox(height: 32),
        
                    // Vehicle Type
                    _buildLabel('What is your desired water quantity?'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      hint: '0',
                      value: selectedVehicle,
                      options: const ['50', '100', '150', '200'],
                      onChanged: (value) {
                        setState(() {
                          selectedVehicle = value;
                        });
                      },
                    ),
        
                    const SizedBox(height: 24),
        
                    // Urgency Level
                    _buildLabel(
                        'At what time do you want the water to be delivered?'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      hint: 'Select time',
                      value: selectedUrgency,
                      options: const ['ASAP', 'Morning', 'Afternoon', 'Evening'],
                      onChanged: (value) {
                        setState(() {
                          selectedUrgency = value;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    _buildLabel('Select delivery method'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      hint: 'polytank',
                      value: selectedDeliveryMethod,
                      options: const ['polytank', 'direct_fill'],
                      onChanged: (value) {
                        setState(() {
                          selectedDeliveryMethod = value;
                        });
                      },
                    ),

                    const SizedBox(height: 24),
        
                    // Special Requirements
                    _buildLabel('Do you have any special instructions?'),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: _buildInstructionsInput(),
                    ),
        
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // Bottom Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24),
              child: _buildProceedButton(),
            ),
          ],
        ),
      ),
    ]));
  }

  Widget _buildLocationSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'To:',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildLocationField(widget.destination ??
                        'Mr. Krabbs Mechanic Shop, Danfa'),
                  ),
                  const SizedBox(width: 8),
                  _buildLocationIcon(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationField(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildLocationIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xFF1B7B8C),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.my_location,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black54,
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> options,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            hint,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
            ),
          ),
          value: value,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
          items: options
              .map((o) => DropdownMenuItem<String>(value: o, child: Text(o)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildUploadBox() {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: _pickImages,
        child: Container(
          height: 110,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.file_upload_outlined,
                color: Colors.grey.shade500,
                size: 28,
              ),
              const SizedBox(height: 6),
              Text(
                'Tap here to upload photo(s)',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                ),
              ),
              if (_selectedImages.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  '${_selectedImages.length} photo(s) selected',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionsInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E5EA), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: TextField(
        controller: _instructionsController,
        maxLines: 4,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1C1C1E)),
        decoration: const InputDecoration(
          hintText: 'Enter any special instructions',
          hintStyle: TextStyle(fontSize: 14, color: Color(0xFF8E8E93)),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildProceedButton() {
    return Container(
      width: 400,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF086788), // Dark teal from color scheme
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            if ((widget.destination ?? '').isEmpty) {
              _showSnackBar('Please set delivery address');
              return;
            }
            if ((selectedVehicle ?? '0') == '0') {
              _showSnackBar('Please select water quantity');
              return;
            }
            final data = {
              'pickupLocation': widget.pickupLocation ?? '',
              'destination': widget.destination ?? '',
              'quantity': selectedVehicle ?? '0',
              'instructions': _instructionsController.text.trim(),
              'deliveryMethod': selectedDeliveryMethod ?? 'polytank',
            };
            context.push(AppRoutes.waterCheckout, extra: data);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: 12),
                Text(
                  'Proceed to Checkout',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Color(0xFF086788),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 14,
                    color: Color(0xFF086788),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images.map((image) => File(image.path)));
        });
      }
    } catch (e) {
      _showSnackBar('Error picking images: $e');
    }
  }

  void _proceedToCheckout() {
    if (widget.pickupLocation == null || widget.pickupLocation!.isEmpty) {
      _showSnackBar('Please enter pickup location');
      return;
    }

    if (widget.destination == null || widget.destination!.isEmpty) {
      _showSnackBar('Please enter destination');
      return;
    }

    if (selectedVehicle == null) {
      _showSnackBar('Please select vehicle type');
      return;
    }

    final towingData = {
      'from': widget.pickupLocation,
      'to': widget.destination,
      'vehicleType': selectedVehicle,
      'urgency': selectedUrgency,
      'specialRequirements': selectedRequirement,
      'images': _selectedImages,
    };

    _showSnackBar('Towing request submitted successfully!');

    // TODO: Navigate to checkout screen
    // context.go('/checkout', extra: towingData);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF1B7B8C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
