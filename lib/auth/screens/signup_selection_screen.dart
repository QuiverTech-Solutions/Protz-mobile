import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/utils/pages.dart';

class SignupSelectionScreen extends StatefulWidget {
  const SignupSelectionScreen({super.key});

  @override
  State<SignupSelectionScreen> createState() => _SignupSelectionScreenState();
}

class _SignupSelectionScreenState extends State<SignupSelectionScreen> {
  String? selectedUserType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              
              // Header Section - matching Figma design
              SizedBox(
                width: 345,
                child: Column(
                  children: [
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF086788), // Protz Primary color
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Welcome to Protz! Create an account to get started.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF909090), // Light Grey color
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Select option text - matching Figma design
              const Text(
                'Select an option to proceed.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1E1E1E), // Black color
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Selection Cards
              Expanded(
                child: Column(
                  children: [
                    // Customer Card - matching Figma design
                    _buildSelectionCard(
                      title: 'Sign Up as a Customer',
                      subtitle: 'Sign up as a customer to order tow-truck services or water delivery services.',
                      iconWidget: _buildCustomerIcon(),
                      userType: 'user',
                      isSelected: selectedUserType == 'user',
                      onTap: () {
                        setState(() {
                          selectedUserType = 'user';
                        });
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Service Provider Card - matching Figma design
                    _buildSelectionCard(
                      title: 'Sign Up as a Service Provider',
                      subtitle: 'Sign up as a Tow-Truck or Water delivery service provider to serve customers.',
                      iconWidget: _buildServiceProviderIcon(),
                      userType: 'service_provider',
                      isSelected: selectedUserType == 'service_provider',
                      onTap: () {
                        setState(() {
                          selectedUserType = 'service_provider';
                        });
                      },
                    ),
                    
                    const Spacer(),
                    
                    // Continue Button - matching Figma design
                    Container(
                      width: 345,
                      height: 48,
                      margin: const EdgeInsets.only(bottom: 32),
                      child: ElevatedButton(
                        onPressed: selectedUserType != null ? () {
                          // Navigate to signup screen with selected user type
                          context.push('${AppRoutes.signup}?userType=$selectedUserType');
                        } : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF086788), // Protz Primary
                          disabledBackgroundColor: const Color(0xFF086788).withOpacity(0.5), // 50% opacity when disabled
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color: Color(0xFF086788),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionCard({
    required String title,
    required String subtitle,
    required Widget iconWidget,
    required String userType,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEBFBFE), // Protz Secondary color
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFEBFBFE),
            width: 0.8,
          ),
        ),
        child: Column(
          children: [
            // Top row with icon and checkbox
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                iconWidget,
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Color(0xFF086788),
                        )
                      : null,
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Text Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF086788), // Protz Primary color
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF505050), // Dark Grey color
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerIcon() {
    return SizedBox(
      width: 24,
      height: 24,
      child: const Icon(
        Icons.person,
        size: 24,
        color: Color(0xFF086788),
      ),
    );
  }

  Widget _buildServiceProviderIcon() {
    return SizedBox(
      width: 64,
      height: 24,
      child: Row(
        children: [
          const Icon(
            Icons.local_shipping,
            size: 24,
            color: Color(0xFF086788),
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.water_drop,
            size: 24,
            color: Color(0xFF086788),
          ),
        ],
      ),
    );
  }
}