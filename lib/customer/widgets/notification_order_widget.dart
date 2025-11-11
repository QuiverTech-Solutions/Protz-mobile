import 'package:flutter/material.dart';
import '../core/app_export.dart';
import '../screens/notifications_screen.dart';

class NotificationOrderWidget extends StatelessWidget {
  final NotificationData notification;
  final VoidCallback? onTap;

  const NotificationOrderWidget({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: notification.isRead 
              ? appTheme.white_A700 
              : appTheme.light_blue_50,
          borderRadius: BorderRadius.circular(12.h),
          border: Border.all(
            color: appTheme.gray_100,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: appTheme.black_900.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 12),
            _buildDescription(),
            SizedBox(height: 16),
            _buildLocationRow(),
            SizedBox(height: 12),
            _buildServiceAndPriceRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Status indicator dot
        Container(
          width: 8.h,
          height: 8.h,
          decoration: BoxDecoration(
            color: notification.isRead 
                ? appTheme.blue_gray_400 
                : appTheme.light_blue_900,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8.h),
        Expanded(
          child: Text(
            notification.type,
            style: TextStyle(
              fontSize: 16.fSize,
              fontWeight: FontWeight.w600,
              color: appTheme.light_blue_900,
            ),
          ),
        ),
        Text(
          notification.date,
          style: TextStyle(
            fontSize: 14.fSize,
            fontWeight: FontWeight.w400,
            color: appTheme.blue_gray_400,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      notification.description,
      style: TextStyle(
        fontSize: 14.fSize,
        fontWeight: FontWeight.w400,
        color: appTheme.gray_900,
        height: 1.4,
      ),
    );
  }

  Widget _buildLocationRow() {
    return Row(
      children: [
        Expanded(
          child: Text(
            notification.fromLocation,
            style: TextStyle(
              fontSize: 12.fSize,
              fontWeight: FontWeight.w400,
              color: appTheme.blue_gray_400,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.h),
          child: Icon(
            Icons.arrow_forward,
            size: 16.h,
            color: appTheme.green_900,
          ),
        ),
        Expanded(
          child: Text(
            notification.toLocation,
            style: TextStyle(
              fontSize: 12.fSize,
              fontWeight: FontWeight.w400,
              color: appTheme.blue_gray_400,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceAndPriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            notification.serviceName,
            style: TextStyle(
              fontSize: 14.fSize,
              fontWeight: FontWeight.w500,
              color: appTheme.light_blue_900,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12.h,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: appTheme.red_A100.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.h),
          ),
          child: Text(
            notification.price,
            style: TextStyle(
              fontSize: 14.fSize,
              fontWeight: FontWeight.w600,
              color: appTheme.red_A100,
            ),
          ),
        ),
      ],
    );
  }
}