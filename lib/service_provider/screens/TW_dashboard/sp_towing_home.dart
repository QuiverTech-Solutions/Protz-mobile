import 'package:flutter/material.dart';
//

import '../../../customer/core/utils/image_constant.dart';
import '../../../customer/theme/text_style_helper.dart';
import '../../../shared/widgets/custom_image_view.dart';
import '../../core/app_export.dart';
//import '../../routes/app_routes.dart';
import '../../../shared/widgets/custom_bottom_nav_bar.dart';
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
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
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
        margin: EdgeInsets.only(top: 24.h),
        child: Column(
          spacing: 20.h,
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
          height: 40.h,
          width: 40.h,
          fit: BoxFit.cover,
          radius: BorderRadius.circular(20.h),
        ),
        SizedBox(width: 8.h),
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
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 20.h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        border: Border.all(
          color: const Color(0x1AE1170C), // rgba(225,23,12,0.1)
          width: 4.h,
        ),
        borderRadius: BorderRadius.circular(24.h),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: emergencyIconUrl,
            height: 48.h,
            width: 48.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 12.h),
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
    final recentOrders = <Map<String, String>>[
      {
        'serviceTitle': 'Towing Service',
        'date': '20/09/2025',
        'originLocation': 'Osu',
        'destinationLocation': 'East Legon',
        'serviceProvider': 'Swift Tow Co.',
        'price': 'GHS 450.00',
      },
      {
        'serviceTitle': 'Towing Service',
        'date': '18/09/2025',
        'originLocation': 'Airport Residential',
        'destinationLocation': 'Tema',
        'serviceProvider': 'ProTow Ghana',
        'price': 'GHS 380.00',
      },
      {
        'serviceTitle': 'Water Delivery',
        'date': '15/09/2025',
        'originLocation': 'North Ridge',
        'destinationLocation': 'Dansoman',
        'serviceProvider': 'AquaFresh',
        'price': 'GHS 200.00',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 32.h),
          child: Text(
            'Recent orders',
            style: TextStyleHelper.instance.title16MediumPoppins,
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 8.h),
          decoration: BoxDecoration(
            color: appTheme.white_A700,
            border: Border.all(color: appTheme.light_blue_50, width: 4.h),
            borderRadius: BorderRadius.circular(12.h),
          ),
          child: Column(
            children: recentOrders.map((order) {
              final isLast = recentOrders.indexOf(order) == recentOrders.length - 1;
              return Column(
                children: [
                  ListTile(
                    title: Text(order['serviceTitle'] ?? ''),
                    subtitle: Text(
                      '${order['date']} • ${order['originLocation']} → ${order['destinationLocation']}\n${order['serviceProvider']}',
                    ),
                    trailing: Text(order['price'] ?? ''),
                  ),
                  if (!isLast)
                    Divider(height: 1, color: appTheme.light_blue_50),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}