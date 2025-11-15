import 'package:flutter/material.dart';

import '../../shared/widgets/custom_image_view.dart';
import '../core/app_export.dart';

class RequesterInfoCard extends StatelessWidget {
  const RequesterInfoCard({
    super.key,
    required this.name,
    required this.vehicleType,
    required this.vehicleModel,
    required this.priceText,
    required this.badgeText,
    required this.avatarImagePath,
    this.onCallPressed,
    this.onChatPressed,
    this.badgeBackgroundColor,
    this.badgeBorderColor,
    this.badgeTextColor,
    this.priceColor,
  });

  final String name;
  final String vehicleType;
  final String vehicleModel;
  final String priceText;
  final String badgeText;
  final String avatarImagePath;
  final VoidCallback? onCallPressed;
  final VoidCallback? onChatPressed;
  final Color? badgeBackgroundColor;
  final Color? badgeBorderColor;
  final Color? badgeTextColor;
  final Color? priceColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.light_blue_50,
        borderRadius: BorderRadius.circular(ResponsiveExtension(12).h),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveExtension(24).h,
        vertical: ResponsiveExtension(12).h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomImageView(
                    imagePath: avatarImagePath,
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
                        name,
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
                            vehicleType,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: ResponsiveExtension(10).fSize,
                              color: appTheme.light_blue_900,
                            ),
                          ),
                          SizedBox(width: ResponsiveExtension(4).h),
                          Text(
                            '-$vehicleModel',
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
                      child: IconButton(
                        onPressed: onCallPressed,
                        icon: Icon(Icons.phone, color: appTheme.white_A700, size: ResponsiveExtension(24).h),
                      ),
                    ),
                    Container(
                      height: ResponsiveExtension(24).h,
                      width: 1,
                      color: appTheme.white_A700.withOpacity(0.4),
                    ),
                    Padding(
                      padding: EdgeInsets.all(ResponsiveExtension(11).h),
                      child: IconButton(
                        onPressed: onChatPressed,
                        icon: Icon(Icons.chat_bubble_outline, color: appTheme.white_A700, size: ResponsiveExtension(24).h),
                      ),
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
                priceText,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveExtension(16).fSize,
                  color: priceColor ?? const Color(0xFF009F22),
                ),
              ),
              Container(
                height: ResponsiveExtension(28).h,
                padding: EdgeInsets.symmetric(horizontal: ResponsiveExtension(24).h),
                decoration: BoxDecoration(
                  color: badgeBackgroundColor ?? const Color(0x1AE30C00),
                  border: Border.all(color: badgeBorderColor ?? const Color(0x33E30C00)),
                  borderRadius: BorderRadius.circular(ResponsiveExtension(12).h),
                ),
                child: Center(
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: ResponsiveExtension(10).fSize,
                      color: badgeTextColor ?? const Color(0xFFE30C00),
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
}