import 'package:flutter/material.dart';
import '../core/app_export.dart';

class SPUploadField extends StatelessWidget {
  final String label;
  final int count;
  final VoidCallback onTap;

  const SPUploadField({
    super.key,
    required this.label,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.fSize,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
            color: appTheme.gray_900,
          ),
        ),
        SizedBox(height: 8.h),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
            decoration: BoxDecoration(
              color: appTheme.white_A700,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: appTheme.blue_gray_400.withOpacity(0.5)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.upload, size: 24.h, color: appTheme.gray_900),
                SizedBox(height: 10.h),
                Text(
                  count > 0
                      ? 'Selected $count file(s)'
                      : 'Tap here to upload file(s)',
                  style: SPTextStyleHelper.instance.body12RegularPoppins,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}