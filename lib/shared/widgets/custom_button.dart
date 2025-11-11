import 'package:flutter/material.dart';

import '../../customer/core/app_export.dart';

/// CustomButton - A flexible and reusable button component
/// 
/// Supports various button styles including outlined, filled, and text-only variants
/// with customizable colors, borders, padding, and responsive sizing.
/// 
/// @param text - Button text content
/// @param onPressed - Callback function when button is pressed
/// @param width - Button width (null for auto-sizing)
/// @param height - Button height
/// @param backgroundColor - Background fill color
/// @param textColor - Text color
/// @param borderColor - Border color for outlined buttons
/// @param borderRadius - Corner radius for button shape
/// @param padding - Internal padding around text
/// @param fontSize - Text font size
/// @param fontWeight - Text font weight
/// @param borderWidth - Border thickness
/// @param isFullWidth - Whether button should take full available width
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.fontSize,
    this.fontWeight,
    this.borderWidth,
    this.isFullWidth = false,
  });

  /// Button text content
  final String text;

  /// Callback function when button is pressed
  final VoidCallback? onPressed;

  /// Button width (null for auto-sizing based on content)
  final double? width;

  /// Button height
  final double? height;

  /// Background fill color
  final Color? backgroundColor;

  /// Text color
  final Color? textColor;

  /// Border color for outlined buttons
  final Color? borderColor;

  /// Corner radius for button shape
  final double? borderRadius;

  /// Internal padding around text
  final EdgeInsets? padding;

  /// Text font size
  final double? fontSize;

  /// Text font weight
  final FontWeight? fontWeight;

  /// Border thickness
  final double? borderWidth;

  /// Whether button should take full available width
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? appTheme.whiteCustom;
    final effectiveTextColor = textColor ?? Color(0xFF086788);
    final effectiveBorderColor = borderColor ?? Color(0xFF086788);
    final effectiveBorderRadius = borderRadius ?? 12.h;
    final effectivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: 26.h,
          vertical: 12.h,
        );
    final effectiveFontSize = fontSize ?? 14.fSize;
    final effectiveFontWeight = fontWeight ?? FontWeight.w400;
    final effectiveBorderWidth = borderWidth ?? 1.h;
    final effectiveHeight = height ?? 45.h;

    Widget buttonChild = Text(
      text,
      style: TextStyleHelper.instance.bodyTextPoppins.copyWith(
        color: effectiveTextColor,
        fontSize: effectiveFontSize,
        fontWeight: effectiveFontWeight,
      ),
      textAlign: TextAlign.center,
    );

    // Determine button style based on background and border
    final bool hasBackground =
        effectiveBackgroundColor != appTheme.transparentCustom;
    final bool hasBorder = effectiveBorderColor != appTheme.transparentCustom;

    Widget button;

    if (hasBackground && hasBorder) {
      // Outlined button with background
      button = OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          
          backgroundColor: effectiveBackgroundColor,
          side: BorderSide(
            color: effectiveBorderColor,
            width: effectiveBorderWidth,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
          ),
          padding: effectivePadding,
          minimumSize: Size(
            width ?? (isFullWidth ? double.infinity : 0),
            effectiveHeight,
          ),
          maximumSize: Size(
            width ?? (isFullWidth ? double.infinity : double.infinity),
            effectiveHeight,
          ),
        ),
        child: buttonChild,
      );
    } else if (hasBackground) {
      // Filled button
      button = ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          
          backgroundColor: effectiveBackgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
          ),
          padding: effectivePadding,
          minimumSize: Size(
            width ?? (isFullWidth ? double.infinity : 0),
            effectiveHeight,
          ),
          maximumSize: Size(
            width ?? (isFullWidth ? double.infinity : double.infinity),
            effectiveHeight,
          ),
        ),
        child: buttonChild,
      );
    } else {
      // Text button
      button = TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
        
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
          ),
          padding: effectivePadding,
          minimumSize: Size(
            width ?? (isFullWidth ? double.infinity : 0),
            effectiveHeight,
          ),
          maximumSize: Size(
            width ?? (isFullWidth ? double.infinity : double.infinity),
            effectiveHeight,
          ),
        ),
        child: buttonChild,
      );
    }

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    if (width != null) {
      return SizedBox(
        width: width,
        child: button,
      );
    }

    return button;
  }
}
