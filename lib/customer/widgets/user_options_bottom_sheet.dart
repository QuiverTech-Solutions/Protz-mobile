import 'package:flutter/material.dart';

class UserOptionsBottomSheet {
  static void show(
    BuildContext context, {
    required VoidCallback onRateProvider,
    required VoidCallback onMuteNotifications,
    required VoidCallback onReportAccount,
    required VoidCallback onBlockUser,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: Navigator.of(context),
      ),
      builder: (context) => UserOptionsBottomSheetContent(
        onRateProvider: onRateProvider,
        onMuteNotifications: onMuteNotifications,
        onReportAccount: onReportAccount,
        onBlockUser: onBlockUser,
      ),
    );
  }
}

class UserOptionsBottomSheetContent extends StatefulWidget {
  final VoidCallback onRateProvider;
  final VoidCallback onMuteNotifications;
  final VoidCallback onReportAccount;
  final VoidCallback onBlockUser;

  const UserOptionsBottomSheetContent({
    super.key,
    required this.onRateProvider,
    required this.onMuteNotifications,
    required this.onReportAccount,
    required this.onBlockUser,
  });

  @override
  State<UserOptionsBottomSheetContent> createState() =>
      _UserOptionsBottomSheetContentState();
}

class _UserOptionsBottomSheetContentState
    extends State<UserOptionsBottomSheetContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _closeBottomSheet() {
    _animationController.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * 300),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12, bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Options list
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // Rate this service provider
                        _buildOptionItem(
                          icon: Icons.star_outline,
                          iconColor: const Color(0xFF0891B2),
                          title: 'Rate this service provider',
                          titleColor: const Color(0xFF0891B2),
                          onTap: () {
                            _closeBottomSheet();
                            widget.onRateProvider();
                          },
                        ),

                        const SizedBox(height: 24),

                        // Mute notifications
                        _buildOptionItem(
                          icon: Icons.notifications_off_outlined,
                          iconColor: const Color(0xFF6B7280),
                          title: 'Mute notifications',
                          titleColor: const Color(0xFF374151),
                          onTap: () {
                            _closeBottomSheet();
                            widget.onMuteNotifications();
                          },
                        ),

                        const SizedBox(height: 24),

                        // Report this account
                        _buildOptionItem(
                          icon: Icons.report_outlined,
                          iconColor: const Color(0xFFEF4444),
                          title: 'Report this account',
                          titleColor: const Color(0xFFEF4444),
                          onTap: () {
                            _closeBottomSheet();
                            widget.onReportAccount();
                          },
                        ),

                        const SizedBox(height: 24),

                        // Block User
                        _buildOptionItem(
                          icon: Icons.block_outlined,
                          iconColor: const Color(0xFFEF4444),
                          title: 'Block User',
                          titleColor: const Color(0xFFEF4444),
                          onTap: () {
                            _closeBottomSheet();
                            widget.onBlockUser();
                          },
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Color titleColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: titleColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}