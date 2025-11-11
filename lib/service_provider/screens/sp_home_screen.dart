import 'package:flutter/material.dart';
import 'package:protz/shared/models/dashboard_data.dart';
import 'package:protz/shared/widgets/dashboard_wallet_card.dart';

import '../core/app_export.dart';
import '../core/controllers/provider_availability_controller.dart';
import '../widgets/sp_bottom_nav_bar.dart';
import '../widgets/sp_home_header.dart';
import '../widgets/sp_status_toggle.dart';
import '../widgets/sp_actions_row.dart';
import '../widgets/sp_towing_section.dart';

class SPHomeScreen extends StatefulWidget {
  final DashboardData? dashboardData;
  const SPHomeScreen({super.key, this.dashboardData});

  @override
  State<SPHomeScreen> createState() => _SPHomeScreenState();
}

class _SPHomeScreenState extends State<SPHomeScreen> {
  late final ProviderAvailabilityController _availabilityController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _availabilityController = ProviderAvailabilityController(initialOnline: true);
  }

  @override
  void dispose() {
    _availabilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.dashboardData ?? _mockDashboardData();
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: appTheme.white_A700,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SPHomeHeader(
                    userName: data.user.name,
                    profileImageUrl: SPImageConstant.imgPlaceholder,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SPStatusToggle(controller: _availabilityController),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
                    child: DashboardWalletCard(walletInfo: data.wallet),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SPActionsRow(
                    actions: [
                      SPActionItem(icon: Icons.map, label: 'Route', onTap: () {}),
                      SPActionItem(icon: Icons.history, label: 'History', onTap: () {}),
                      SPActionItem(icon: Icons.settings, label: 'Settings', onTap: () {}),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: SPTowingSection(
                    available: data.serviceAvailability.towingAvailable,
                    estimatedWaitMinutes: data.serviceAvailability.estimatedWaitTimes['towing'],
                    onTap: () {},
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
          bottomNavigationBar: SPBottomNavBar(
            currentIndex: _currentIndex,
            onItemSelected: (i) => setState(() => _currentIndex = i),
            items: const [
              SPBottomNavItem(icon: Icon(Icons.home), label: 'Home'),
              SPBottomNavItem(icon: Icon(Icons.assignment), label: 'Requests'),
              SPBottomNavItem(icon: Icon(Icons.chat_bubble), label: 'Chats'),
              SPBottomNavItem(icon: Icon(Icons.account_balance_wallet), label: 'Finances'),
              SPBottomNavItem(icon: Icon(Icons.person), label: 'Account'),
            ],
          ),
        );
      },
    );
  }

  DashboardData _mockDashboardData() {
    final user = UserInfo(
      id: 'sp_1',
      name: 'Service Provider',
      email: 'sp@example.com',
      isVerified: true,
    );
    final wallet = WalletInfo(
      balance: 532.45,
      currency: 'GHS',
      recentTransactions: const [],
      isActive: true,
    );
    final stats = DashboardStats(
      totalOrders: 120,
      completedOrders: 110,
      activeOrders: 3,
      totalSpent: 0,
      currency: 'GHS',
      favoriteProviders: 0,
    );
    final availability = ServiceAvailability(
      towingAvailable: true,
      waterDeliveryAvailable: true,
      maintenanceMessage: null,
      estimatedWaitTimes: const {'towing': 8, 'waterDelivery': 12},
    );
    return DashboardData(
      user: user,
      wallet: wallet,
      recentOrders: const [],
      nearbyProviders: const [],
      activeRequests: const [],
      stats: stats,
      promotions: const [],
      serviceAvailability: availability,
    );
  }
}