import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/utils/pages.dart';
import '../../core/app_export.dart';
//import '../../routes/app_routes.dart';
import '../../../shared/widgets/custom_image_view.dart';
import '../../../shared/widgets/custom_bottom_nav_bar.dart';
import '../../../shared/providers/dashboard_provider.dart';
import '../../../shared/models/dashboard_data.dart';
import '../../../shared/widgets/dashboard_header_section.dart';
import '../../../shared/widgets/dashboard_recent_orders.dart';
import '../../../shared/widgets/segmented_toggle.dart';


enum ServiceType { towing, water }

class TowingServicesDashboardScreen extends ConsumerStatefulWidget {
  const TowingServicesDashboardScreen({
    super.key,
    this.initialService = ServiceType.towing,
  });

  final ServiceType initialService;

  @override
  ConsumerState<TowingServicesDashboardScreen> createState() =>
      _TowingServicesDashboardScreenState();
}

class _TowingServicesDashboardScreenState
    extends ConsumerState<TowingServicesDashboardScreen> {
  int _currentNavIndex = 0;

  late ServiceType _selectedService;

  @override
  void initState() {
    super.initState();
    _selectedService = widget.initialService;
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);
    
    return Scaffold(
      backgroundColor: appTheme.light_blue_50,
      body: SafeArea(
        child: dashboardState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : dashboardState.hasError
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${dashboardState.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => ref.refresh(dashboardProvider),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : dashboardState.hasData
                    ? Column(
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 16.h),
                              child: Column(
                                children: [
                                  _buildTabSection(),
                                  Expanded(child: _buildTabBarView(dashboardState.data!)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Center(child: Text('No data available')),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
          // Keep navigation behavior consistent with the water dashboard
          switch (index) {
            case 0:
              // Home - already here
              break;
            case 1:
              context.push(AppRoutes.history);
              break;
            case 2:
              context.push(AppRoutes.chatInbox);
              break;
            case 3:
              context.push(AppRoutes.accountSettings);
              break;
          }
        },
      ),
    );
  }

  Widget _buildTabSection() {
    return SegmentedToggle(
      labels: const ['Towing Services', 'Water Delivery'],
      selectedIndex: _selectedService == ServiceType.towing ? 0 : 1,
      onChanged: (i) => setState(() => _selectedService = i == 0 ? ServiceType.towing : ServiceType.water),
      height: 40.h,
    );
  }

  Widget _buildTabBarView(DashboardData dashboardData) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 24.h),
        child: Column(
          spacing: 20.h,
          children: [
            _buildHeaderSection(dashboardData.user),
            _buildMainContent(dashboardData),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(UserInfo userInfo) {
    return DashboardHeaderSection(userInfo: userInfo);
  }

  Widget _buildMainContent(DashboardData dashboardData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //DashboardWalletCard(walletInfo: dashboardData.wallet),
        if (_selectedService == ServiceType.towing)
          _buildTowVehicleCard()
        else
          _buildOrderWaterCard(),
        DashboardRecentOrders(recentOrders: dashboardData.recentOrders),
      ],
    );
  }

  Widget _buildTowVehicleCard() {
    return GestureDetector(
      onTap: () {
        context.go('/towing-services/screen1');
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
              'Tow A Vehicle',
              style: TextStyleHelper.instance.title16MediumPoppins,
            ),
          ],
        ),
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
}