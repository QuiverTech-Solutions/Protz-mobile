import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/new_auth_service.dart';
import '../widgets/auth_text_field.dart';
import '../../shared/utils/pages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isSignUp = false;
  bool _isLoading = false;
  bool _rememberMe = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F4F8), // Light blue background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.5),
                radius: 3.0, // very large radius for maximum blur
                focalRadius: 0.0, // no focal point
                colors: [
                  Color.fromARGB(150, 8, 104, 136), // Very light blue-white
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
                // Header section with title
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2B2930),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Welcome! Enter your credentials\nto login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Color(0xFF2B2930),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Form container with curved top
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

                            // Error message display
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
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                  ),
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

                            // Password Field
                            AuthTextField(
                              controller: _passwordController,
                              label: 'Password',
                              hintText: '••••••••••',
                              obscureText: true,
                              validator: _validatePassword,
                            ),
                            const SizedBox(height: 16),

                            // Remember Me and Forgot Password Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Remember Me Checkbox
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: Checkbox(
                                        value: _rememberMe,
                                        onChanged: (value) {
                                          setState(() {
                                            _rememberMe = value ?? false;
                                          });
                                        },
                                        activeColor: const Color(0xFF086688),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Remember me',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: Color(0xFF48464C),
                                      ),
                                    ),
                                  ],
                                ),

                                // Forgot Password Link
                                GestureDetector(
                                  onTap: () {
                                    context.push(AppRoutes.forgotPassword);
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      color: Color(0xFF086688),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),

                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () async {
                                        await _authService.login(
                                          username: _emailController.text.trim(),
                                          password: _passwordController.text.trim(),
                                        );
                                        if (mounted) {
                                          context.go('/towing_service_screen');
                                        }
                                      },
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
                                        'Login',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Sign Up Link
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    color: Color(0xFF322F35),
                                  ),
                                  children: [
                                    const TextSpan(
                                        text: "Don't have an account? "),
                                    WidgetSpan(
                                      child: GestureDetector(
                                        onTap: () {
                                          // Navigate to sign up screen
                                          context.go(AppRoutes.signup);
                                          setState(() {
                                            _isSignUp = true;
                                          });
                                        },
                                        child: const Text(
                                          'Sign Up',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF086688),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
        ),
      ),
    );
  }

 

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
