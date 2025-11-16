import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../customer/core/utils/image_constant.dart';
import '../core/app_export.dart';
import '../core/utils/nav_helper.dart';
import '../widgets/sp_bottom_nav_bar.dart';
import '../widgets/provider_status_toggle.dart';
import '../../shared/utils/pages.dart';
import '../widgets/earnings_summary_card.dart';
import 'package:protz/shared/providers/dashboard_provider.dart';
import 'package:protz/shared/widgets/dashboard_wallet_card.dart';
import 'package:protz/shared/models/dashboard_data.dart';
import '../widgets/achievement_tile.dart';

class SPAccountPage extends StatefulWidget {
  const SPAccountPage({super.key});

  @override
  State<SPAccountPage> createState() => _SPAccountPageState();
}

class _SPAccountPageState extends State<SPAccountPage> {
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.light_blue_900,
      body: SafeArea(
        child: Sizer(
          builder: (context, orientation, deviceType) {
            return Stack(
              children: [
                Positioned(
                  bottom: -250,
                  child: Container(
                    height: ResponsiveExtension(540).h,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: appTheme.white_A700,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ResponsiveExtension(24).h),
                        topRight: Radius.circular(ResponsiveExtension(24).h),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    _buildHeader(context),
                    SizedBox(height: ResponsiveExtension(16).h),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveExtension(24).h),
                      child: Column(
                        children: [
                          _buildProfileCard(context),
                          SizedBox(height: ResponsiveExtension(16).h),
                      _buildAccountSettingsButton(context),
                      SizedBox(height: ResponsiveExtension(16).h),
                        ],
                      ),
                      
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveExtension(24).h),
                        child: Consumer(
                          builder: (context, ref, _) {
                            final wallet = ref.watch(walletInfoProvider);
                            final user = ref.watch(userInfoProvider);
                            final dashboardState = ref.watch(dashboardProvider);
                            final stats = dashboardState.data?.stats;

                            return ListView(
                              children: [
                               
                                _buildWalletSection(
                                  context,
                                  wallet ??
                                      WalletInfo(
                                        balance: 0,
                                        currency: 'GHS',
                                        recentTransactions: const [],
                                        isActive: false,
                                      ),
                                  user,
                                ),
                                SizedBox(height: ResponsiveExtension(16).h),
                                SPEarningsSummaryCard(
                                  variant: SPEarningsCardVariant.account,
                                  currency: wallet?.currency ?? 'GHS',
                                  totalDisplay: ((stats?.totalSpent ?? 0)
                                      .toStringAsFixed(0)),
                                  todayDisplay: ((wallet?.balance ?? 0)
                                      .toStringAsFixed(0)),
                                  weekDisplay: '0',
                                  monthDisplay: '0',
                                  deliveriesDisplay:
                                      (stats?.completedOrders ?? 0).toString(),
                                  totalEarningsDisplay:
                                      '${stats?.currency ?? (wallet?.currency ?? 'GHS')} ${(stats?.totalSpent ?? 0).toStringAsFixed(0)}',
                                  completionRateDisplay: (() {
                                    final total = stats?.totalOrders ?? 0;
                                    final completed =
                                        stats?.completedOrders ?? 0;
                                    final rate = total == 0
                                        ? 0
                                        : ((completed / total) * 100).round();
                                    return '$rate%';
                                  })(),
                                ),
                                SizedBox(height: ResponsiveExtension(20).h),
                                _buildAchievementsSection(context, user),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
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
        currentIndex: 4,
        onItemSelected: (index) {
          ProviderNav.goToIndex(context, index);
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ResponsiveExtension(24).h,
          vertical: ResponsiveExtension(24).h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  width: ResponsiveExtension(40).h,
                  height: ResponsiveExtension(40).h,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.chevron_left,
                    color: appTheme.white_A700,
                  ),
                ),
              ),
              SizedBox(width: ResponsiveExtension(4).h),
              Text(
                'Your Account',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: ResponsiveExtension(18).fSize,
                  fontWeight: FontWeight.w500,
                  color: appTheme.white_A700,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: ResponsiveExtension(40).h,
                height: ResponsiveExtension(40).h,
                decoration: BoxDecoration(
                  color: appTheme.white_A700,
                  borderRadius: BorderRadius.circular(ResponsiveExtension(8).h),
                  border: Border.all(
                      color: appTheme.light_blue_50.withOpacity(0.5)),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.notifications),
              ),
              SizedBox(width: ResponsiveExtension(12).h),
              ProviderStatusToggle(
                isOnline: _isOnline,
                onChanged: (value) {
                  setState(() => _isOnline = value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(value ? 'Status: Online' : 'Status: Offline'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveExtension(4).h),
      child: Row(
        children: [
          Container(
            width: ResponsiveExtension(48).h,
            height: ResponsiveExtension(48).h,
            decoration: BoxDecoration(
              border: Border.all(color: appTheme.light_blue_50, width: 4),
              borderRadius: BorderRadius.circular(ResponsiveExtension(100).h),
            ),
            child: CircleAvatar(
              radius: ResponsiveExtension(24).h,
              backgroundImage: AssetImage(ImageConstant.imgAvatar),
            ),
          ),
          SizedBox(width: ResponsiveExtension(16).h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Fabrizio Trucks',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: ResponsiveExtension(18).fSize,
                        fontWeight: FontWeight.w500,
                        color: appTheme.white_A700,
                      ),
                    ),
                    SizedBox(width: ResponsiveExtension(4).h),
                    Icon(Icons.verified,
                        color: appTheme.white_A700,
                        size: ResponsiveExtension(20).h),
                  ],
                ),
                SizedBox(height: ResponsiveExtension(4).h),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: appTheme.light_blue_50,
                        borderRadius:
                            BorderRadius.circular(ResponsiveExtension(100).h),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveExtension(8).h,
                          vertical: ResponsiveExtension(2).h),
                      child: Row(
                        children: [
                          const Icon(Icons.star,
                              size: 16, color: Color(0xFF1E1E1E)),
                          SizedBox(width: ResponsiveExtension(4).h),
                          Text(
                            '4.5',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: ResponsiveExtension(12).fSize,
                              color: const Color(0xFF1E1E1E),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: ResponsiveExtension(8).h),
                    Container(
                      decoration: BoxDecoration(
                        color: appTheme.light_blue_50,
                        borderRadius:
                            BorderRadius.circular(ResponsiveExtension(8).h),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveExtension(8).h,
                          vertical: ResponsiveExtension(4).h),
                      child: Text(
                        'Towing Service',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: ResponsiveExtension(12).fSize,
                          color: appTheme.light_blue_900,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettingsButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Placeholder for dedicated provider account settings screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account Settings coming soon')),
        );
      },
      child: Container(
        height: ResponsiveExtension(48).h,
        decoration: BoxDecoration(
          color: appTheme.white_A700,
          borderRadius: BorderRadius.circular(ResponsiveExtension(12).h),
          border: Border.all(color: appTheme.light_blue_900),
        ),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveExtension(24).h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.settings, color: Color(0xFF086788), size: 20),
            SizedBox(width: ResponsiveExtension(10).h),
            Text(
              'Account Settings',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: ResponsiveExtension(14).fSize,
                color: appTheme.light_blue_900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletSection(
      BuildContext context, WalletInfo wallet, UserInfo? user) {
    return DashboardWalletCard(
      walletInfo: wallet,
      accountOwnerName: user?.name,
      serviceLabel: 'Provider',
      onWithdraw: () {
        context.push(AppRoutes.earnings);
      },
      onViewBalance: () {},
      variant: DashboardWalletCardVariant.account,
    );
  }

  Widget _buildAchievementsSection(BuildContext context, UserInfo? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ACHIEVEMENTS',
          style: SPTextStyleHelper.instance.label10RegularPoppins,
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: SPAchievementTile(
                title: 'Verified',
                caption: 'Get your account verified',
                icon: Icons.verified,
                active: user?.isVerified ?? false,
              ),
            ),
            SizedBox(width: 12.h),
            Expanded(
              child: SPAchievementTile(
                title: 'Set-Off',
                caption: 'Complete your first delivery',
                icon: Icons.flag,
                active: false,
              ),
            ),
            SizedBox(width: 12.h),
            Expanded(
              child: SPAchievementTile(
                title: 'Workaholic',
                caption: 'Complete a total of 20',
                icon: Icons.work_history,
                active: false,
              ),
            ),
          ],
        ),
      ],
    );
  }




}
