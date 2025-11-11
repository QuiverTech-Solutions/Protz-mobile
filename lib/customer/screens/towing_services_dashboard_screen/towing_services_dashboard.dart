import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_export.dart';
//import '../../routes/app_routes.dart';
import '../../widgets/custom_image_view.dart';
import '../../../shared/widgets/custom_bottom_nav_bar.dart';
import '../../../shared/providers/dashboard_provider.dart';
import '../../../shared/models/dashboard_data.dart';
import '../../widgets/dashboard_header_section.dart';
import '../../widgets/dashboard_recent_orders.dart';
import '../../../shared/widgets/dashboard_wallet_card.dart';


class TowingServicesDashboardScreen extends ConsumerStatefulWidget {
  const TowingServicesDashboardScreen({super.key});

  @override
  ConsumerState<TowingServicesDashboardScreen> createState() =>
      _TowingServicesDashboardScreenState();
}

class _TowingServicesDashboardScreenState
    extends ConsumerState<TowingServicesDashboardScreen> {
  int _currentNavIndex = 0;

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
        },
      ),
    );
  }

  Widget _buildTabSection() {
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
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 12.h),
              decoration: BoxDecoration(
                color: appTheme.light_blue_900,
                borderRadius: BorderRadius.circular(20.h),
              ),
              child: Text(
                'Towing Services',
                style: TextStyleHelper.instance.title16MediumPoppins
                    .copyWith(color: appTheme.white_A700),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) => GestureDetector(
                onTap: () {
                  context.pushReplacementNamed('water_delivery_screen');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
                  child: Text(
                    'Water Delivery',
                    style: TextStyleHelper.instance.title16MediumPoppins
                        .copyWith(color: appTheme.light_blue_900),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
        DashboardWalletCard(walletInfo: dashboardData.wallet),
        _buildTowVehicleCard(),
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
}