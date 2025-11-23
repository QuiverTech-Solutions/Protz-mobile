import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/app_export.dart';
import '../../shared/widgets/custom_image_view.dart';
import '../../shared/providers/api_service_provider.dart';
import '../../shared/providers/dashboard_provider.dart';
class ProviderStatusToggle extends ConsumerStatefulWidget {
  const ProviderStatusToggle({
    super.key,
    this.initialOnline,
  });

  final bool? initialOnline;

  @override
  ConsumerState<ProviderStatusToggle> createState() => _ProviderStatusToggleState();
}

class _ProviderStatusToggleState extends ConsumerState<ProviderStatusToggle> {
  late bool _isOnline;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _isOnline = widget.initialOnline ?? false;
    Future.microtask(_fetchInitial);
  }

  Future<void> _fetchInitial() async {
    setState(() => _isBusy = true);
    final api = ref.read(apiServiceProvider);
    final profile = await api.getMyServiceProviderProfile();
    if (profile.success) {
      final data = profile.data ?? const <String, dynamic>{};
      final bool available = data['is_available'] == true;
      final bool online = data['is_online'] == true;
      setState(() => _isOnline = available || online);
    }
    setState(() => _isBusy = false);
  }

  Future<void> _toggle() async {
    if (_isBusy) return;
    final newValue = !_isOnline;

    final api = ref.read(apiServiceProvider);

    final profile = await api.getMyServiceProviderProfile();
    if (!profile.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(profile.message.isNotEmpty ? profile.message : 'Insufficient permissions')),
      );
      return;
    }
  /*
    final data = profile.data ?? const <String, dynamic>{};
    final bool isActive = data['is_active'] == true;
    final String verification = (data['verification_status'] ?? '').toString();
    final bool isApproved = verification.toLowerCase() == 'approved';
    if (newValue && (!isActive || !isApproved)) {
      final reason = !isActive ? 'Your provider account is not active.' : 'Your provider verification is not approved.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(reason)),
      );
      return;
    }*/

    setState(() => _isBusy = true);
    final res = await api.toggleMyAvailability(isAvailable: newValue);
    if (res.success) {
      setState(() => _isOnline = newValue);
      ref.read(dashboardProvider.notifier).refresh();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newValue ? 'Status: Online' : 'Status: Offline'),
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.message.isNotEmpty ? res.message : 'Failed to update status')),
      );
    }
    setState(() => _isBusy = false);
  }

  @override
  Widget build(BuildContext context) {
    const Color onlineBorder = Color.fromRGBO(0, 159, 34, 0.5);
    const Color offlineBorder = Color.fromRGBO(227, 12, 0, 0.5);

    final String onlineIconUrl = _isOnline
        ? 'assets/images/material-symbols_online-prediction-rounded.svg'
        : 'assets/images/offine_icon.svg';

    final Color borderColor = _isOnline ? onlineBorder : offlineBorder;

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
          onTap: _isBusy ? null : _toggle,
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
