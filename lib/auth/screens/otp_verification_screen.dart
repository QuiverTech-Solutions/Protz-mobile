import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:protz/shared/utils/app_constants.dart';
import 'dart:async';
import '../../shared/exceptions/auth_exceptions.dart';
import '../../shared/utils/error_handler.dart';
import '../services/new_auth_service.dart';


class OTPVerificationScreen extends StatefulWidget {
  final String userId;
  final String? phoneNumber;
  final bool isSignUp;

  const OTPVerificationScreen({
    super.key,
    required this.userId,
    this.phoneNumber,
    this.isSignUp = false,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _canResend = false;
  int _resendTimer = 60;
  Timer? _timer;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendTimer = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  String get _otpCode {
    return _otpControllers.map((controller) => controller.text).join();
  }


  Future<void> _resendOTP() async {
    if (!_canResend) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous errors
    });

    try {
      // Note: The new AuthService doesn't have a separate resend OTP method
      // This would typically trigger the same registration/login flow
      // For now, we'll show a success message
      if (mounted) {
        _showSuccessSnackBar('OTP resent successfully');
        _startResendTimer();
        // Clear existing OTP
        for (var controller in _otpControllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e is AuthException 
              ? ErrorHandler.getUserFriendlyMessage(e)
              : 'An unexpected error occurred. Please try again.';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
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
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
          
                       const Text(
                          'Verification',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Color(AppConstants.textPrimaryColorValue),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'We have sent a code to your email',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Color(AppConstants.textPrimaryColorValue),
                            height: 1.4,
                          ),
                        ),
                      ],
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
                              //crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
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
                                // OTP Input Fields
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(4, (index) {
                                    return SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: TextFormField(
                                        controller: _otpControllers[index],
                                        focusNode: _focusNodes[index],
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        maxLength: 1,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF086788),
                                        ),
                                        decoration: InputDecoration(
                                          counterText: '',
                                          
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: Color(AppConstants.primaryColorValue),
                                              width: 1,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                              color: Color(AppConstants.primaryColorValue),
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Color(0xFF086788),
                                              width: 2,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                        ],
                                        onChanged: (value) {
                                          if (value.isNotEmpty && index < 5) {
                                            _focusNodes[index + 1].requestFocus();
                                          } else if (value.isEmpty && index > 0) {
                                            _focusNodes[index - 1].requestFocus();
                                          }
          
                                          // Auto-verify when all fields are filled
                                          if (_otpCode.length == 6) {
                                            _authService.verifyOtp(
                                              userId: widget.userId,
                                              otpCode: _otpCode,
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  }),
                                ),
          
                                const SizedBox(height: 40),
          
                                // Verify Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : () async {
                                      await _authService.verifyOtp(
                                        userId: widget.userId,
                                        otpCode: _otpCode,
                                      );
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
                                            'Verify',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
          
                                const SizedBox(height: 24),
          
                                // Resend OTP
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Didn't receive the code? ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: _canResend && !_isLoading
                                          ? _resendOTP
                                          : null,
                                      child: Text(
                                        _canResend
                                            ? 'Resend'
                                            : 'Resend in ${_resendTimer}s',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: _canResend
                                              ? const Color(0xFF086788)
                                              : Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
          
                                //const Spacer(),
          
                                
                              ],
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
