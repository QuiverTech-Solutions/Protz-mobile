import 'package:flutter/material.dart';
import '../core/app_export.dart';

class SPDeliveryEntry extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imageAsset;
  final VoidCallback? onTap;

  const SPDeliveryEntry({
    super.key,
    required this.title,
    required this.subtitle,
    this.imageAsset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final image = imageAsset ?? SPImageConstant.imgPlaceholder;
    return Semantics(
      label: '$title, $subtitle',
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.h),
        child: Container(
          padding: EdgeInsets.all(12.h),
          decoration: BoxDecoration(
            color: appTheme.white_A700,
            borderRadius: BorderRadius.circular(16.h),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: appTheme.light_blue_50),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.h),
                child: Image.asset(
                  image,
                  width: 48.h,
                  height: 48.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.h,
                  children: [
                    Text(title, style: SPTextStyleHelper.instance.label10RegularPoppins),
                    Text(subtitle, style: SPTextStyleHelper.instance.body12RegularPoppins),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: appTheme.blue_gray_400),
            ],
          ),
        ),
      ),
    );
  }
}