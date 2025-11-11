import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:protz/auth/models/register_request.dart';
import '../widgets/phone_verification_dialog.dart';
import '../services/new_auth_service.dart';
import '../../shared/exceptions/auth_exceptions.dart';
import '../../shared/models/user.dart';
import '../../shared/utils/error_handler.dart';
import '../../shared/utils/pages.dart';

class SignUpScreen extends StatefulWidget {
  final String userType;
  
  const SignUpScreen({
    super.key,
    this.userType = 'user',
  });

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        size: 24,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Header
                    const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF086788),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.userType == 'service_provider' 
                          ? 'Sign up as a Service Provider'
                          : 'Sign up as a Customer',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF909090),
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Error message
                    if (_errorMessage != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border.all(color: Colors.red.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    
                    // Form fields
                    Column(
                      children: [
                        // Full Name field
                        _buildTextField(
                          controller: _nameController,
                          label: widget.userType == 'service_provider' 
                              ? '*Full Name/Company Name'
                              : '*Full Name',
                          hintText: widget.userType == 'service_provider'
                              ? 'Enter your full name or the name of your company'
                              : 'Enter your full name',
                        ),
                        const SizedBox(height: 20),
                        
                        // Phone Number field
                        _buildTextField(
                          controller: _phoneController,
                          label: '*Phone Number',
                          hintText: '0*********',
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 20),
                        
                        // Email field
                        _buildTextField(
                          controller: _emailController,
                          label: '*Email',
                          hintText: 'email@example.com',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        
                        // Create Password field
                        _buildPasswordField(
                          controller: _passwordController,
                          label: '*Create a password',
                          hintText: 'Enter your password',
                          isVisible: _passwordVisible,
                          onToggleVisibility: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        
                        // Confirm Password field
                        _buildPasswordField(
                          controller: _confirmPasswordController,
                          label: '*Confirm password',
                          hintText: 'Repeat your password',
                          isVisible: _confirmPasswordVisible,
                          onToggleVisibility: () {
                            setState(() {
                              _confirmPasswordVisible = !_confirmPasswordVisible;
                            });
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Sign Up button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSignUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF086788),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Continue with text
                    const Text(
                      'Continue with:',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Social login buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google login button
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF585274).withOpacity(0.28),
                              width: 0.8,
                            ),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/google_logo.svg',
                              width: 24,
                              height: 24,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 20),
                        
                        // Apple login button
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF585274).withOpacity(0.13),
                              width: 0.8,
                            ),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/images/apple_logo.svg',
                              width: 24,
                              height: 25,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Login link
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Color(0xFF322F35),
                        ),
                        children: [
                          const TextSpan(text: 'Already have an account? '),
                          TextSpan(
                            text: 'Login',
                            style: const TextStyle(
                              color: Color(0xFF086688),
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFF086688),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.go(AppRoutes.login);
                              },
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF1E1E1E),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF909090).withOpacity(0.5),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF505050),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF505050),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF1E1E1E),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF909090).withOpacity(0.5),
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: !isVisible,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF505050),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF505050),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              suffixIcon: GestureDetector(
                onTap: onToggleVisibility,
                child: Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.all(14),
                  child: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    size: 20,
                    color: const Color(0xFF505050),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSignUp() async {
    developer.log('SignUpScreen: Starting registration process');
    
    // Clear previous error
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    developer.log('SignUpScreen: Validating form fields');

    // Basic validation
    if (_nameController.text.trim().isEmpty) {
      developer.log('SignUpScreen: Validation failed - Name is empty');
      setState(() {
        _errorMessage = 'Please enter your full name';
        _isLoading = false;
      });
      return;
    }

    if (_phoneController.text.trim().isEmpty) {
      developer.log('SignUpScreen: Validation failed - Phone is empty');
      setState(() {
        _errorMessage = 'Please enter your phone number';
        _isLoading = false;
      });
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      developer.log('SignUpScreen: Validation failed - Email is empty');
      setState(() {
        _errorMessage = 'Please enter your email';
        _isLoading = false;
      });
      return;
    }

    if (_passwordController.text.isEmpty) {
      developer.log('SignUpScreen: Validation failed - Password is empty');
      setState(() {
        _errorMessage = 'Please enter a password';
        _isLoading = false;
      });
      return;
    }

    if (_confirmPasswordController.text.isEmpty) {
      developer.log('SignUpScreen: Validation failed - Confirm password is empty');
      setState(() {
        _errorMessage = 'Please confirm your password';
        _isLoading = false;
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      developer.log('SignUpScreen: Validation failed - Passwords do not match');
      setState(() {
        _errorMessage = 'Passwords do not match';
        _isLoading = false;
      });
      return;
    }

    developer.log('SignUpScreen: All validations passed, proceeding with registration');

    try {
      // Split name into first and last name
      final nameParts = _nameController.text.trim().split(' ');
      final firstName = nameParts.first;
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      developer.log('SignUpScreen: Creating RegisterRequest with firstName: $firstName, lastName: $lastName, userType: ${widget.userType}');

      final registerRequest = RegisterRequest(
        firstName: firstName,
        lastName: lastName,
        userType: widget.userType,
        phoneNumber: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        gender: 'male', // Default value, could be made configurable
        profilePhotoUrl: 'https://example.com/default-avatar.png', // Default value
      );

      developer.log('SignUpScreen: RegisterRequest created: ${registerRequest.toJson()}');
      developer.log('SignUpScreen: Calling AuthService.register()');

      final user = await _authService.register(registerRequest);

      developer.log('SignUpScreen: Registration successful, user ID: ${user.id}');

      // Registration successful, show phone verification dialog
      if (mounted) {
        developer.log('SignUpScreen: Showing phone verification dialog');
        _showPhoneVerificationDialog(user.id, user.phoneNumber);
      }
    } on AuthException catch (e) {
      developer.log('SignUpScreen: AuthException during registration: ${e.message}');
      developer.log('SignUpScreen: AuthException type: ${e.runtimeType}');
      setState(() {
        _errorMessage = ErrorHandler.getUserFriendlyMessage(e);
      });
    } catch (e, stackTrace) {
      developer.log('SignUpScreen: Unexpected error during registration: $e');
      developer.log('SignUpScreen: Error type: ${e.runtimeType}');
      developer.log('SignUpScreen: Stack trace: $stackTrace');

      String errorMessage = 'Registration failed. Please try again.';
      if (e.toString().contains('network') || e.toString().contains('connection')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (e.toString().contains('timeout')) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (e.toString().contains('already exists')) {
        errorMessage = 'An account with this email or phone already exists.';
      }

      setState(() {
        _errorMessage = errorMessage;
      });
    } finally {
      developer.log('SignUpScreen: Registration process completed, setting loading to false');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showPhoneVerificationDialog(String userId, String phoneNumber) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PhoneVerificationDialog(
          phoneNumber: phoneNumber,
          userId: userId,
          onVerificationSuccess: () {
            // Navigate to appropriate dashboard based on user type
            final userRole = _authService.currentUser?.role ?? UserRole.customer;
            if (userRole == UserRole.customer) {
              context.go(AppRoutes.customerHome);
            } else {
              context.go(AppRoutes.providerHome);
            }
          },
          onCancel: () {
            // User cancelled verification, stay on signup screen
            developer.log('SignUpScreen: Phone verification cancelled');
          },
        );
      },
    );
  }
}
