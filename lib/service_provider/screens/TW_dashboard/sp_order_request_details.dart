import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../customer/core/utils/image_constant.dart';
import '../../../shared/utils/pages.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_image_view.dart';
import '../../core/app_export.dart';
import '../../../shared/models/service_request.dart';

class SPOrderRequestDetails extends StatelessWidget {
  const SPOrderRequestDetails({super.key, required this.request});

  final ServiceRequest request;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.white_A700,
      body: SafeArea(
        child: Sizer(
          builder: (context, orientation, deviceType) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveExtension(16).h),
                    child: Column(
                      children: [
                        SizedBox(height: ResponsiveExtension(10).h),
                        _header(context),
                        SizedBox(height: ResponsiveExtension(20).h),
                        _requesterRow(context),
                        SizedBox(height: ResponsiveExtension(20).h),
                        _divider(),
                        SizedBox(height: ResponsiveExtension(20).h),
                        _routeSection(),
                        SizedBox(height: ResponsiveExtension(20).h),
                        _divider(),
                        SizedBox(height: ResponsiveExtension(12).h),
                        _specialRequirements(),
                        SizedBox(height: ResponsiveExtension(12).h),
                        _photosGrid(),
                        SizedBox(height: ResponsiveExtension(12).h),
                        _divider(),
                        SizedBox(height: ResponsiveExtension(20).h),
                        _paymentAndUrgency(),
                        SizedBox(height: ResponsiveExtension(80).h),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveExtension(16).h),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Decline',
                            backgroundColor: appTheme.white_A700,
                            textColor: appTheme.gray_900,
                            borderColor: const Color(0xFF909090),
                            onPressed: () { Navigator.of(context).maybePop(); },
                            height: ResponsiveExtension(48).h,
                            isFullWidth: true,
                            borderRadius: ResponsiveExtension(12).h,
                          ),
                        ),
                        SizedBox(width: ResponsiveExtension(10).h),
                        Expanded(
                          child: CustomButton(
                            text: 'Accept',
                            backgroundColor: appTheme.light_blue_900,
                            textColor: appTheme.white_A700,
                            borderColor: appTheme.light_blue_900,
                            onPressed: () { context.push(AppRoutes.jobRequests); },
                            height: ResponsiveExtension(48).h,
                            isFullWidth: true,
                            borderRadius: ResponsiveExtension(12).h,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
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
            'Order Request Details',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: ResponsiveExtension(18).fSize,
              color: appTheme.light_blue_900,
            ),
          ),
        ),
        SizedBox(width: ResponsiveExtension(48).h),
      ],
    );
  }

  Widget _requesterRow(BuildContext context) {
    return Row(
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
                  request.assignedProvider?.name ?? 'John Williams',
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
                        color: appTheme.blue_gray_400,
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
              Container(
                height: ResponsiveExtension(24).h,
                width: 1,
                color: appTheme.white_A700.withOpacity(0.4),
              ),
              Padding(
                padding: EdgeInsets.all(ResponsiveExtension(11).h),
                child: Icon(Icons.chat_bubble_outline, color: appTheme.white_A700, size: ResponsiveExtension(24).h),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(height: 1, width: double.infinity, color: appTheme.light_blue_50);
  }

  Widget _routeSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(
              'From:',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: ResponsiveExtension(12).fSize,
                color: const Color(0xFF505050),
              ),
            ),
            SizedBox(height: ResponsiveExtension(8).h),
            SizedBox(
              height: ResponsiveExtension(38).h,
              width: ResponsiveExtension(13).h,
              child: CustomImageView(
                imagePath: ImageConstant.imgFormkitArrowright,
                height: ResponsiveExtension(38).h,
                width: ResponsiveExtension(13).h,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: ResponsiveExtension(8).h),
            Text(
              'To:',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: ResponsiveExtension(12).fSize,
                color: const Color(0xFF505050),
              ),
            ),
          ],
        ),
        SizedBox(width: ResponsiveExtension(12).h),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: ResponsiveExtension(48).h,
                padding: EdgeInsets.symmetric(horizontal: ResponsiveExtension(16).h, vertical: ResponsiveExtension(10).h),
                decoration: BoxDecoration(
                  color: appTheme.light_blue_50,
                  borderRadius: BorderRadius.circular(ResponsiveExtension(12).h),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    request.pickupLocation.address,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: ResponsiveExtension(12).fSize,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF505050),
                    ),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveExtension(4).h),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '5 mins away from you.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: ResponsiveExtension(10).fSize,
                    fontWeight: FontWeight.w400,
                    color: appTheme.light_blue_900,
                  ),
                ),
              ),
              SizedBox(height: ResponsiveExtension(12).h),
              Container(
                height: ResponsiveExtension(48).h,
                padding: EdgeInsets.symmetric(horizontal: ResponsiveExtension(16).h, vertical: ResponsiveExtension(10).h),
                decoration: BoxDecoration(
                  color: appTheme.light_blue_50,
                  borderRadius: BorderRadius.circular(ResponsiveExtension(12).h),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    request.destinationLocation?.address ?? '-',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: ResponsiveExtension(12).fSize,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF505050),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _specialRequirements() {
    final String requirements = (request.notes ?? (request.serviceDetails['requirements'] ?? ''))
        .toString()
        .trim();
    final String displayReq = requirements.isEmpty ? 'Winching' : requirements;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Special requirements',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: ResponsiveExtension(12).fSize,
            color: appTheme.gray_900,
          ),
        ),
        SizedBox(height: ResponsiveExtension(8).h),
        Container(
          height: ResponsiveExtension(48).h,
          padding: EdgeInsets.symmetric(horizontal: ResponsiveExtension(16).h, vertical: ResponsiveExtension(10).h),
          decoration: BoxDecoration(
            color: appTheme.light_blue_50,
            borderRadius: BorderRadius.circular(ResponsiveExtension(12).h),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              displayReq,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: ResponsiveExtension(12).fSize,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF505050),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _photosGrid() {
    final images = request.imageUrls ?? const [];
    final left = images.isNotEmpty ? images[0] : ImageConstant.imgImageNotFound;
    final right = images.length > 1 ? images[1] : ImageConstant.imgImageNotFound;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photos of Vehicle',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            fontSize: ResponsiveExtension(12).fSize,
            color: appTheme.gray_900,
          ),
        ),
        SizedBox(height: ResponsiveExtension(8).h),
        SizedBox(
          height: ResponsiveExtension(100).h,
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ResponsiveExtension(12).h),
                  child: CustomImageView(
                    imagePath: left,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: ResponsiveExtension(12).h),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ResponsiveExtension(12).h),
                  child: CustomImageView(
                    imagePath: right,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentAndUrgency() {
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
              'GHS ${request.estimatedCost?.toStringAsFixed(2) ?? '0.00'}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveExtension(16).fSize,
                color: const Color(0xFF009F22),
              ),
            ),
          ],
        ),
        Visibility(
          visible: request.urgencyLevel.toLowerCase() == 'emergency',
          replacement: const SizedBox.shrink(),
          child: Container(
            height: ResponsiveExtension(40).h,
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
                  fontSize: ResponsiveExtension(12).fSize,
                  color: const Color(0xFFE30C00),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}