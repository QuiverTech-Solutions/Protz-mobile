import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/auth_text_field.dart';
import '../../shared/utils/pages.dart';
import '../services/new_auth_service.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: 
        SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.5),
                radius: 3.0, // very large radius for maximum blur
                focalRadius: 0.0, // no focal point
                colors: [
                  Color.fromARGB(255, 153, 228, 253), // Very light blue-white
                  Color(0xFFECF6F9), // Slightly lighter
                  Color(0xFFF0F8FA), // Even lighter
                  Color(0xFFF4FAFB), // Almost white with hint of blue
                  Color(0xFFF8FCFD), // Nearly white
                  Color(0xFFFBFDFE), // Almost pure white
                  Color(0xFFFEFFFF), // Pure white
                  Color(0xFFFFFFFF), // Pure white
                ],
                stops: [
                  0.0,
                  0.2,
                  0.35,
                  0.5,
                  0.65,
                  0.8,
                  0.9,
                  1.0
                ], // Gradual transitions
              ),
            ),
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2B2930),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter your email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Color(0xFF605D64),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  //color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(200),
                    topRight: Radius.circular(200),
                  ),
                  border: Border(
                    top: BorderSide(
                      style: BorderStyle.solid,
                      color: const Color(0xFF086688),
                      width: 5,
                    ),
                    left: BorderSide(
                      color: const Color(0xFF086688),
                      width: 5,
                    ),
                    right: BorderSide(
                      color: const Color(0xFF086688),
                      width: 5,
                    ),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 3, left: 3, right: 3),
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(200),
                      topRight: Radius.circular(200),
                    ),
                    border: const Border(
                      top: BorderSide(
                        color: Color(0xFF086688),
                        width: 5,
                      ),
                      left: BorderSide(
                        color: Color(0xFF086688),
                        width: 5,
                      ),
                      right: BorderSide(
                        color: Color(0xFF086688),
                        width: 5,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // Error Message Display
                        if (_errorMessage != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade300),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Success Message Display
                        if (_successMessage != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade300),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle_outline, color: Colors.green.shade700, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _successMessage!,
                                    style: TextStyle(
                                      color: Colors.green.shade700,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Email Field
                        AuthTextField(
                          controller: _emailController,
                          label: 'Email',
                          hintText: 'example@gmail.com',
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 20),
                        // Reset Password Button
                        SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : ()async{ await _authService.forgotPassword(emailOrPhone: _emailController.text.trim());},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF086688),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 100,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
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
                                        'Send Code',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                        const SizedBox(height: 20),
                        
                        // Back to Login Link
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              context.go(AppRoutes.login);
                            },
                            child: const Text(
                              'Back to Login',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Color(0xFF086688),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    )));
  }
}
