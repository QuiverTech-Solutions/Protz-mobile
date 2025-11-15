import 'package:flutter/material.dart';
import '../core/app_export.dart';

class OrderProgressBar extends StatelessWidget {
  const OrderProgressBar({
    super.key,
    required this.progress,
    this.leftTitle,
    this.leftSubtitle,
    this.rightTitle,
    this.trackColor,
    this.fillColor,
    this.knobColor,
  });

  final double progress;
  final String? leftTitle;
  final String? leftSubtitle;
  final String? rightTitle;
  final Color? trackColor;
  final Color? fillColor;
  final Color? knobColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leftTitle != null || rightTitle != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leftTitle != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leftTitle!,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: ResponsiveExtension(10).fSize,
                        color: appTheme.light_blue_900,
                      ),
                    ),
                    if (leftSubtitle != null) ...[
                      SizedBox(height: ResponsiveExtension(2).h),
                      Text(
                        leftSubtitle!,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: ResponsiveExtension(10).fSize,
                          color: appTheme.blue_gray_400,
                        ),
                      ),
                    ],
                  ],
                ),
              if (rightTitle != null)
                Text(
                  rightTitle!,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: ResponsiveExtension(10).fSize,
                    color: appTheme.light_blue_900,
                  ),
                ),
            ],
          ),
        if (leftTitle != null || rightTitle != null)
          SizedBox(height: ResponsiveExtension(8).h),
        SizedBox(
          height: ResponsiveExtension(20).h,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: ResponsiveExtension(4).h,
                  decoration: BoxDecoration(
                    color: trackColor ?? const Color(0xFFE5E5EA),
                    borderRadius: BorderRadius.circular(ResponsiveExtension(4).h),
                  ),
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(
                      height: ResponsiveExtension(4).h,
                      decoration: BoxDecoration(
                        color: fillColor ?? appTheme.light_blue_900,
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
                  color: knobColor ?? Colors.grey[300],
                  borderRadius: BorderRadius.circular(ResponsiveExtension(10).h),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}