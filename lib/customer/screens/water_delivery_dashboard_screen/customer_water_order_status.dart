import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../../shared/widgets/live_tracking_map.dart';
import '../../../shared/widgets/custom_sliver_app_bar.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../service_provider/widgets/order_progress_bar.dart';
import '../../../service_provider/widgets/requester_info_card.dart';
import '../../core/utils/image_constant.dart';

class CustomerWaterOrderStatus extends StatefulWidget {
  const CustomerWaterOrderStatus({super.key});

  @override
  State<CustomerWaterOrderStatus> createState() => _CustomerWaterOrderStatusState();
}

class _CustomerWaterOrderStatusState extends State<CustomerWaterOrderStatus> {
  final double _progress = 0.3;
  final String _statusText = 'Driving to destination';

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
                Positioned.fill(child: _buildMap()),
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
                  quantityBackgroundColor: const Color(0x1A000000),
                  quantityBorderColor: const Color(0x33000000),
                  quantityTextColor: const Color(0xFF1E1E1E),
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

  Widget _buildMap() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(ResponsiveExtension(12).h),
      child: const LiveTrackingMap(isProviderContext: false),
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