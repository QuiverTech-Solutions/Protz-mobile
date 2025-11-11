import 'package:flutter/material.dart';
import '../core/app_export.dart';

class SPSectionTitle extends StatelessWidget {
  final String title;
  final String? caption;
  const SPSectionTitle({super.key, required this.title, this.caption});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.h,
              children: [
                Text(title, style: SPTextStyleHelper.instance.label10RegularPoppins),
                if (caption != null)
                  Text(caption!, style: SPTextStyleHelper.instance.body12RegularPoppins),
              ],
            ),
          ),
        ],
      ),
    );
  }
}