import 'package:flutter/material.dart';
import '../utils/app_constants.dart';

class BackIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final double borderRadius;

  const BackIconButton({
    super.key,
    this.onPressed,
    this.size = 40.0,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(AppConstants.surfaceColorValue),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(AppConstants.shadowColorValue),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(
            child: Icon(
              Icons.chevron_left,
              size: size * 0.6, // 24px for 40px container
              color: iconColor ?? const Color(AppConstants.textPrimaryColorValue),
            ),
          ),
        ),
      ),
    );
  }
}