import 'package:flutter/material.dart';
import 'package:protz/customer/core/app_export.dart';

class SegmentedToggle extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final double? height;

  const SegmentedToggle({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.height,
  }) : assert(labels.length == 2);

  @override
  Widget build(BuildContext context) {
    final double h = height ?? 40.h;
    return Container(
      height: h,
      decoration: BoxDecoration(
        color: appTheme.light_blue_50,
        borderRadius: BorderRadius.circular(1000.h),
        border: Border.all(color: appTheme.light_blue_50),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedAlign(
                alignment: selectedIndex == 0 ? Alignment.centerLeft : Alignment.centerRight,
                duration: const Duration(milliseconds: 200),
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  heightFactor: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: appTheme.light_blue_900,
                      borderRadius: BorderRadius.circular(1000.h),
                      border: Border.all(color: appTheme.light_blue_50),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onChanged(0),
                      child: Center(
                        child: Text(
                          labels[0],
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: selectedIndex == 0 ? appTheme.white_A700 : appTheme.light_blue_900.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onChanged(1),
                      child: Center(
                        child: Text(
                          labels[1],
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: selectedIndex == 1 ? appTheme.white_A700 : appTheme.light_blue_900.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}