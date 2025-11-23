import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../utils/pages.dart';
import '../../customer/core/app_export.dart';
import '../../customer/core/utils/size_utils.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../../service_provider/widgets/sp_bottom_nav_bar.dart';
import '../../service_provider/core/utils/nav_helper.dart';
import '../../service_provider/widgets/provider_status_toggle.dart';
import '../providers/api_service_provider.dart';
import '../services/token_storage.dart';

class AccountSettingsScreen extends ConsumerStatefulWidget {
  final bool isProvider;

  const AccountSettingsScreen({super.key, this.isProvider = false});

  @override
  ConsumerState<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> {
  int _currentNavIndex = 3;
  bool _isOnline = true;
  String _name = 'Account User';
  String _email = 'example@protz.com';
  bool _pushEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final api = ref.read(apiServiceProvider);
    final res = await api.getProfileMe();
    if (!mounted) return;
    if (res.success && res.data != null) {
      final data = res.data!;
      final first = (data['first_name'] ?? '').toString().trim();
      final last = (data['last_name'] ?? '').toString().trim();
      final name = [first, last].where((e) => e.isNotEmpty).join(' ').trim();
      setState(() {
        _name = name.isNotEmpty ? name : (data['email'] ?? _name).toString();
        _email = (data['email'] ?? _email).toString();
        _pushEnabled = data['push_notifications_enabled'] == true ? true : _pushEnabled;
        _isOnline = data['is_available'] == true ? true : _isOnline;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildUserCard(context),
                        SizedBox(height: 16.h),
                        _buildProviderOrCustomerSections(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: widget.isProvider
              ? SPBottomNavBar(
                  currentIndex: 4,
                  items: const [
                    SPBottomNavItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    SPBottomNavItem(
                      icon: Icon(Icons.assignment_outlined),
                      activeIcon: Icon(Icons.assignment),
                      label: 'Requests',
                    ),
                    SPBottomNavItem(
                      icon: Icon(Icons.chat_bubble_outline),
                      activeIcon: Icon(Icons.chat_bubble),
                      label: 'Chats',
                    ),
                    SPBottomNavItem(
                      icon: Icon(Icons.account_balance_wallet_outlined),
                      activeIcon: Icon(Icons.account_balance_wallet),
                      label: 'Finances',
                    ),
                    SPBottomNavItem(
                      icon: Icon(Icons.person_outline),
                      activeIcon: Icon(Icons.person),
                      label: 'Account',
                    ),
                  ],
                  onItemSelected: (index) {
                    ProviderNav.goToIndex(context, index);
                  },
                )
              : CustomBottomNavBar(
                  currentIndex: 3,
                  onTap: (index) {
                    setState(() => _currentNavIndex = index);
                    switch (index) {
                      case 0:
                        context.go(AppRoutes.customerHome);
                        break;
                      case 1:
                        context.push(AppRoutes.history);
                        break;
                      case 2:
                        context.push(AppRoutes.chatInbox);
                        break;
                      case 3:
                        break;
                    }
                  },
                ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.h, 12.h, 16.h, 8.h),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => context.pop(),
          ),
          SizedBox(width: 8.h),
          Text(
            'Account Settings',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF322F35),
            ),
          ),
          const Spacer(),
          
          
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          if (widget.isProvider)
            ProviderStatusToggle(
             
            )
          else
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {},
            ),
        ],
      ),
    );
  }

  Widget _buildUserCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.h,
            backgroundImage: AssetImage(ImageConstant.imgAvatar),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _email,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Color(0xFF808080),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Color(0xFF086788),
            ),
            onPressed: () {
              TokenStorage.instance.clearTokens();
              context.pushReplacementNamed(AppRouteNames.login);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF909090),
        ),
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF909090)),
            SizedBox(width: 12.h),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF909090)),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return const Divider(height: 1, color: Color(0xFFEAEAEA));
  }

  Widget _buildProviderOrCustomerSections(BuildContext context) {
    if (widget.isProvider) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('PROFILE'),
          _buildListItem(
            icon: Icons.person_outline,
            title: 'Provider Profile',
            onTap: () {},
          ),
          _divider(),
          _buildListItem(
            icon: Icons.description_outlined,
            title: 'Documents Verification',
            onTap: () { context.push(AppRoutes.documents); },
          ),
          _divider(),
          _buildListItem(
            icon: Icons.event_available_outlined,
            title: 'Availability',
            onTap: () { context.push(AppRoutes.availability); },
          ),
          SizedBox(height: 24.h),
          _buildSectionTitle('WALLET'),
          _buildListItem(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Protz Wallet Setup',
            onTap: () { context.push(AppRoutes.providerWalletSetup); },
          ),
          SizedBox(height: 24.h),
          _buildSectionTitle('ABOUT'),
          _buildListItem(
            icon: Icons.headset_mic_outlined,
            title: 'Help & Support',
            onTap: () { context.push(AppRoutes.help); },
          ),
          _divider(),
          _buildListItem(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            onTap: () { context.push(AppRoutes.terms); },
          ),
          _divider(),
          _buildListItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () { context.push(AppRoutes.privacy); },
          ),
          SizedBox(height: 24.h),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('ACCOUNT'),
        _buildListItem(
          icon: Icons.person_outline,
          title: 'Your Profile',
          onTap: () { context.push(AppRoutes.customerProfile); },
        ),
        _divider(),
        _buildListItem(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Your Wallets',
          onTap: () { context.push(AppRoutes.wallet); },
        ),
        _divider(),
        _buildListItem(
          icon: Icons.lock_outline,
          title: 'Security & Passwords',
          onTap: () { context.push('/customer/security'); },
        ),
        SizedBox(height: 24.h),
        _buildSectionTitle('ABOUT'),
        _buildListItem(
          icon: Icons.headset_mic_outlined,
          title: 'Help & Support',
          onTap: () { context.push(AppRoutes.help); },
        ),
        _divider(),
        _buildListItem(
          icon: Icons.description_outlined,
          title: 'Terms of Service',
          onTap: () { context.push(AppRoutes.terms); },
        ),
        _divider(),
        _buildListItem(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          onTap: () { context.push(AppRoutes.privacy); },
        ),
        SizedBox(height: 24.h),
        _buildSectionTitle('CONFIGURE'),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              const Icon(Icons.notifications_none, color: Color(0xFF909090)),
              SizedBox(width: 12.h),
              const Expanded(
                child: Text(
                  'Push Notifications',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Switch(
                value: _pushEnabled,
                onChanged: (val) async {
                  setState(() => _pushEnabled = val);
                  final api = ref.read(apiServiceProvider);
                  await api.patchUserMe({'push_notifications_enabled': val});
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        _buildSectionTitle('DANGER ZONE'),
        InkWell(
          onTap: () { context.push(AppRoutes.deleteAccount); },
          child: Container(
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5F5),
              borderRadius: BorderRadius.circular(12.h),
              border: Border.all(color: const Color(0xFFFFE5E5), width: 1),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.h),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE5E5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete_outline, color: Color(0xFFE53E3E), size: 20),
                ),
                SizedBox(width: 12.h),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Delete Account',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE53E3E),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Permanently delete your account and data',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF909090),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFFE53E3E)),
              ],
            ),
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}