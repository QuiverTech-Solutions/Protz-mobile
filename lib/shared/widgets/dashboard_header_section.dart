import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:protz/customer/core/app_export.dart';
import 'package:protz/shared/widgets/custom_image_view.dart';
import 'package:protz/shared/models/dashboard_data.dart';
import 'package:protz/shared/utils/pages.dart';

class DashboardHeaderSection extends StatelessWidget {
  final UserInfo userInfo;

  const DashboardHeaderSection({
    super.key,
    required this.userInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomImageView(
          imagePath: userInfo.profileImageUrl ?? ImageConstant.imgAvatar,
          height: 40.h,
          width: 40.h,
          fit: BoxFit.cover,
          radius: BorderRadius.circular(20.h),
        ),
        SizedBox(width: 8.h),
        Text(
          'Welcome, ${userInfo.name}',
          style: TextStyleHelper.instance.title18MediumPoppins,
        ),
        Spacer(),
        IconButton(
          icon: Icon(Icons.history),
          onPressed: () {context.push(AppRoutes.history);},
        ),
        IconButton(
          icon: Icon(Icons.notifications),
          padding: EdgeInsets.only(left: 12.h),
          onPressed: () {context.push(AppRoutes.notifications);},
        ),
      ],
    );
  }
}