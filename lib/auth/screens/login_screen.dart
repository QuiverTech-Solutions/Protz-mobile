import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/new_auth_service.dart';
import '../widgets/phone_verification_dialog.dart';
import '../../shared/utils/pages.dart';
import '../../shared/models/user.dart';
import '../../shared/exceptions/auth_exceptions.dart';
import '../../shared/utils/error_handler.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isEmailLogin = false;
  bool _isPasswordVisible = false;
  String? _errorMessage;
  UserRole? _loginAsRole;

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      String identifier = _isEmailLogin
          ? _emailController.text.trim()
          : _phoneController.text.trim();
      String password = _passwordController.text.trim();

      // Validate inputs
      String? validationError = _validateInputs(identifier, password);
      if (validationError != null) {
        setState(() {
          _errorMessage = validationError;
          _isLoading = false;
        });
        return;
      }

      if (_isEmailLogin) {
        String username = _emailController.text;
        final user = _loginAsRole == UserRole.serviceProvider
            ? await _authService.loginServiceProvider(
                username: username,
                password: _passwordController.text,
              )
            : await _authService.login(
                username: username,
                password: _passwordController.text,
              );
        developer.log('LoginScreen: Login successful, user ID: ${user.id}');
        if (_loginAsRole != null && user.role != _loginAsRole) {
          setState(() {
            _errorMessage = user.role == UserRole.serviceProvider
                ? 'You are registered as a Service Provider. Please use "Login as Service Provider".'
                : 'You are registered as a Customer. Please use "Login as Customer".';
            _isLoading = false;
          });
          return;
        }
        final otpPhone = _formatPhoneNumber(user.phoneNumber);
        await _authService.sendOtp(phoneNumber: otpPhone);
        if (mounted) {
          _showPhoneVerificationDialog(otpPhone);
        }
      } else {
        final otpPhone = _formatPhoneNumber(_phoneController.text);
        await _authService.sendOtp(phoneNumber: otpPhone);
        if (mounted) {
          _showPhoneVerificationDialog(otpPhone);
        }
      }
    } on AuthException catch (e) {
      developer.log('LoginScreen: AuthException during login: ${e.message}');
      setState(() {
        _errorMessage = ErrorHandler.getUserFriendlyMessage(e);
      });
    } catch (e) {
      developer.log('LoginScreen: Unexpected error during login: $e');

      String errorMessage = 'Login failed. Please try again.';
      if (e.toString().contains('network') || e.toString().contains('connection')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (e.toString().contains('timeout')) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (e.toString().contains('Invalid credentials')) {
        errorMessage = 'Invalid email/phone or password. Please try again.';
      }

      setState(() {
        _errorMessage = errorMessage;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters except '+'
    String cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    // If it already starts with +233, return as is
    if (cleanPhone.startsWith('+233')) {
      return cleanPhone;
    }
    
    // If it starts with 233, add the + prefix
    if (cleanPhone.startsWith('233')) {
      return '+$cleanPhone';
    }
    
    // If it starts with 0, replace with +233
    if (cleanPhone.startsWith('0') && cleanPhone.length >= 10) {
      return '+233${cleanPhone.substring(1)}';
    }
    
    // If it's just 9 digits, assume it's a Ghana number without country code
    if (cleanPhone.length == 9) {
      return '+233$cleanPhone';
    }
    
    // Return as is if none of the above conditions match
    return cleanPhone;
  }

  void _showPhoneVerificationDialog(String phoneNumber) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PhoneVerificationDialog(
          phoneNumber: phoneNumber,
          onVerificationSuccess: () {
            final actualRole = _authService.currentUser?.role ?? UserRole.customer;
            if (_loginAsRole != null && actualRole != _loginAsRole) {
              setState(() {
                _errorMessage = actualRole == UserRole.serviceProvider
                    ? 'You are registered as a Service Provider. Please use "Login as Service Provider".'
                    : 'You are registered as a Customer. Please use "Login as Customer".';
              });
              Navigator.of(context).pop();
              return;
            }
            final chosenRole = actualRole;
            _loginAsRole = null;
            if (chosenRole == UserRole.customer) {
              context.go(AppRoutes.customerHome);
            } else {
              context.go(AppRoutes.providerHome);
            }
          },
          onCancel: () {},
        );
      },
    );
  }

  String? _validateInputs(String identifier, String password) {
    if (identifier.isEmpty) {
      return _isEmailLogin ? 'Email is required' : 'Phone number is required';
    }
    
    if (_isEmailLogin) {
      if (password.isEmpty) {
        return 'Password is required';
      }
      if (password.length < 6) {
        return 'Password must be at least 6 characters';
      }
    }
    
    if (_isEmailLogin) {
      // Email validation - updated to allow + character
      if (!RegExp(r'^[\w-.+]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(identifier)) {
        return 'Please enter a valid email address';
      }
    } else {
      // Phone validation
      String cleanPhone = identifier.replaceAll(RegExp(r'[^\d+]'), '');
      if (cleanPhone.length < 10) {
        return 'Please enter a valid phone number';
      }
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Background Protz logo
            Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height * 0.1,
              child: SizedBox(
                width: 234,
                height: MediaQuery.of(context).size.height * 0.8,
                child: SvgPicture.asset(
                  'assets/images/protz_logo.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            
            // Main content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: 345,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Header section
                      Column(
                        children: [
                          const Text(
                            'Login',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF086788),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Welcome back to WATO. Login to continue.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF909090),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Toggle switch for phone/email login
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBFBFE),
                          borderRadius: BorderRadius.circular(1000),
                          border: Border.all(
                            color: const Color(0xFFEBFBFE),
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Active indicator
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 200),
                              left: !_isEmailLogin ? 0 : 172.5,
                              top: 0,
                              child: Container(
                                width: 172.5,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF086788),
                                  borderRadius: BorderRadius.circular(1000),
                                  border: Border.all(
                                    color: const Color(0xFFEBFBFE),
                                  ),
                                ),
                              ),
                            ),
                            
                            // Toggle buttons
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isEmailLogin = false;
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Login with phone',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: !_isEmailLogin
                                              ? Colors.white
                                              : const Color(0xFF086788).withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isEmailLogin = true;
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Login with email',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: _isEmailLogin
                                              ? Colors.white
                                              : const Color(0xFF086788).withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Form fields
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Email/Phone field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isEmailLogin ? '*Email' : '*Phone Number',
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
                                  controller: _isEmailLogin ? _emailController : _phoneController,
                                  keyboardType: _isEmailLogin 
                                      ? TextInputType.emailAddress 
                                      : TextInputType.phone,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF505050),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: _isEmailLogin 
                                        ? 'email@example.com' 
                                        : '0*********',
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
                          ),
                          
                          const SizedBox(height: 20),
                          if (_isEmailLogin)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '*Password',
                                  style: TextStyle(
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
                                    controller: _passwordController,
                                    obscureText: !_isPasswordVisible,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF505050),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Enter your password',
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
                                        onTap: () {
                                          setState(() {
                                            _isPasswordVisible = !_isPasswordVisible;
                                          });
                                        },
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          margin: const EdgeInsets.all(14),
                                          child: Icon(
                                            _isPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            size: 20,
                                            color: const Color(0xFF505050),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          const SizedBox(height: 10),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Error message
                      if (_errorMessage != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
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
                            ),
                          ),
                        ),
                      
                      // Login buttons
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      _loginAsRole = UserRole.customer;
                                      _handleLogin();
                                    },
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
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Login as Customer',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      _loginAsRole = UserRole.serviceProvider;
                                      _handleLogin();
                                    },
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
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Login as Service Provider',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Social login section
                      Column(
                        children: [
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
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                      //Spacer(),
                      // Sign up link
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Color(0xFF322F35),
                          ),
                          children: [
                            const TextSpan(text: "Don't have an account yet? "),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  context.go(AppRoutes.signupSelection);
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF086688),
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFF086688),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}