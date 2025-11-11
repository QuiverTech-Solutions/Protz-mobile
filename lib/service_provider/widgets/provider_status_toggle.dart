import 'package:flutter/material.dart';
import '../core/app_export.dart';
import '../../shared/widgets/custom_image_view.dart';

class ProviderStatusToggle extends StatelessWidget {
  const ProviderStatusToggle({
    super.key,
    required this.isOnline,
    required this.onChanged,
  });

    /// Current provider availability state
  final bool isOnline;

    /// Callback when user toggles state
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    // Figma: Green #009F22 at 50% alpha for the border when online
    const Color onlineBorder = Color.fromRGBO(0, 159, 34, 0.5);
    // Use a soft red for offline state at 50% alpha
    const Color offlineBorder = Color.fromRGBO(227, 12, 0, 0.5);

    // Figma asset reference (online prediction icon). Falls back to default icon if not available.
    final String onlineIconUrl = isOnline ?
        'assets/images/material-symbols_online-prediction-rounded.svg': 'assets/images/offine_icon.svg';

    final Color borderColor = isOnline ? onlineBorder : offlineBorder;

    return SizedBox(
      width: 40.h,
      height: 40.h,
      child: Material(
        color: appTheme.white_A700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.h),
          side: BorderSide(color: borderColor, width: 1.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8.h),
          onTap: () => onChanged(!isOnline),
          child: Padding(
            padding: EdgeInsets.all(12.h),
            child: Center(
              child: CustomImageView(
                imagePath: onlineIconUrl,
                height: 24.h,
                width: 24.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}