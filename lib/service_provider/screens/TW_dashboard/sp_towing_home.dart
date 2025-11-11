import 'package:flutter/material.dart';
//

import '../../../customer/core/utils/image_constant.dart';
import '../../../customer/theme/text_style_helper.dart';
import '../../../shared/widgets/custom_image_view.dart';
import '../../core/app_export.dart';
//import '../../routes/app_routes.dart';
import '../../../shared/widgets/custom_bottom_nav_bar.dart';
import '../../../shared/widgets/dashboard_recent_orders.dart';
import '../../../shared/models/service_request.dart';
import '../../../shared/models/service_provider.dart';
import '../../../customer/core/utils/size_utils.dart' as cus_size;
//



enum ServiceType { towing, water }

class SpTowingHome extends StatefulWidget {
  const SpTowingHome({
    super.key,
    this.initialService = ServiceType.towing,
  });

  final ServiceType initialService;

  @override
  State<SpTowingHome> createState() =>
      _SpTowingHomeState();
}

class _SpTowingHomeState
    extends State<SpTowingHome> {
  int _currentNavIndex = 0;

  late ServiceType _selectedService;

  @override
  void initState() {
    super.initState();
    _selectedService = widget.initialService;
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: appTheme.light_blue_50,
      body: SafeArea(
        child: Sizer(
          builder: (context, orientation, deviceType) {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveExtension(16).h),
                    child: Column(
                      children: [
                        //_buildTabSection(),
                        Expanded(child: _buildTabBarView()),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
          
        },
      ),
    );
  }

  Widget _buildTabBarView() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: ResponsiveExtension(24).h),
        child: Column(
          spacing: ResponsiveExtension(20).h,
          children: [
            _buildHeaderSection(),
            _buildMainContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgAvatar,
          height: ResponsiveExtension(40).h,
          width: ResponsiveExtension(40).h,
          fit: BoxFit.cover,
          radius: BorderRadius.circular(ResponsiveExtension(20).h),
        ),
        SizedBox(width: ResponsiveExtension(8).h),
        Text(
          'Welcome, Provider',
          style: TextStyleHelper.instance.title18MediumPoppins,
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _emergencyContactButton(),
        _buildRecentOrdersSection(),
      ],
    );
  }

  Widget _emergencyContactButton() {
    const String emergencyIconUrl =
        'assets/images/material-symbols_e911-emergency-rounded.svg';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: ResponsiveExtension(12).h, vertical: ResponsiveExtension(20).h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        border: Border.all(
          color: const Color(0x1AE1170C), // rgba(225,23,12,0.1)
          width: ResponsiveExtension(4).h,
        ),
        borderRadius: BorderRadius.circular(ResponsiveExtension(24).h),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: emergencyIconUrl,
            height: ResponsiveExtension(48).h,
            width: ResponsiveExtension(48).h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: ResponsiveExtension(12).h),
          Text(
            'Emergency\nContact',
            textAlign: TextAlign.center,
            style: TextStyleHelper.instance.title16MediumPoppins.copyWith(
              color: const Color(0xFFE30C00), // #E30C00
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildRecentOrdersSection() {
    final orders = _placeholderRecentOrders();
    // Initialize the customer SizeUtils via its Sizer to ensure responsive units work
    return cus_size.Sizer(
      builder: (context, orientation, deviceType) {
        return DashboardRecentOrders(recentOrders: orders);
      },
    );
  }

  List<ServiceRequest> _placeholderRecentOrders() {
    ServiceProvider provider(String name, String serviceType) {
      return ServiceProvider(
        id: name.toLowerCase().replaceAll(' ', '_'),
        name: name,
        serviceType: serviceType,
        phoneNumber: '0000000000',
        email: null,
        address: 'Accra, Ghana',
        currentLocation: null,
        serviceAreas: const [],
        basePrice: 0.0,
        pricePerUnit: 0.0,
        currency: 'GHS',
        rating: 4.5,
        reviewCount: 100,
        estimatedArrival: null,
        isAvailable: true,
        profileImageUrl: null,
        vehicles: null,
        operatingHours: null,
      );
    }

    ServiceRequest req({
      required String id,
      required String serviceTitle,
      required DateTime date,
      required String origin,
      String? destination,
      String? providerName,
      required double price,
    }) {
      return ServiceRequest(
        id: id,
        serviceType: serviceTitle,
        status: ServiceRequestStatus.completed,
        customerId: 'customer_demo',
        assignedProvider: providerName == null
            ? null
            : provider(providerName, serviceTitle),
        pickupLocation: LocationDetails(
          address: origin,
          latitude: 0.0,
          longitude: 0.0,
        ),
        destinationLocation: destination == null
            ? null
            : LocationDetails(
                address: destination,
                latitude: 0.0,
                longitude: 0.0,
              ),
        serviceDetails: const {},
        estimatedCost: price,
        finalCost: price,
        currency: 'GHS',
        createdAt: date,
        updatedAt: date,
        estimatedCompletionTime: null,
        completedAt: date,
        notes: null,
        urgencyLevel: 'low',
        paymentStatus: PaymentStatus.paid,
        imageUrls: const [],
      );
    }

    return [
      req(
        id: 'req_001',
        serviceTitle: 'Towing Service',
        date: DateTime(2025, 9, 20),
        origin: 'Osu',
        destination: 'East Legon',
        providerName: 'Swift Tow Co.',
        price: 450.00,
      ),
      req(
        id: 'req_002',
        serviceTitle: 'Towing Service',
        date: DateTime(2025, 9, 18),
        origin: 'Airport Residential',
        destination: 'Tema',
        providerName: 'ProTow Ghana',
        price: 380.00,
      ),
      req(
        id: 'req_003',
        serviceTitle: 'Water Delivery',
        date: DateTime(2025, 9, 15),
        origin: 'North Ridge',
        destination: 'Dansoman',
        providerName: 'AquaFresh',
        price: 200.00,
      ),
    ];
  }
}