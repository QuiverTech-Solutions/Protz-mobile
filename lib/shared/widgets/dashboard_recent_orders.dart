import 'package:flutter/material.dart';
import 'package:protz/customer/core/utils/size_utils.dart';
import 'package:protz/shared/widgets/custom_service_card.dart';
import 'package:protz/shared/models/service_request.dart';
import 'package:protz/customer/theme/text_style_helper.dart';
import 'package:protz/customer/theme/theme_helper.dart';

class DashboardRecentOrders extends StatelessWidget {
  final List<ServiceRequest> recentOrders;

  const DashboardRecentOrders({
    super.key,
    required this.recentOrders,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 32.h),
          child: Text(
            'Your recent orders',
            style: TextStyleHelper.instance.title16MediumPoppins,
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 8.h),
          decoration: BoxDecoration(
            color: appTheme.white_A700,
            border: Border.all(color: appTheme.light_blue_50, width: 4.h),
            borderRadius: BorderRadius.circular(12.h),
          ),
          child: Column(
            children: recentOrders.map((order) {
              bool isLastItem = recentOrders.indexOf(order) == recentOrders.length - 1;
              return CustomServiceCard(
                serviceTitle: order.serviceType,
                date: order.createdAt.toString().split(' ')[0], // Format date
                originLocation: order.pickupLocation.address,
                destinationLocation: order.destinationLocation?.address ?? 'N/A',
                serviceProvider: order.assignedProvider?.name ?? 'Unassigned',
                price: 'GHS ${order.finalCost?.toStringAsFixed(2) ?? order.estimatedCost?.toStringAsFixed(2) ?? '0.00'}',
                onPricePressed: isLastItem ? () {} : null,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}