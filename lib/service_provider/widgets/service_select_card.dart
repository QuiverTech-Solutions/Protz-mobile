import 'package:flutter/material.dart';
import '../core/app_export.dart';

class SPServiceSelectCard extends StatelessWidget {
  final String icon;
  final String title;
  final String caption;
  final bool selected;
  final VoidCallback onTap;

  const SPServiceSelectCard({
    super.key,
    required this.icon,
    required this.title,
    required this.caption,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: appTheme.light_blue_50,
          border: Border.all(color: appTheme.light_blue_50, width: 0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 24.h,
                  height: 24.h,
                  child: Image.asset(icon, fit: BoxFit.contain),
                ),
                Container(
                  width: 24.h,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: selected ? appTheme.light_blue_900 : appTheme.white_A700,
                    borderRadius: BorderRadius.circular(1000),
                    border: Border.all(color: appTheme.white_A700),
                  ),
                  child: selected
                      ? Icon(Icons.check, size: 16.h, color: appTheme.white_A700)
                      : null,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.fSize,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
                color: appTheme.light_blue_900,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              caption,
              style: TextStyle(
                fontSize: 10.fSize,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
                color: appTheme.blue_gray_400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}