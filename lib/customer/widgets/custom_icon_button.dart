import 'package:flutter/material.dart';

import '../core/app_export.dart';
import 'custom_image_view.dart';

/**
 * A customizable icon button widget with consistent styling and border decoration.
 * Supports SVG icons, custom margins, and press callbacks while maintaining
 * a uniform appearance across the application.
 * 
 * @param imagePath - Path to the icon asset (SVG, PNG, etc.)
 * @param onPressed - Callback function executed when button is pressed
 * @param margin - Optional margin around the button
 * @param isEnabled - Whether the button is enabled or disabled
 */
class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    Key? key,
    required this.imagePath,
    this.onPressed,
    this.margin,
    this.isEnabled,
  }) : super(key: key);

  /// Path to the icon asset
  final String imagePath;

  /// Callback function when button is pressed
  final VoidCallback? onPressed;

  /// Optional margin around the button
  final EdgeInsetsGeometry? margin;

  /// Whether the button is enabled (defaults to true if onPressed is provided)
  final bool? isEnabled;

  @override
  Widget build(BuildContext context) {
    final bool buttonEnabled = isEnabled ?? (onPressed != null);

    return Container(
      margin: margin,
      child: Material(
        color: appTheme.transparentCustom,
        child: InkWell(
          onTap: buttonEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(8.h),
          child: Container(
            width: 40.h,
            height: 40.h,
            padding: EdgeInsets.all(8.h),
            decoration: BoxDecoration(
              color: appTheme.white_A700,
              border: Border.all(
                color: appTheme.color881908,
                width: 1.h,
              ),
              borderRadius: BorderRadius.circular(8.h),
            ),
            child: Center(
              child: CustomImageView(
                imagePath: imagePath,
                width: 24.h,
                height: 24.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
