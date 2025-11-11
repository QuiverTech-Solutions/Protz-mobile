import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/theme_helper.dart';
import '../../customer/core/utils/size_utils.dart';

Future<void> showSPSuccessToast(
  BuildContext context, {
  String title = 'Success!',
  String subtitle = 'Your PIN has been set successfully.',
  String caption = 'You will now be redirected',
  int durationMs = 1800,
}) async {
  await showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Success Toast',
    barrierColor: Colors.black.withOpacity(0.2),
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (context, anim1, anim2) {
      return _SPSuccessToastDialog(
        title: title,
        subtitle: subtitle,
        caption: caption,
        durationMs: durationMs,
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      final curved = CurvedAnimation(parent: anim1, curve: Curves.easeOut);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.98, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _SPSuccessToastDialog extends StatefulWidget {
  const _SPSuccessToastDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.caption,
    required this.durationMs,
  });

  final String title;
  final String subtitle;
  final String caption;
  final int durationMs;

  @override
  State<_SPSuccessToastDialog> createState() => _SPSuccessToastDialogState();
}

class _SPSuccessToastDialogState extends State<_SPSuccessToastDialog> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(milliseconds: widget.durationMs), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 280.h,
          constraints: BoxConstraints(minHeight: 180.h),
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 24.h),
          decoration: BoxDecoration(
            color: appTheme.white_A700,
            borderRadius: BorderRadius.circular(24.h),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8.h),
              Container(
                width: 56.h,
                height: 56.h,
                decoration: BoxDecoration(
                  color: appTheme.light_blue_50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: appTheme.light_blue_900,
                  size: 32.h,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  height: 1.0,
                  color: Color(0xFF086788), // Protz Primary
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                widget.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  height: 1.0,
                  color: Color(0xFF1E1E1E), // Black
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                widget.caption,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  height: 1.2,
                  color: Color(0xFF909090), // Light Grey
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}