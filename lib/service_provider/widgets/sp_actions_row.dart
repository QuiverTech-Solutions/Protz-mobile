import 'package:flutter/material.dart';
import '../core/app_export.dart';

class SPActionItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SPActionItem({required this.icon, required this.label, required this.onTap});
}

class SPActionsRow extends StatelessWidget {
  final List<SPActionItem> actions;

  const SPActionsRow({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
      child: Row(
        children: actions
            .map((a) => Expanded(
                  child: Semantics(
                    button: true,
                    label: a.label,
                    child: InkWell(
                      onTap: a.onTap,
                      borderRadius: BorderRadius.circular(12.h),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          color: appTheme.white_A700,
                          borderRadius: BorderRadius.circular(12.h),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(color: appTheme.light_blue_50),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(a.icon, color: appTheme.light_blue_900, size: 20.h),
                            SizedBox(height: 6.h),
                            Text(a.label, style: SPTextStyleHelper.instance.label10RegularPoppins),
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}