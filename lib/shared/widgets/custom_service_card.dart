import 'package:flutter/material.dart';

import '../../customer/core/app_export.dart';
import 'custom_button.dart';

/// CustomServiceCard - A reusable service history card component that displays 
/// service information including title, date, locations, provider, and price.
/// Supports both interactive and non-interactive price display.
/// 
/// @param serviceTitle - The title of the service (e.g., "Towing Service")
/// @param date - The service date in string format
/// @param originLocation - Starting location of the service
/// @param destinationLocation - Ending location of the service  
/// @param serviceProvider - Name of the service provider
/// @param price - Price amount to display
/// @param onPricePressed - Optional callback for price interaction
/// @param margin - Optional margin around the card
class CustomServiceCard extends StatelessWidget {
  const CustomServiceCard({
    super.key,
    required this.serviceTitle,
    required this.date,
    required this.originLocation,
    required this.destinationLocation,
    required this.serviceProvider,
    required this.price,
    this.onPricePressed,
    this.margin,
  });

  /// Title of the service being displayed
  final String serviceTitle;

  /// Date when the service was provided
  final String date;

  /// Starting location of the service
  final String originLocation;

  /// Ending location of the service
  final String destinationLocation;

  /// Name of the service provider company
  final String serviceProvider;

  /// Price amount to be displayed
  final String price;

  /// Optional callback when price is tapped
  final VoidCallback? onPricePressed;

  /// Optional margin around the entire card
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.fromLTRB(8.h, 12.h, 8.h, 10.h),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        border: Border(
          bottom: BorderSide(
            color: appTheme.color190077,
            width: 1.h,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildServiceTitleRow(),
          SizedBox(height: 4.h),
          _buildLocationRow(),
          SizedBox(height: 4.h),
          _buildProviderPriceRow(),
        ],
      ),
    );
  }

  /// Builds the row containing service title and date
  Widget _buildServiceTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          serviceTitle,
          style: TextStyleHelper.instance.body14RegularPoppins
              .copyWith(color: appTheme.blue_gray_900_01, height: 1.5),
        ),
        Text(
          date,
          style: TextStyleHelper.instance.body14RegularPoppins
              .copyWith(color: appTheme.blue_gray_900_01, height: 1.5),
        ),
      ],
    );
  }

  /// Builds the row showing origin and destination locations with arrow
  Widget _buildLocationRow() {
    return Row(
      children: [
        Text(
          originLocation,
          style: TextStyleHelper.instance.body12RegularPoppins
              .copyWith(height: 1.5),
        ),
        SizedBox(width: 12.h),
        Icon(
          Icons.arrow_forward,
          size: 12.h,
          color: appTheme.blue_gray_900_01,
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: Text(
            destinationLocation,
            style: TextStyleHelper.instance.body12RegularPoppins
                .copyWith(height: 1.5),
          ),
        ),
      ],
    );
  }

  /// Builds the row containing service provider and price
  Widget _buildProviderPriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          serviceProvider,
          style: TextStyleHelper.instance.body12RegularPoppins
              .copyWith(color: appTheme.light_blue_800, height: 1.5),
        ),
        _buildPriceWidget(),
      ],
    );
  }

  /// Builds price widget - either interactive button or static text
  Widget _buildPriceWidget() {
    if (onPricePressed != null) {
      return CustomButton(
        text: price,
        onPressed: onPricePressed,
        backgroundColor: appTheme.transparentCustom,
        textColor: appTheme.red_500,
        fontSize: 10.fSize,
        borderRadius: 8.h,
        padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
        borderWidth: 0,
        height: null,
        isFullWidth: false,
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.h),
        decoration: BoxDecoration(
          color: appTheme.transparentCustom,
          borderRadius: BorderRadius.circular(8.h),
        ),
        child: Text(
          price,
          style: TextStyleHelper.instance.label10RegularPoppins
              .copyWith(color: appTheme.red_500, height: 1.5),
        ),
      );
    }
  }
}
