import 'package:flutter/material.dart';
import 'package:protz/customer/core/utils/size_utils.dart';
import 'package:protz/shared/models/dashboard_data.dart';
import 'package:protz/customer/theme/text_style_helper.dart';
import 'package:protz/customer/theme/theme_helper.dart';
import 'package:protz/shared/widgets/custom_button.dart';

class DashboardWalletCard extends StatelessWidget {
  final WalletInfo walletInfo;
  final String? accountOwnerName;
  final String? serviceLabel;
  final VoidCallback? onWithdraw;

  const DashboardWalletCard({
    super.key,
    required this.walletInfo,
    this.accountOwnerName,
    this.serviceLabel,
    this.onWithdraw,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 14.h),
      decoration: BoxDecoration(
        color: appTheme.light_blue_900,
        border: Border.all(color: appTheme.light_blue_50, width: 4.h),
        borderRadius: BorderRadius.circular(24.h),
      ),
      child: Column(
        spacing: 10.h,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  spacing: 8.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Protz Wallet Account:',
                      style: TextStyleHelper.instance.body14RegularPoppins,
                    ),
                    Row(
                      children: [
                        Text(
                          'GHS',
                          style: TextStyleHelper.instance.headline24MediumPoppins,
                        ),
                        SizedBox(width: 8.h),
                        Text(
                          '******',
                          style: TextStyleHelper.instance.headline24MediumPoppins,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                spacing: 8.h,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    accountOwnerName ?? 'Account Balance',
                    style: TextStyleHelper.instance.body14RegularPoppins,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: appTheme.light_blue_50,
                      borderRadius: BorderRadius.circular(8.h),
                    ),
                    child: Text(
                      serviceLabel ?? 'Customer',
                      style: TextStyleHelper.instance.label10RegularPoppins,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          CustomButton(
            text: 'Withdraw',
            onPressed: onWithdraw,
            backgroundColor: appTheme.white_A700,
            textColor: appTheme.light_blue_900,
            borderColor: appTheme.light_blue_900,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }
}