import 'package:flutter/material.dart';
import '../utils/app_constants.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final VoidCallback? onHistoryPressed;
  final Color? backgroundColor;
  final Color? titleColor;
  final bool pinned;
  final double expandedHeight;

  const CustomSliverAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.onHistoryPressed,
    this.backgroundColor,
    this.titleColor,
    this.pinned = true,
    this.expandedHeight = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      pinned: pinned,
      expandedHeight: expandedHeight,
      leading: GestureDetector(
        onTap: onBackPressed ?? () => Navigator.of(context).pop(),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black87,
          size: 18,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: titleColor ?? const Color(0xFF2E7D7B),
        ),
      ),
      centerTitle: false,
      actions: [
        if (onHistoryPressed != null)
          GestureDetector(
            onTap: onHistoryPressed,
            child: Container(
              margin: const EdgeInsets.all(8),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.history,
                color: Color(AppConstants.primaryColorValue),
                size: 20,
              ),
            ),
          ),
      ],
    );
  }
}