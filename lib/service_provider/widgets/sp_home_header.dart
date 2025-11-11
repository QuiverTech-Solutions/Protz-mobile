import 'package:flutter/material.dart';
import '../core/app_export.dart';

class SPHomeHeader extends StatelessWidget {
  final String userName;
  final String? profileImageUrl;

  const SPHomeHeader({
    super.key,
    required this.userName,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Header with greeting and user avatar',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6.h,
                children: [
                  Text('Welcome back,', style: SPTextStyleHelper.instance.body12RegularPoppins),
                  Text(userName, style: SPTextStyleHelper.instance.headline24MediumPoppins),
                ],
              ),
            ),
            Semantics(
              label: 'User profile avatar',
              image: true,
              child: CircleAvatar(
                radius: 22.h,
                backgroundColor: appTheme.light_blue_50,
                backgroundImage: (profileImageUrl != null && profileImageUrl!.isNotEmpty)
                    ? AssetImage(profileImageUrl!)
                    : AssetImage(SPImageConstant.imgPlaceholder),
              ),
            ),
          ],
        ),
      ),
    );
  }
}