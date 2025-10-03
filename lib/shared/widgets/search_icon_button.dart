import 'package:flutter/material.dart';
import '../utils/app_constants.dart';

class SearchIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final double borderRadius;
  final bool showBorder;

  const SearchIconButton({
    super.key,
    this.onPressed,
    this.size = 40.0,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius = 8.0,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(AppConstants.surfaceColorValue),
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder
            ? Border.all(
                color: const Color(AppConstants.primaryColorValue).withOpacity(0.1),
                width: 1.0,
              )
            : null,
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
              Icons.search,
              size: size * 0.6, // 24px for 40px container
              color: iconColor ?? const Color(AppConstants.textPrimaryColorValue),
            ),
          ),
        ),
      ),
    );
  }
}