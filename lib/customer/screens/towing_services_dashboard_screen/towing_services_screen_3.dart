import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../shared/widgets/back_icon_button.dart';
import '../../../shared/widgets/history_icon_button.dart';
import '../../../shared/utils/pages.dart';

class TowingServicesScreen3 extends StatefulWidget {
  final String? pickupLocation;
  final String? destination;

  const TowingServicesScreen3({
    super.key,
    this.pickupLocation,
    this.destination,
  });

  @override
  State<TowingServicesScreen3> createState() => _TowingServicesScreen3State();
}

class _TowingServicesScreen3State extends State<TowingServicesScreen3> {
  String? selectedVehicle;
  String? selectedUrgency;
  String? selectedRequirement;

  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: BackIconButton(
              onPressed: () {
                final pickupLocation = widget.pickupLocation ?? '';
                context.go(
                    '/towing-services/screen2?pickupLocation=${Uri.encodeComponent(pickupLocation)}');
              },
            ),
            title: const Text(
              'Towing Services',
              style: TextStyle(
                color: Color(0xFF1B7B8C),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              HistoryIconButton(
                onPressed: () {
                  context.push(AppRoutes.history);
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // From/To Section
                  _buildLocationSection(),

                  const SizedBox(height: 32),

                  // Vehicle Type
                  _buildLabel('What kind of vehicle is it?'),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    hint: 'Select vehicle type',
                    value: selectedVehicle,
                    onChanged: (value) {
                      setState(() {
                        selectedVehicle = value;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Urgency Level
                  _buildLabel('How urgent is your request?'),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    hint: 'Select urgency level',
                    value: selectedUrgency,
                    onChanged: (value) {
                      setState(() {
                        selectedUrgency = value;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Special Requirements
                  _buildLabel('Special requirements'),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    hint: 'Select special requirement',
                    value: selectedRequirement,
                    onChanged: (value) {
                      setState(() {
                        selectedRequirement = value;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Upload Photos
                  _buildLabel('Upload photos of vehicle'),
                  const SizedBox(height: 8),
                  _buildUploadBox(),

                  const SizedBox(height: 32),

                  // Proceed Button
                  _buildProceedButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'From:',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 2,
              height: 30,
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
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
                    child: _buildLocationField(
                        widget.pickupLocation ?? 'Accra Newtown'),
                  ),
                  const SizedBox(width: 8),
                  _buildLocationIcon(),
                ],
              ),
              const SizedBox(height: 16),
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
          items: const [],
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
          onTap: _proceedToCheckout,
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
    /*if (widget.pickupLocation == null || widget.pickupLocation!.isEmpty) {
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

    _showSnackBar('Towing request submitted successfully!');*/

    // TODO: Navigate to checkout screen
    context.go(
      AppRoutes.towingCheckout,
      //extra: towingData,
    );
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
