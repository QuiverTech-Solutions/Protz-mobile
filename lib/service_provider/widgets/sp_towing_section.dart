import 'package:flutter/material.dart';
import '../core/app_export.dart';
import 'sp_section_title.dart';
import 'sp_delivery_entry.dart';

class SPTowingSection extends StatelessWidget {
  final bool available;
  final int? estimatedWaitMinutes;
  final VoidCallback? onTap;

  const SPTowingSection({
    super.key,
    required this.available,
    this.estimatedWaitMinutes,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = available
        ? (estimatedWaitMinutes != null
            ? 'Est. wait: ${estimatedWaitMinutes} min'
            : 'Available now')
        : 'Currently unavailable';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SPSectionTitle(title: 'Towing'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: SPDeliveryEntry(
            title: 'Request Towing',
            subtitle: subtitle,
            imageAsset: SPImageConstant.imgTowing,
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}