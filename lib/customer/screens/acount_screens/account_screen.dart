import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_export.dart';
import '../../../shared/widgets/custom_bottom_nav_bar.dart';
import '../../../shared/utils/pages.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int _currentNavIndex = 2; // Account tab selected

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
                        _buildSectionTitle('ACCOUNT'),
                        _buildListItem(
                          icon: Icons.person_outline,
                          title: 'Your Profile',
                          onTap: () {
                            context.push(AppRoutes.customerProfile);
                          },
                        ),
                        _divider(),
                        _buildListItem(
                          icon: Icons.account_balance_wallet_outlined,
                          title: 'Your Wallets',
                          onTap: () {
                            context.push(AppRoutes.wallet);
                          },
                        ),
                        _divider(),
                        _buildListItem(
                          icon: Icons.lock_outline,
                          title: 'Security & Passwords',
                          onTap: () {
                            context.push('/customer/security');
                          },
                        ),
                        SizedBox(height: 24.h),
                        _buildSectionTitle('ABOUT'),
                        _buildListItem(
                          icon: Icons.headset_mic_outlined,
                          title: 'Help & Support',
                          onTap: () {
                            context.push(AppRoutes.help);
                          },
                        ),
                        _divider(),
                        _buildListItem(
                          icon: Icons.description_outlined,
                          title: 'Terms of Service',
                          onTap: () {
                            context.push(AppRoutes.terms);
                          },
                        ),
                        _divider(),
                        _buildListItem(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          onTap: () {
                            context.push(AppRoutes.privacy);
                          },
                        ),
                        SizedBox(height: 24.h),
                        _buildSectionTitle('CONFIGURE'),
                        _buildToggleItem(
                          icon: Icons.notifications_none,
                          title: 'Push Notifications',
                        ),
                        SizedBox(height: 24.h),
                        _buildSectionTitle('DANGER ZONE'),
                        _buildDangerListItem(
                          icon: Icons.delete_outline,
                          title: 'Delete Account',
                          subtitle: 'Permanently delete your account and data',
                          onTap: () {
                            context.push(AppRoutes.deleteAccount);
                          },
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: 3, // Account tab is at index 3 now
            onTap: (index) {
              setState(() {
                _currentNavIndex = index;
              });
              switch (index) {
                case 0:
                  context.pushReplacementNamed('towing_service_screen');
                  break;
                case 1:
                  // Navigate to orders screen
                  context.push(AppRoutes.history);
                  break;
                case 2:
                  // Navigate to chats screen
                  context.push(AppRoutes.chatInbox);
                  break;
                case 3:
                  // Already on Account
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
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF322F35),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
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
              children: const [
                Text(
                  'John Williams',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'johnwilliams69@gmail.com',
                  style: TextStyle(
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
              // TODO: Logout
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

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
  }) {
    return Padding(
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
          Switch(
            value: true,
            onChanged: (val) {
              // TODO: Persist push notifications toggle
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDangerListItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5F5),
          borderRadius: BorderRadius.circular(12.h),
          border: Border.all(
            color: const Color(0xFFFFE5E5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.h),
              decoration: const BoxDecoration(
                color: Color(0xFFFFE5E5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFFE53E3E),
                size: 20,
              ),
            ),
            SizedBox(width: 12.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE53E3E),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF909090),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFFE53E3E),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return const Divider(height: 1, color: Color(0xFFEAEAEA));
  }
}
