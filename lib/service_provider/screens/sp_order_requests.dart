import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/app_export.dart';
import '../widgets/sp_bottom_nav_bar.dart';
import '../core/utils/nav_helper.dart';
import '../widgets/provider_status_toggle.dart';
import '../../shared/utils/pages.dart';
import '../../shared/widgets/custom_image_view.dart';
import '../../shared/widgets/segmented_toggle.dart';
import '../widgets/order_progress_bar.dart';

class SPOrderRequests extends StatefulWidget {
  const SPOrderRequests({super.key});

  @override
  State<SPOrderRequests> createState() => _SPOrderRequestsState();
}

class _SPOrderRequestsState extends State<SPOrderRequests> {
  bool _showOngoing = true;
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: appTheme.white_A700,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                SizedBox(height: 12.h),
                _buildToggle(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
                    child: Column(
                      children: [
                        _buildTowingCard(),
                        SizedBox(height: 16.h),
                        _buildWaterCard(),
                      ],
                    ),
                  ),
                ),
              ],
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
            currentIndex: 1,
            onItemSelected: (index) {
              ProviderNav.goToIndex(context, index, isWaterHome: false);
            },
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.h, 12.h, 16.h, 8.h),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: 40.h,
              height: 40.h,
              decoration: BoxDecoration(
                color: appTheme.white_A700,
                borderRadius: BorderRadius.circular(8.h),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.chevron_left, color: appTheme.gray_900),
            ),
          ),
          SizedBox(width: 8.h),
          Expanded(
            child: Text(
              'Your Order Requests',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: appTheme.light_blue_900,
              ),
            ),
          ),
          SizedBox(width: 8.h),
          SizedBox(
            width: 40.h,
            height: 40.h,
            child: Material(
              color: appTheme.white_A700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.h),
                side: BorderSide(color: appTheme.light_blue_900.withOpacity(0.1), width: 1.0),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(8.h),
                onTap: () { context.push(AppRoutes.notifications); },
                child: Center(
                  child: Icon(Icons.notifications, color: appTheme.light_blue_900),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.h),
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
      ),
    );
  }

  Widget _buildToggle() {
    return SizedBox(
      width: 300.h,
      child: SegmentedToggle(
        labels: const ['Ongoing', 'Completed'],
        selectedIndex: _showOngoing ? 0 : 1,
        onChanged: (i) => setState(() => _showOngoing = i == 0),
        height: 40.h,
      ),
    );
  }

  Widget _buildTowingCard() {
    return GestureDetector(
      onTap: () {
        context.go(AppRoutes.activeJob);
      },
      child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(color: appTheme.light_blue_50, width: 4),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '#T12345',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: appTheme.light_blue_900,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              decoration: BoxDecoration(
                color: appTheme.light_blue_50,
                borderRadius: BorderRadius.circular(12.h),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 12.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomImageView(
                            imagePath: 'assets/images/avatar.png',
                            height: 40.h,
                            width: 40.h,
                            fit: BoxFit.cover,
                            radius: BorderRadius.circular(20.h),
                          ),
                          SizedBox(width: 12.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'John Williams',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: appTheme.light_blue_900,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'SUV',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: appTheme.light_blue_900,
                                    ),
                                  ),
                                  SizedBox(width: 4.h),
                                  Text(
                                    '-Toyota Land Cruiser',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF909090),
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
                          borderRadius: BorderRadius.circular(8.h),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(11.h),
                              child: Icon(Icons.phone, color: appTheme.white_A700, size: 24.h),
                            ),
                            Container(height: 24.h, width: 1, color: appTheme.white_A700.withOpacity(0.4)),
                            Padding(
                              padding: EdgeInsets.all(11.h),
                              child: Icon(Icons.chat_bubble_outline, color: appTheme.white_A700, size: 24.h),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'GHS 276',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF009F22),
                        ),
                      ),
                      Container(
                        height: 28.h,
                        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: const Color(0x1AE30C00),
                          border: Border.all(color: const Color(0x33E30C00)),
                          borderRadius: BorderRadius.circular(12.h),
                        ),
                        child: Center(
                          child: Text(
                            'Emergency',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFE30C00),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Driving to the vehicle pickup point',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: appTheme.light_blue_900,
              ),
            ),
            SizedBox(height: 8.h),
            OrderProgressBar(
              progress: 0.3,
              trackColor: const Color(0xFFE6E0E9),
              fillColor: const Color(0xFFFef7ff),
              knobColor: const Color(0xFFFef7ff),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicle pickup',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF2A2A2A),
                      ),
                    ),
                    Text(
                      'Accra Newtown',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF8F8F8F),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Destination',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF2A2A2A),
                      ),
                    ),
                    Text(
                      'Mr. Krabbs Mechanic Shop, Danfa',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF8F8F8F),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildWaterCard() {
    return GestureDetector(
      onTap: () {
        context.goNamed(AppRouteNames.activeWaterJob);
      },
      child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(color: appTheme.light_blue_50, width: 4),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '#W12345',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: appTheme.light_blue_900,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              decoration: BoxDecoration(
                color: appTheme.light_blue_50,
                borderRadius: BorderRadius.circular(12.h),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 12.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomImageView(
                            imagePath: 'assets/images/avatar.png',
                            height: 40.h,
                            width: 40.h,
                            fit: BoxFit.cover,
                            radius: BorderRadius.circular(20.h),
                          ),
                          SizedBox(width: 12.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'John Williams',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: appTheme.light_blue_900,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'To be delivered in-',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF909090),
                                    ),
                                  ),
                                  SizedBox(width: 4.h),
                                  Text(
                                    '2 hours',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: appTheme.light_blue_900,
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
                          borderRadius: BorderRadius.circular(8.h),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(11.h),
                              child: Icon(Icons.phone, color: appTheme.white_A700, size: 24.h),
                            ),
                            Container(height: 24.h, width: 1, color: appTheme.white_A700.withOpacity(0.4)),
                            Padding(
                              padding: EdgeInsets.all(11.h),
                              child: Icon(Icons.chat_bubble_outline, color: appTheme.white_A700, size: 24.h),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'GHS 276',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF009F22),
                        ),
                      ),
                      Container(
                        height: 28.h,
                        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: const Color(0x1A000000),
                          border: Border.all(color: const Color(0x33000000)),
                          borderRadius: BorderRadius.circular(12.h),
                        ),
                        child: Center(
                          child: Text(
                            '100 Gallons',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF1E1E1E),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Driving to destination',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: appTheme.light_blue_900,
              ),
            ),
            SizedBox(height: 8.h),
            OrderProgressBar(
              progress: 0.6,
              trackColor: const Color(0xFFE6E0E9),
              fillColor: const Color(0xFFFef7ff),
              knobColor: const Color(0xFFFef7ff),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicle pickup',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF2A2A2A),
                      ),
                    ),
                    Text(
                      'Accra Newtown',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF8F8F8F),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Destination',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF2A2A2A),
                      ),
                    ),
                    Text(
                      'Mr. Krabbs Mechanic Shop, Danfa',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF8F8F8F),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }
}