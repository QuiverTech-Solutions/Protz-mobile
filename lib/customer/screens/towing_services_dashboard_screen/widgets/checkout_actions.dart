import 'package:flutter/material.dart';

class CheckoutActions extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onHistory;
  final VoidCallback? onSearch;
  final VoidCallback? onNotifications;

  const CheckoutActions({
    super.key,
    this.onBack,
    this.onHistory,
    this.onSearch,
    this.onNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back), color: const Color(0xFF086788)),
        const Spacer(),
        IconButton(onPressed: onHistory, icon: const Icon(Icons.history), color: const Color(0xFF086788)),
        IconButton(onPressed: onSearch, icon: const Icon(Icons.search), color: const Color(0xFF086788)),
        IconButton(onPressed: onNotifications, icon: const Icon(Icons.notifications_none), color: const Color(0xFF086788)),
      ],
    );
  }
}