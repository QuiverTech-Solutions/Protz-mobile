import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../utils/pages.dart';
import '../../customer/core/app_export.dart';
import '../widgets/custom_service_card.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../providers/api_service_provider.dart';
import '../models/service_request.dart';
import '../../service_provider/widgets/sp_bottom_nav_bar.dart';
import '../../service_provider/core/utils/nav_helper.dart';

class OrderHistoryScreen extends ConsumerStatefulWidget {
  final bool isProvider;
  const OrderHistoryScreen({super.key, this.isProvider = false});

  @override
  ConsumerState<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends ConsumerState<OrderHistoryScreen> {
  int _currentNavIndex = 1; // Orders tab is selected (index 1)
  bool _isLoading = true;
  String? _error;
  final List<ServiceRequest> _orders = [];
  int _page = 1;
  final int _limit = 20;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory({String? status}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final api = ref.read(apiServiceProvider);
    final res = await api.getMyServiceRequests(status: status, limit: _limit, offset: (_page - 1) * _limit);
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (res.success && res.data != null) {
          _orders
            ..clear()
            ..addAll(res.data!);
        } else {
          _error = res.message ?? 'Failed to load service history';
        }
      });
    }
  }

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
                          if (_isLoading)
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 24.h),
                                child: const CircularProgressIndicator(),
                              ),
                            )
                          else if (_error != null)
                            Padding(
                              padding: EdgeInsets.only(top: 16.h),
                              child: Text(
                                _error!,
                                style: TextStyleHelper.instance.body14RegularPoppins
                                    .copyWith(color: appTheme.red_A100),
                              ),
                            )
                          else
                            (_orders.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 48.h),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.history, size: 64.h, color: appTheme.blue_gray_400),
                                          SizedBox(height: 12.h),
                                          Text(
                                            'No orders yet',
                                            style: TextStyle(
                                              fontSize: 16.fSize,
                                              fontWeight: FontWeight.w600,
                                              color: appTheme.light_blue_900,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          Text(
                                            'Your past orders will appear here',
                                            style: TextStyle(
                                              fontSize: 14.fSize,
                                              color: appTheme.blue_gray_400,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildSectionTitle('All Orders'),
                                      _buildHistoryList(_orders),
                                      SizedBox(height: 24.h),
                                    ],
                                  )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: widget.isProvider
              ? SPBottomNavBar(
                  currentIndex: 1,
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
                  onItemSelected: (index) {
                    ProviderNav.goToIndex(context, index);
                  },
                )
              : CustomBottomNavBar(
                  currentIndex: _currentNavIndex,
                  onTap: (index) {
                    setState(() {
                      _currentNavIndex = index;
                    });
                    switch (index) {
                      case 0:
                        context.go(AppRoutes.customerHome);
                        break;
                      case 1:
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

  Widget _buildHistoryList(List<ServiceRequest> items) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(color: appTheme.light_blue_50, width: 4.h),
      ),
      child: Column(
        children: items.map((order) {
          return CustomServiceCard(
            serviceTitle: 'Service Request',
            date: order.createdAt.toString().split(' ')[0],
            originLocation: order.pickupLocation.address,
            destinationLocation: order.destinationLocation?.address ?? 'N/A',
            serviceProvider: order.assignedProvider?.name ?? 'Unassigned',
            price: 'GHS ${order.finalCost?.toStringAsFixed(2) ?? order.estimatedCost?.toStringAsFixed(2) ?? '0.00'}',
            margin: EdgeInsets.only(bottom: 8.h),
          );
        }).toList(),
      ),
    );
  }
}