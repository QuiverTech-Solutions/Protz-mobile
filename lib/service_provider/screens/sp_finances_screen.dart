import 'package:flutter/material.dart';

import '../core/app_export.dart';
import '../core/utils/nav_helper.dart';
import '../widgets/earnings_summary_card.dart';
import '../widgets/sp_bottom_nav_bar.dart';
import '../widgets/provider_status_toggle.dart';
import 'package:protz/shared/widgets/dashboard_wallet_card.dart';
import 'package:protz/shared/models/dashboard_data.dart';
import 'package:protz/customer/core/utils/size_utils.dart' as cus_size;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protz/shared/providers/api_service_provider.dart';
import 'package:protz/shared/providers/dashboard_provider.dart';


class SPFinancesScreen extends StatefulWidget {
  const SPFinancesScreen({super.key});

  @override
  State<SPFinancesScreen> createState() => _SPFinancesScreenState();
}

class _SPFinancesScreenState extends State<SPFinancesScreen> {
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white_A700,
      body: SafeArea(
        child: Sizer(
          builder: (context, orientation, deviceType) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveExtension(16).h,
                      vertical: ResponsiveExtension(12).h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        SizedBox(height: ResponsiveExtension(16).h),
                        Consumer(builder: (context, ref, _) {
                          final api = ref.read(apiServiceProvider);
                          return FutureBuilder(
                            future: Future.wait([
                              api.getRecentPayments(limit: 50),
                              api.getRecentPayments(limit: 60),
                              api.getRecentPayments(limit: 100 ),
                            ]),
                            builder: (context, snapshot) {
                              double today = 0, week = 0, month = 0;
                              if (snapshot.hasData) {
                                final res = snapshot.data as List<dynamic>;
                                today = _sumAmounts(res[0]);
                                week = _sumAmounts(res[1]);
                                month = _sumAmounts(res[2]);
                              }
                              final total = month; // simple total proxy
                              final currency = ref.watch(walletInfoProvider)?.currency ?? 'GHS';
                              return SPEarningsSummaryCard(
                                currency: currency,
                                totalDisplay: total.toStringAsFixed(0),
                                todayDisplay: today.toStringAsFixed(0),
                                weekDisplay: week.toStringAsFixed(0),
                                monthDisplay: month.toStringAsFixed(0),
                              );
                            },
                          );
                        }),
                        SizedBox(height: ResponsiveExtension(16).h),
                        _buildWalletCard(),
                        SizedBox(height: ResponsiveExtension(24).h),
                       
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
        currentIndex: 3,
        onItemSelected: (index) {
          ProviderNav.goToIndex(context, index);
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: Container(
                width: ResponsiveExtension(40).h,
                height: ResponsiveExtension(40).h,
                decoration: BoxDecoration(
                  color: appTheme.white_A700,
                  borderRadius: BorderRadius.circular(ResponsiveExtension(8).h),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.chevron_left),
              ),
            ),
            SizedBox(width: ResponsiveExtension(4).h),
            Text(
              'Your Finances',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: ResponsiveExtension(18).fSize,
                fontWeight: FontWeight.w500,
                color: appTheme.light_blue_900,
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
                border: Border.all(color: appTheme.light_blue_900.withOpacity(0.1)),
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {},
              ),
            ),
            SizedBox(width: ResponsiveExtension(12).h),
            ProviderStatusToggle(),
          ],
        ),
      ],
    );
  }

  

  Widget _buildWalletCard() {
    return Consumer(builder: (context, ref, _) {
      final walletInfo = ref.watch(walletInfoProvider);
      final user = ref.watch(userInfoProvider);
      final info = walletInfo ?? WalletInfo(balance: 0, currency: 'GHS', recentTransactions: const [], isActive: false);
      return cus_size.Sizer(
        builder: (context, orientation, deviceType) {
          return DashboardWalletCard(
            walletInfo: info,
            accountOwnerName: user?.name,
            serviceLabel: 'Provider',
            onWithdraw: () {},
          );
        },
      );
    });
  }

  
  List<Transaction> _placeholderTransactions() {
    return [
      Transaction(
        id: 't1',
        amount: 200.00,
        type: 'debit',
        description: 'Withdrawal to Bank',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Transaction(
        id: 't2',
        amount: 500.00,
        type: 'credit',
        description: 'Top up',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Transaction(
        id: 't3',
        amount: 120.50,
        type: 'credit',
        description: 'Order #T12345',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }

  double _sumAmounts(dynamic apiRes) {
    if (apiRes == null) return 0;
    try {
      final data = (apiRes as dynamic).data as List<dynamic>?;
      if (data == null) return 0;
      return data.fold<double>(0, (sum, e) {
        final amt = (e as Map<String, dynamic>)['amount'];
        if (amt is num) return sum + amt.toDouble();
        return sum;
      });
    } catch (_) {
      return 0;
    }
  }
}
