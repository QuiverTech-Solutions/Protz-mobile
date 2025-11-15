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
import '../../widgets/requester_info_card.dart';

class SPWaterOrderStatus extends StatefulWidget {
  const SPWaterOrderStatus({super.key});

  @override
  State<SPWaterOrderStatus> createState() => _SPWaterOrderStatusState();
}

class _SPWaterOrderStatusState extends State<SPWaterOrderStatus> {
  double _progress = 0.3;
  String _statusText = 'Driving to destination';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white_A700,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: 'Order Request',
            onBackPressed: () => Navigator.of(context).pop(),
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
                RequesterInfoCard(
                  name: 'John Williams',
                  priceText: 'GHS 276',
                  avatarImagePath: ImageConstant.imgAvatar,
                  infoPrefix: 'To be delivered in-',
                  infoHighlight: '2 hours',
                  quantityText: '100 Gallons',
                  onCallPressed: () {},
                  onChatPressed: () {},
                ),
                SizedBox(height: ResponsiveExtension(16).h),
                SizedBox(
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
                ),
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

}