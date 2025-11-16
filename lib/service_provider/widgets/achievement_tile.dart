import 'package:flutter/material.dart';
import '../core/app_export.dart';

class SPAchievementTile extends StatelessWidget {
  final String title;
  final String caption;
  final IconData icon;
  final bool active;

  const SPAchievementTile({
    super.key,
    required this.title,
    required this.caption,
    required this.icon,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    if (active) {
      return Container(
        //height: 120.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [appTheme.light_blue_50, appTheme.light_blue_900],
          ),
          borderRadius: BorderRadius.circular(12.h),
        ),
        padding: EdgeInsets.all(2.h),
        child: Container(
          decoration: BoxDecoration(
            color: appTheme.light_blue_50,
            borderRadius: BorderRadius.circular(10.h),
          ),
          padding: EdgeInsets.all(12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: appTheme.light_blue_900, size: 24.h),
              SizedBox(height: 12.h),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.fSize,
                  fontWeight: FontWeight.w600,
                  color: appTheme.light_blue_900,
                ),
              ),
              SizedBox(height: 8.h),
              Divider(height: 1, color: const Color(0xFFE5E7EB)),
              SizedBox(height: 8.h),
              Center(
                child: SizedBox(
                  height: 40.h,
                  child: Text(
                    caption,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10.fSize,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF909090),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      //height: 120.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(12.h),
        border: Border.all(color: const Color(0xFFE5E5EA), width: 2),
      ),
      padding: EdgeInsets.all(12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF909090), size: 24.h),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12.fSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF909090),
            ),
          ),
          SizedBox(height: 8.h),
          Divider(height: 1, color: const Color(0xFFE5E7EB)),
          SizedBox(height: 8.h),
          Center(
            child: SizedBox(
              height: 40.h,
              child: Text(
                caption,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10.fSize,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF909090),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}