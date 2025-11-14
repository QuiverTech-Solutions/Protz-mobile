import 'package:flutter/material.dart';
import '../../../customer/core/utils/image_constant.dart';
import '../../../customer/theme/text_style_helper.dart';
import '../../../shared/widgets/custom_image_view.dart';
import '../../core/app_export.dart';
import '../../widgets/sp_bottom_nav_bar.dart';
import '../../core/utils/nav_helper.dart';

class SPTowingOrderStatus extends StatefulWidget {
  const SPTowingOrderStatus({super.key});

  @override
  State<SPTowingOrderStatus> createState() => _SPTowingOrderStatusState();
}

class _SPTowingOrderStatusState extends State<SPTowingOrderStatus> {
  double _progress = 0.3;
  String _statusText = 'Driving to the vehicle pickup point';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white_A700,
      body: SafeArea(
        child: Sizer(
          builder: (context, orientation, deviceType) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveExtension(16).h),
              child: Column(
                children: [
                  _buildHeader(context),
                  SizedBox(height: ResponsiveExtension(12).h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: ResponsiveExtension(16).h,
                        children: [
                          _buildBanner(),
                          _buildRequesterInfo(),
                          _buildPaymentAndUrgency(),
                          _buildProgressSection(),
                          _buildActionsRow(),
                          _buildUpdateButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
        currentIndex: 1,
        onItemSelected: (index) {
          ProviderNav.goToIndex(context, index, isWaterHome: false);
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            width: ResponsiveExtension(40).h,
            height: ResponsiveExtension(40).h,
            decoration: BoxDecoration(
              color: appTheme.white_A700,
              borderRadius: BorderRadius.circular(ResponsiveExtension(8).h),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.chevron_left, color: appTheme.gray_900),
          ),
        ),
        SizedBox(width: ResponsiveExtension(8).h),
        Expanded(
          child: Text(
            'Order Status',
            textAlign: TextAlign.center,
            style: TextStyleHelper.instance.title18MediumPoppins,
          ),
        ),
        SizedBox(
          width: ResponsiveExtension(88).h,
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFE30C00),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: ResponsiveExtension(12).fSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(ResponsiveExtension(12).h),
      child: CustomImageView(
        imagePath: ImageConstant.imgPlaceholder,
        height: ResponsiveExtension(140).h,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildRequesterInfo() {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.light_blue_50,
        borderRadius: BorderRadius.circular(ResponsiveExtension(12).h),
      ),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveExtension(24).h, vertical: ResponsiveExtension(12).h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgAvatar,
                height: ResponsiveExtension(40).h,
                width: ResponsiveExtension(40).h,
                fit: BoxFit.cover,
                radius: BorderRadius.circular(ResponsiveExtension(20).h),
              ),
              SizedBox(width: ResponsiveExtension(12).h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Williams',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: ResponsiveExtension(14).fSize,
                      color: appTheme.light_blue_900,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'SUV',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: ResponsiveExtension(10).fSize,
                          color: appTheme.light_blue_900,
                        ),
                      ),
                      SizedBox(width: ResponsiveExtension(4).h),
                      Text(
                        '-Toyota Land Cruiser',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: ResponsiveExtension(10).fSize,
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
              borderRadius: BorderRadius.circular(ResponsiveExtension(8).h),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(ResponsiveExtension(11).h),
                  child: Icon(Icons.phone, color: appTheme.white_A700, size: ResponsiveExtension(24).h),
                ),
                Container(height: ResponsiveExtension(24).h, width: 1, color: appTheme.white_A700.withOpacity(0.4)),
                Padding(
                  padding: EdgeInsets.all(ResponsiveExtension(11).h),
                  child: Icon(Icons.chat_bubble_outline, color: appTheme.white_A700, size: ResponsiveExtension(24).h),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentAndUrgency() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You will be paid',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: ResponsiveExtension(10).fSize,
                color: appTheme.gray_900,
              ),
            ),
            Text(
              'GHS 276',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveExtension(16).fSize,
                color: const Color(0xFF009F22),
              ),
            ),
          ],
        ),
        Container(
          height: ResponsiveExtension(28).h,
          padding: EdgeInsets.symmetric(horizontal: ResponsiveExtension(16).h, vertical: ResponsiveExtension(10).h),
          decoration: BoxDecoration(
            color: const Color(0x1AE30C00),
            border: Border.all(color: const Color(0x33E30C00)),
            borderRadius: BorderRadius.circular(ResponsiveExtension(12).h),
          ),
          child: Center(
            child: Text(
              'Emergency',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: ResponsiveExtension(10).fSize,
                color: const Color(0xFFE30C00),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _statusText,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: ResponsiveExtension(12).fSize,
            color: appTheme.light_blue_900,
          ),
        ),
        SizedBox(height: ResponsiveExtension(8).h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pickup',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: ResponsiveExtension(10).fSize,
                color: appTheme.blue_gray_400,
              ),
            ),
            Text(
              'Drop-off',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: ResponsiveExtension(10).fSize,
                color: appTheme.blue_gray_400,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveExtension(6).h),
        SizedBox(
          height: ResponsiveExtension(20).h,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: ResponsiveExtension(4).h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6E0E9),
                    borderRadius: BorderRadius.circular(ResponsiveExtension(4).h),
                  ),
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: _progress,
                    child: Container(
                      height: ResponsiveExtension(4).h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFef7ff),
                        borderRadius: BorderRadius.circular(ResponsiveExtension(100).h),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveExtension(10).h),
              Container(
                width: ResponsiveExtension(20).h,
                height: ResponsiveExtension(20).h,
                decoration: BoxDecoration(
                  color: const Color(0xFFFef7ff),
                  borderRadius: BorderRadius.circular(ResponsiveExtension(10).h),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ResponsiveExtension(8).h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: ResponsiveExtension(14).h, color: appTheme.light_blue_900),
                SizedBox(width: ResponsiveExtension(4).h),
                Text(
                  'Osu',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: ResponsiveExtension(12).fSize,
                    color: appTheme.light_blue_900,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: ResponsiveExtension(14).h, color: appTheme.light_blue_900),
                SizedBox(width: ResponsiveExtension(4).h),
                Text(
                  'East Legon',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: ResponsiveExtension(12).fSize,
                    color: appTheme.light_blue_900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionsRow() {
    return Row(
      spacing: ResponsiveExtension(12).h,
      children: [
        Expanded(
          child: Container(
            height: ResponsiveExtension(44).h,
            decoration: BoxDecoration(
              color: appTheme.white_A700,
              borderRadius: BorderRadius.circular(ResponsiveExtension(12).h),
              border: Border.all(color: appTheme.light_blue_50, width: ResponsiveExtension(4).h),
            ),
            child: Center(
              child: Text(
                'View Route',
                style: TextStyleHelper.instance.title16MediumPoppins,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: ResponsiveExtension(44).h,
            decoration: BoxDecoration(
              color: appTheme.white_A700,
              borderRadius: BorderRadius.circular(ResponsiveExtension(12).h),
              border: Border.all(color: appTheme.light_blue_50, width: ResponsiveExtension(4).h),
            ),
            child: Center(
              child: Text(
                'Update ETA',
                style: TextStyleHelper.instance.title16MediumPoppins,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _progress = (_progress + 0.2).clamp(0.0, 1.0);
            if (_progress < 0.5) {
              _statusText = 'Vehicle picked up';
            } else if (_progress < 0.9) {
              _statusText = 'Delivering vehicle';
            } else {
              _statusText = 'Delivered';
            }
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.light_blue_900,
          padding: EdgeInsets.symmetric(vertical: ResponsiveExtension(12).h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveExtension(12).h),
          ),
        ),
        child: Text(
          'Update Status',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: ResponsiveExtension(14).fSize,
            fontWeight: FontWeight.w600,
            color: appTheme.white_A700,
          ),
        ),
      ),
    );
  }
}