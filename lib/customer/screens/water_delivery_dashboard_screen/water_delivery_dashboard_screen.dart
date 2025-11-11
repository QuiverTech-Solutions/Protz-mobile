import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/utils/pages.dart';
import '../../core/app_export.dart';
//import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_service_card.dart';
import '../../../shared/widgets/custom_bottom_nav_bar.dart';

class WaterDeliveryDashboard extends StatefulWidget {
  const WaterDeliveryDashboard({super.key});

  @override
  State<WaterDeliveryDashboard> createState() => _WaterDeliveryDashboardState();
}

class _WaterDeliveryDashboardState extends State<WaterDeliveryDashboard> {
  int _currentNavIndex = 0;
  
  List<Map<String, dynamic>> recentOrders = [
    {
      'serviceTitle': 'Water Delivery',
      'date': '20/09/2025',
      'originLocation': 'Accra Newtown',
      'destinationLocation': 'East Legon Residential',
      'serviceProvider': 'AquaFresh Water Services',
      'price': 'GHS 150.00',
    },
    {
      'serviceTitle': 'Water Delivery',
      'date': '18/09/2025',
      'originLocation': 'Circle Distribution Center',
      'destinationLocation': 'Tema Community 25',
      'serviceProvider': 'Crystal Clear Water Co.',
      'price': 'GHS 200.00',
    },
    {
      'serviceTitle': 'Water Delivery',
      'date': '15/09/2025',
      'originLocation': 'Achimota Water Station',
      'destinationLocation': 'Dansoman Estate',
      'serviceProvider': 'Pure Water Express',
      'price': 'GHS 120.00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  _buildTabSection(context),
                  Expanded(
                    child: _buildTabBarView(),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: 0, // Home tab is selected
            onTap: (index) {
              setState(() {
                _currentNavIndex = index;
              });
              // Handle navigation based on index
              switch (index) {
                case 0:
                  // Home - already on home screen
                  break;
                case 1:
                  // Orders - navigate to orders screen
                  context.push(AppRoutes.history);
                  break;
                case 2:
                  // Chats - navigate to chats screen
                  context.push(AppRoutes.chatInbox);
                  break;
                case 3:
                  // Account - navigate to account screen
                  context.push(AppRoutes.accountSettings);
                  break;
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildTabSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        border: Border.all(color: appTheme.light_blue_50, width: 4.h),
        borderRadius: BorderRadius.circular(24.h),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.pushReplacementNamed(AppRouteNames.customerHome);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 12.h),
                child: Text(
                  'Towing Services',
                  style: TextStyleHelper.instance.title16MediumPoppins
                      .copyWith(color: appTheme.light_blue_900),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
              decoration: BoxDecoration(
                color: appTheme.light_blue_900,
                borderRadius: BorderRadius.circular(20.h),
              ),
              child: Text(
                'Water Delivery',
                style: TextStyleHelper.instance.title16MediumPoppins
                    .copyWith(color: appTheme.white_A700),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
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
          'Welcome, John',
          style: TextStyleHelper.instance.title18MediumPoppins,
        ),
        Spacer(),
        IconButton(
          icon: Icon(Icons.history),
          onPressed: () {context.push(AppRoutes.history);},
        ),
        IconButton(
          icon: Icon(Icons.notifications),
          padding: EdgeInsets.only(left: 12.h),
          onPressed: () {context.push(AppRoutes.notifications);},
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWalletCard(),
        _buildOrderWaterCard(),
        _buildRecentOrdersSection(),
      ],
    );
  }

  Widget _buildWalletCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 14.h),
      decoration: BoxDecoration(
        color: appTheme.light_blue_900,
        border: Border.all(color: appTheme.light_blue_50, width: 4.h),
        borderRadius: BorderRadius.circular(24.h),
      ),
      child: Column(
        spacing: 10.h,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  spacing: 8.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Protz Wallet Account:',
                      style: TextStyleHelper.instance.body14RegularPoppins,
                    ),
                    Text(
                      'GHS ******',
                      style: TextStyleHelper.instance.headline24MediumPoppins,
                    ),
                  ],
                ),
              ),
              Column(
                spacing: 8.h,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.h),
                    decoration: BoxDecoration(
                      color: appTheme.light_blue_50,
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                    child: Text(
                      'Customer',
                      style: TextStyleHelper.instance.label10RegularPoppins,
                    ),
                  ),
                  Text(
                    'John Williams',
                    style: TextStyleHelper.instance.body14RegularPoppins,
                  ),
                ],
              ),
            ],
          ),
          Row(
            spacing: 12.h,
            children: [
              Expanded(
                child: CustomButton(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  text: 'View Balance',
                  onPressed: () {},
                  backgroundColor: appTheme.white_A700,
                  textColor: appTheme.light_blue_900,
                  borderColor: appTheme.light_blue_900,
                  isFullWidth: true,
                ),
              ),
              Expanded(
                child: CustomButton(
                  text: 'Top up',
                  onPressed: () {},
                  backgroundColor: appTheme.white_A700,
                  textColor: appTheme.light_blue_900,
                  borderColor: appTheme.light_blue_900,
                  isFullWidth: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderWaterCard() {
    return GestureDetector(
      onTap: () {
        context.go(AppRoutes.waterDeliveryScreen1);
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 32.h),
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: appTheme.white_A700,
          border: Border.all(color: appTheme.light_blue_50, width: 4.h),
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Column(
          spacing: 6.h,
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgGroup1,
              height: 62.h,
              width: 140.h,
              fit: BoxFit.cover,
            ),
            Text(
              'Order Water Delivery',
              style: TextStyleHelper.instance.title16MediumPoppins,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrdersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 32.h),
          child: Text(
            'Your recent orders',
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
              bool isLastItem =
                  recentOrders.indexOf(order) == recentOrders.length - 1;
              return CustomServiceCard(
                serviceTitle: order['serviceTitle'] ?? '',
                date: order['date'] ?? '',
                originLocation: order['originLocation'] ?? '',
                destinationLocation: order['destinationLocation'] ?? '',
                serviceProvider: order['serviceProvider'] ?? '',
                price: order['price'] ?? '',
                onPricePressed: isLastItem ? () {} : null,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
