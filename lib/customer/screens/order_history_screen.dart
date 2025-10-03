import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/utils/pages.dart';
import '../core/app_export.dart';
import '../widgets/custom_service_card.dart';
import '../../shared/widgets/custom_bottom_nav_bar.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  int _currentNavIndex = 1; // Orders tab is selected (index 1)

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  SizedBox(height: 12.h),
                  _buildSearchBar(context),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('This month'),
                          _buildHistoryGroup(_thisMonth()),
                          SizedBox(height: 20.h),
                          _buildSectionTitle('Last month'),
                          _buildHistoryGroup(_lastMonth()),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _currentNavIndex,
            onTap: (index) {
              setState(() {
                _currentNavIndex = index;
              });
              // Handle navigation based on index
              switch (index) {
                case 0:
                  // Home - navigate to home screen
                  context.go('/towing_service_screen');
                  break;
                case 1:
                  // Orders - already on orders screen
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        SizedBox(width: 8.h),
        Text(
          'Order History',
          style: TextStyleHelper.instance.title18MediumPoppins,
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search order history',
        hintStyle: TextStyleHelper.instance.body14RegularPoppins
            .copyWith(color: appTheme.blue_gray_400),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: const Icon(Icons.tune),
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.h),
        filled: true,
        fillColor: appTheme.white_A700,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.h),
          borderSide: BorderSide(color: appTheme.blue_gray_900),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.h),
          borderSide: BorderSide(color: appTheme.blue_gray_900),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.h),
          borderSide: BorderSide(color: appTheme.light_blue_900),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: TextStyleHelper.instance.title16MediumPoppins
            .copyWith(color: appTheme.light_blue_900),
      ),
    );
  }

  Widget _buildHistoryGroup(List<_OrderItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(color: appTheme.light_blue_50, width: 4.h),
      ),
      child: Column(
        children: items
            .map(
              (item) => CustomServiceCard(
                serviceTitle: item.serviceTitle,
                date: item.date,
                originLocation: item.originLocation,
                destinationLocation: item.destinationLocation,
                serviceProvider: item.serviceProvider,
                price: item.price,
                margin: EdgeInsets.only(bottom: 8.h),
              ),
            )
            .toList(),
      ),
    );
  }

  List<_OrderItem> _thisMonth() => [
        _OrderItem(
          serviceTitle: 'Towing Service',
          date: '20/09/2025',
          originLocation: 'Accra Newtown',
          destinationLocation: 'Mr. Krabbs Mechanic Shop',
          serviceProvider: 'Ofosu Towing Services',
          price: 'GHS 400.00',
        ),
        _OrderItem(
          serviceTitle: 'Water Delivery',
          date: '24/09/2025',
          originLocation: 'Delivery to',
          destinationLocation: 'No.1 Ashongman Estates',
          serviceProvider: 'Mr. Ansah & Sons',
          price: 'GHS 250.00',
        ),
        _OrderItem(
          serviceTitle: 'Towing Service',
          date: '20/09/2025',
          originLocation: 'Accra Newtown',
          destinationLocation: 'Mr. Krabbs Mechanic Shop',
          serviceProvider: 'Ofosu Towing Services',
          price: 'GHS 400.00',
        ),
      ];

  List<_OrderItem> _lastMonth() => [
        _OrderItem(
          serviceTitle: 'Towing Service',
          date: '20/08/2025',
          originLocation: 'Accra Newtown',
          destinationLocation: 'Mr. Krabbs Mechanic Shop',
          serviceProvider: 'Ofosu Towing Services',
          price: 'GHS 400.00',
        ),
        _OrderItem(
          serviceTitle: 'Water Delivery',
          date: '24/08/2025',
          originLocation: 'Delivery to',
          destinationLocation: 'No.1 Ashongman Estates',
          serviceProvider: 'Mr. Ansah & Sons',
          price: 'GHS 250.00',
        ),
        _OrderItem(
          serviceTitle: 'Towing Service',
          date: '20/08/2025',
          originLocation: 'Accra Newtown',
          destinationLocation: 'Mr. Krabbs Mechanic Shop',
          serviceProvider: 'Ofosu Towing Services',
          price: 'GHS 400.00',
        ),
      ];
}

class _OrderItem {
  final String serviceTitle;
  final String date;
  final String originLocation;
  final String destinationLocation;
  final String serviceProvider;
  final String price;

  _OrderItem({
    required this.serviceTitle,
    required this.date,
    required this.originLocation,
    required this.destinationLocation,
    required this.serviceProvider,
    required this.price,
  });
}