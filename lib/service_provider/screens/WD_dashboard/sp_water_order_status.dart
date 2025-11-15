import 'package:flutter/material.dart';
import '../../../customer/core/utils/image_constant.dart';
import '../../../customer/theme/text_style_helper.dart';
import '../../../shared/widgets/custom_image_view.dart';
import '../../../shared/widgets/custom_sliver_app_bar.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../core/app_export.dart';
import '../../widgets/sp_bottom_nav_bar.dart';
import '../../core/utils/nav_helper.dart';
import '../../widgets/order_progress_bar.dart';

class SPWaterOrderStatus extends StatefulWidget {
  const SPWaterOrderStatus({super.key});

  @override
  State<SPWaterOrderStatus> createState() => _SPWaterOrderStatusState();
}

class _SPWaterOrderStatusState extends State<SPWaterOrderStatus> {
  double _progress = 0.3;
  String _statusText = 'Driving to the vehicle pickup point';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white_A700,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: 'Order Request',
            onBackPressed: () => Navigator.of(context).maybePop(),
            pinned: true,
            backgroundColor: Colors.transparent,
          ),
          SliverFillRemaining(
            child: Stack(
              children: [
                Positioned.fill(child: _buildBanner()),
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.25),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _buildBottomSheet(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveExtension(16).h,
          vertical: ResponsiveExtension(20).h,
        ),
        child: Sizer(
          builder: (context, orientation, deviceType) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    _statusText,
                    style: TextStyleHelper.instance.title18MediumPoppins.copyWith(
                      fontSize: ResponsiveExtension(12).fSize,
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveExtension(12).h),
                _buildProgressSection(),
                SizedBox(height: ResponsiveExtension(16).h),
                _buildRequesterInfo(),
                SizedBox(height: ResponsiveExtension(16).h),
                _buildCancelButton(),
              ],
            );
          },
        ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          SizedBox(height: ResponsiveExtension(12).h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GHS 276',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveExtension(16).fSize,
                  color: const Color(0xFF009F22),
                ),
              ),
              Container(
                height: ResponsiveExtension(28).h,
                padding: EdgeInsets.symmetric(horizontal: 24),
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
    return OrderProgressBar(
      progress: _progress,
      leftTitle: 'Vehicle pickup',
      leftSubtitle: '(2 mins away from vehicle)',
      rightTitle: 'Delivered',
      trackColor: const Color(0xFFE5E5EA),
      fillColor: appTheme.light_blue_900,
      knobColor: Colors.grey[300],
    );
  }

  Widget _buildActionsRow() {
    return Row(
      spacing: ResponsiveExtension(12).h,
      children: [
        Expanded(
          child: CustomButton(
            text: 'View Route',
            backgroundColor: appTheme.white_A700,
            textColor: appTheme.light_blue_900,
            borderColor: appTheme.light_blue_900,
            borderRadius: ResponsiveExtension(12).h,
            height: ResponsiveExtension(44).h,
            isFullWidth: true,
            onPressed: () {},
          ),
        ),
        Expanded(
          child: CustomButton(
            text: 'Update ETA',
            backgroundColor: appTheme.white_A700,
            textColor: appTheme.light_blue_900,
            borderColor: appTheme.light_blue_900,
            borderRadius: ResponsiveExtension(12).h,
            height: ResponsiveExtension(44).h,
            isFullWidth: true,
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: 'Cancel',
        backgroundColor: appTheme.white_A700,
        textColor: const Color(0xFFE30C00),
        borderColor: const Color(0xFFE30C00),
        borderRadius: ResponsiveExtension(12).h,
        height: ResponsiveExtension(50).h,
        isFullWidth: true,
        onPressed: () {},
      ),
    );
  }
}