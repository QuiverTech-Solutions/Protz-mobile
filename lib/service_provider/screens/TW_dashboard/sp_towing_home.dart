import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//

import '../../../customer/core/utils/image_constant.dart';
import '../../../customer/theme/text_style_helper.dart';
import '../../../shared/utils/pages.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_image_view.dart';
import '../../core/app_export.dart';
//import '../../routes/app_routes.dart';
import '../../widgets/sp_bottom_nav_bar.dart';
import '../../../shared/widgets/dashboard_recent_orders.dart';
import '../../../shared/models/service_request.dart';
import '../../../shared/models/service_provider.dart';
import '../../../customer/core/utils/size_utils.dart' as cus_size;
import '../../widgets/provider_status_toggle.dart';
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
  bool _isOnline = true;

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
      bottomNavigationBar: SPBottomNavBar(
        items: const [
          SPBottomNavItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          SPBottomNavItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Requests',
          ),
          SPBottomNavItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chats',
          ),
          SPBottomNavItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Finances',
          ),
          SPBottomNavItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        currentIndex: _currentNavIndex,
        onItemSelected: (index) {
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
        SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, Iyad',
                textAlign: TextAlign.left,
                style: TextStyleHelper.instance.title18MediumPoppins,
              ),
              Text(
                'Let’s do some deliveries today!',
                style: TextStyleHelper.instance.body12RegularPoppins,
              ),
            ],
          ),
        ),
        Spacer(),
        IconButton(
          icon: Icon(Icons.notifications),
          padding: EdgeInsets.only(left: ResponsiveExtension(12).h),
          onPressed: () {context.push(AppRoutes.notifications);},
        ),
        ProviderStatusToggle(
          isOnline: _isOnline,
          onChanged: (value) {
            setState(() {
              _isOnline = value;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(value ? 'Status: Online' : 'Status: Offline'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatsRow(),
        SizedBox(height: ResponsiveExtension(12).h),
        _buildPreviewPopupButton(),
        SizedBox(height: ResponsiveExtension(20).h),
        _emergencyContactButton(),
        _buildRecentOrdersSection(),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      spacing: ResponsiveExtension(12).h,
      children: [
        Expanded(child: _buildMetricCard(3, 'Today’s Deliveries')),
        Expanded(child: _buildMetricCard(1, 'Today’s Earnings',money: true)),
        Expanded(child: _buildMetricCard(5, 'Total Earnings',money: true)),
      ],
    );
  }

  Widget _buildMetricCard(int amount, String label,{ bool money =false}) {
    return Container(
      height: ResponsiveExtension(140).h,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveExtension(16).h,
        vertical: ResponsiveExtension(20).h,
      ),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        border: Border.all(
          color: appTheme.light_blue_50,
          width: ResponsiveExtension(4).h,
        ),
        borderRadius: BorderRadius.circular(ResponsiveExtension(12).h),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          money? Text("GHS", style: TextStyle(),):Container(),
          Text(
            '$amount',
            textAlign: TextAlign.center,
            style:  TextStyleHelper.instance.title20RegularRoboto.copyWith(
              color: appTheme.light_blue_900,
              fontWeight: FontWeight.bold,
           ),
          ),
          SizedBox(height: ResponsiveExtension(8).h),
          Container(
            height: 1,
            width: double.infinity,
            color: appTheme.light_blue_50,
          ),
          SizedBox(height: ResponsiveExtension(8).h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyleHelper.instance.body12RegularPoppins.copyWith(
              fontSize: 12
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewPopupButton() {
    return CustomButton(
      text: 'Preview Request',
      backgroundColor: appTheme.white_A700,
      textColor: appTheme.light_blue_900,
      borderColor: appTheme.light_blue_900,
      onPressed: () {
        final orders = _placeholderRecentOrders();
        final demo = orders.first;
        _showTowingRequestPopup(demo);
      },
    );
  }

  Future<void> _showTowingRequestPopup(ServiceRequest request) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveExtension(16).h,
            vertical: ResponsiveExtension(24).h,
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveExtension(24).h),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveExtension(16).h, vertical: ResponsiveExtension(24).h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You have an order!',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: ResponsiveExtension(16).fSize,
                        color: appTheme.light_blue_900,
                      ),
                    ),
                    SizedBox(height: ResponsiveExtension(4).h),
                    Text(
                      'Someone wants to get their vehicle towed!',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: ResponsiveExtension(12).fSize,
                        color: appTheme.blue_gray_400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveExtension(24).h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgAvatar,
                          height: ResponsiveExtension(40).h,
                          width: ResponsiveExtension(40).h,
                          fit: BoxFit.cover,
                          radius: BorderRadius.circular(ResponsiveExtension(20).h),
                        ),
                        SizedBox(width: ResponsiveExtension(12).h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              request.assignedProvider?.name ?? 'John Williams',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                fontSize: ResponsiveExtension(14).fSize,
                                color: appTheme.light_blue_900,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'SUV',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    fontSize: ResponsiveExtension(10).fSize,
                                    color: appTheme.light_blue_900,
                                  ),
                                ),
                                SizedBox(width: ResponsiveExtension(4).h),
                                Text(
                                  '-Toyota Land Cruiser',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    fontSize: ResponsiveExtension(10).fSize,
                                    color: appTheme.blue_gray_400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: appTheme.light_blue_900,
                        borderRadius: BorderRadius.circular(ResponsiveExtension(8).h),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(ResponsiveExtension(11).h),
                            child: Icon(Icons.phone, color: appTheme.white_A700, size: ResponsiveExtension(24).h),
                          ),
                          Container(
                            height: ResponsiveExtension(24).h,
                            width: 1,
                            color: appTheme.white_A700.withOpacity(0.4),
                          ),
                          Padding(
                            padding: EdgeInsets.all(ResponsiveExtension(11).h),
                            child: Icon(Icons.chat_bubble_outline, color: appTheme.white_A700, size: ResponsiveExtension(24).h),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveExtension(20).h),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: appTheme.light_blue_50,
                ),
                SizedBox(height: ResponsiveExtension(20).h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          'From:',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: ResponsiveExtension(12).fSize,
                            color: const Color(0xFF505050),
                          ),
                        ),
                        SizedBox(height: ResponsiveExtension(8).h),
                        SizedBox(
                          height: ResponsiveExtension(38).h,
                          width: ResponsiveExtension(13).h,
                          child: CustomImageView(
                            imagePath: ImageConstant.imgFormkitArrowright,
                            height: ResponsiveExtension(38).h,
                            width: ResponsiveExtension(13).h,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: ResponsiveExtension(8).h),
                        Text(
                          'To:',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: ResponsiveExtension(12).fSize,
                            color: const Color(0xFF505050),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: ResponsiveExtension(12).h),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            height: ResponsiveExtension(48).h,
                            padding: EdgeInsets.symmetric(horizontal: ResponsiveExtension(16).h, vertical: ResponsiveExtension(10).h),
                            decoration: BoxDecoration(
                              color: appTheme.light_blue_50,
                              borderRadius: BorderRadius.circular(ResponsiveExtension(12).h),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                request.pickupLocation.address,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: ResponsiveExtension(12).fSize,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF505050),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: ResponsiveExtension(12).h),
                          Container(
                            height: ResponsiveExtension(48).h,
                            padding: EdgeInsets.symmetric(horizontal: ResponsiveExtension(16).h, vertical: ResponsiveExtension(10).h),
                            decoration: BoxDecoration(
                              color: appTheme.light_blue_50,
                              borderRadius: BorderRadius.circular(ResponsiveExtension(12).h),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                request.destinationLocation?.address ?? 'Mr. Krabbs Mechanic Shop, Danfa',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: ResponsiveExtension(12).fSize,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF505050),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveExtension(20).h),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: appTheme.light_blue_50,
                ),
                SizedBox(height: ResponsiveExtension(20).h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You will be paid',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: ResponsiveExtension(10).fSize,
                            color: appTheme.gray_900,
                          ),
                        ),
                        Text(
                          'GHS ${request.estimatedCost?.toStringAsFixed(2) ?? '276.00'}',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: ResponsiveExtension(16).fSize,
                            color: const Color(0xFF009F22),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: ResponsiveExtension(40).h,
                      padding: EdgeInsets.symmetric(horizontal: ResponsiveExtension(16).h, vertical: ResponsiveExtension(10).h),
                      decoration: BoxDecoration(
                        color: const Color(0x1AE30C00),
                        border: Border.all(color: const Color(0x33E30C00)),
                        borderRadius: BorderRadius.circular(ResponsiveExtension(12).h),
                      ),
                      child: Center(
                        child: Text(
                          'Emergency',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: ResponsiveExtension(12).fSize,
                            color: const Color(0xFFE30C00),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveExtension(24).h),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Decline',
                        backgroundColor: appTheme.white_A700,
                        textColor: appTheme.gray_900,
                        borderColor: const Color(0xFF909090),
                        onPressed: () { Navigator.of(ctx).pop(); },
                        isFullWidth: true,
                      ),
                    ),
                    SizedBox(width: ResponsiveExtension(10).h),
                    Expanded(
                      child: CustomButton(
                        text: 'View More',
                        backgroundColor: appTheme.light_blue_900,
                        textColor: appTheme.white_A700,
                        borderColor: appTheme.light_blue_900,
                        onPressed: () { Navigator.of(ctx).pop(); },
                        isFullWidth: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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