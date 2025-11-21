import 'package:flutter/material.dart';
import '../core/app_export.dart';

class SPPrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool showTrailing;

  const SPPrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.showTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.light_blue_900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: SPTextStyleHelper.instance.title14RegularWhite,
              ),
            ),
            if (showTrailing)
              Container(
                width: 32.h,
                height: 32.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Icon(Icons.arrow_forward_ios),
              ),
          ],
        ),
      ),
    );
  }
}