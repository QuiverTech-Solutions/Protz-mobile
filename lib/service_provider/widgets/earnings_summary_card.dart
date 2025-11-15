import 'package:flutter/material.dart';
import '../core/app_export.dart';

enum SPEarningsCardVariant { finance, account }

class SPEarningsSummaryCard extends StatelessWidget {
  final String currency;
  final String totalDisplay;
  final String todayDisplay;
  final String weekDisplay;
  final String monthDisplay;

  final SPEarningsCardVariant variant;
  final String? deliveriesDisplay;
  final String? totalEarningsDisplay;
  final String? completionRateDisplay;

  const SPEarningsSummaryCard({
    super.key,
    required this.currency,
    required this.totalDisplay,
    required this.todayDisplay,
    required this.weekDisplay,
    required this.monthDisplay,
    this.variant = SPEarningsCardVariant.finance,
    this.deliveriesDisplay,
    this.totalEarningsDisplay,
    this.completionRateDisplay,
  });

  @override
  Widget build(BuildContext context) {
    if (variant == SPEarningsCardVariant.account) {
      return Container(
        decoration: BoxDecoration(
          color: appTheme.white_A700,
          borderRadius: BorderRadius.circular(ResponsiveExtension(12).h),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(ResponsiveExtension(16).h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Earned Today',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: ResponsiveExtension(12).fSize,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF909090),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currency,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: ResponsiveExtension(32).fSize,
                    fontWeight: FontWeight.w600,
                    color: appTheme.light_blue_900,
                  ),
                ),
                SizedBox(width: ResponsiveExtension(4).h),
                Text(
                  todayDisplay,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: ResponsiveExtension(32).fSize,
                    fontWeight: FontWeight.w600,
                    color: appTheme.light_blue_900,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveExtension(12).h),
            Divider(height: 1, color: const Color(0xFFE5E7EB)),
            SizedBox(height: ResponsiveExtension(12).h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _metric('Total Deliveries', deliveriesDisplay ?? '-')),
                Container(width: 1, height: ResponsiveExtension(30).h, color: const Color(0xFFE5E7EB)),
                Expanded(child: _metric('Total Earnings', totalEarningsDisplay ?? '-')),
                Container(width: 1, height: ResponsiveExtension(30).h, color: const Color(0xFFE5E7EB)),
                Expanded(child: _metric('Completion Rate', completionRateDisplay ?? '-')),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        borderRadius: BorderRadius.circular(ResponsiveExtension(12).h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(ResponsiveExtension(16).h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Earnings',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: ResponsiveExtension(12).fSize,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF909090),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currency,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: ResponsiveExtension(32).fSize,
                      fontWeight: FontWeight.w600,
                      color: appTheme.gray_900,
                    ),
                  ),
                  SizedBox(width: ResponsiveExtension(4).h),
                  Text(
                    totalDisplay,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: ResponsiveExtension(32).fSize,
                      fontWeight: FontWeight.w600,
                      color: appTheme.light_blue_900,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: ResponsiveExtension(8).h),
          Divider(height: 1, color: const Color(0xFFE5E7EB)),
          SizedBox(height: ResponsiveExtension(12).h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _metric('Today', todayDisplay),
              Container(width: 1, height: ResponsiveExtension(30).h, color: const Color(0xFFE5E7EB)),
              _metric('This Week', weekDisplay),
              Container(width: 1, height: ResponsiveExtension(30).h, color: const Color(0xFFE5E7EB)),
              _metric('This Month', monthDisplay),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metric(String label, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: ResponsiveExtension(10).fSize,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF909090),
          ),
        ),
        SizedBox(height: ResponsiveExtension(4).h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              currency,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: ResponsiveExtension(16).fSize,
                fontWeight: FontWeight.w500,
                color: appTheme.gray_900,
              ),
            ),
            SizedBox(width: ResponsiveExtension(4).h),
            Text(
              amount,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: ResponsiveExtension(16).fSize,
                fontWeight: FontWeight.w500,
                color: appTheme.light_blue_900,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _accountMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: ResponsiveExtension(10).fSize,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF909090),
          ),
        ),
        SizedBox(height: ResponsiveExtension(6).h),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: ResponsiveExtension(14).fSize,
            fontWeight: FontWeight.w600,
            color: appTheme.gray_900,
          ),
        ),
      ],
    );
  }
}