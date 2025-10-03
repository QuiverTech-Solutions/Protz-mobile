import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_export.dart';
import '../core/utils/size_utils.dart';
import '../../shared/utils/pages.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
                        SizedBox(height: 24.h),
                        _buildContactProtzSection(context),
                        SizedBox(height: 32.h),
                        _buildEmergencyContactSection(context),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
            'Help & Support',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF322F35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactProtzSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Protz Support',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1B5A96),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Have a chat with the customer service.',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: const Color(0xFF605D64),
          ),
        ),
        SizedBox(height: 16.h),
        _buildSupportButton(
          text: 'Contact Customer Service',
          backgroundColor: const Color(0xFF1B5A96),
          textColor: Colors.white,
          onPressed: () {
            _contactCustomerService(context);
          },
        ),
      ],
    );
  }

  Widget _buildEmergencyContactSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emergency Contact',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFE53E3E),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Get in touch with any of the emergency services.',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: const Color(0xFF605D64),
          ),
        ),
        SizedBox(height: 16.h),
        _buildSupportButton(
          text: 'Fire Service',
          backgroundColor: const Color(0xFFFF8C00),
          textColor: Colors.white,
          onPressed: () {
            _callEmergencyService('192'); // Ghana Fire Service
          },
        ),
        SizedBox(height: 12.h),
        _buildSupportButton(
          text: 'Police',
          backgroundColor: const Color(0xFF2D3748),
          textColor: Colors.white,
          onPressed: () {
            _callEmergencyService('191'); // Ghana Police Service
          },
        ),
        SizedBox(height: 12.h),
        _buildSupportButton(
          text: 'Ambulance',
          backgroundColor: const Color(0xFFE53E3E),
          textColor: Colors.white,
          onPressed: () {
            _callEmergencyService('193'); // Ghana Ambulance Service
          },
        ),
      ],
    );
  }

  Widget _buildSupportButton({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.h),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _contactCustomerService(BuildContext context) {
    // Navigate to customer service chat screen
    context.push(AppRoutes.chat);
  }

  Future<void> _callEmergencyService(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        // Handle case where phone dialer cannot be launched
        // Could show a snackbar or dialog to inform user
      }
    } catch (e) {
      // Handle error launching phone dialer
      // Could show error message to user
    }
  }
}