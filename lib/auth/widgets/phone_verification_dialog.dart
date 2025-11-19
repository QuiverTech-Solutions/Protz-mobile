import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../shared/exceptions/auth_exceptions.dart';
import '../services/new_auth_service.dart';
import '../../shared/utils/error_handler.dart';

class PhoneVerificationDialog extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback? onVerificationSuccess;
  final VoidCallback? onCancel;

  const PhoneVerificationDialog({
    super.key,
    required this.phoneNumber,
    this.onVerificationSuccess,
    this.onCancel,
  });

  @override
  State<PhoneVerificationDialog> createState() => _PhoneVerificationDialogState();
}

class _PhoneVerificationDialogState extends State<PhoneVerificationDialog> {
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  String? _errorMessage;
  int _resendTimer = 60;
  bool _canResend = false;

  String _formatPhoneNumber(String phoneNumber) {
    final clean = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    if (clean.startsWith('+233')) return clean;
    if (clean.startsWith('233')) return '+$clean';
    if (clean.startsWith('0') && clean.length >= 10) return '+233${clean.substring(1)}';
    if (clean.length == 9) return '+233$clean';
    return clean;
  }

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
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendTimer = 60;
    });
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
        _startResendTimer();
      } else if (mounted) {
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    
    // Clear error message when user starts typing
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  String _getOtpCode() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  Future<void> _handleVerifyOTP() async {
    final otpCode = _getOtpCode();
    
    if (otpCode.length != 6) {
      setState(() {
        _errorMessage = 'Please enter the complete 6-digit code';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Call API to verify OTP
      final phone = _formatPhoneNumber(widget.phoneNumber);
      await _authService.verifyOtp(
        phoneNumber: phone,
        otpCode: otpCode,
      );
      
      // Close dialog and call success callback
      Navigator.of(context).pop();
      widget.onVerificationSuccess?.call();
    } on AuthException catch (e) {
      setState(() {
        _errorMessage = ErrorHandler.getUserFriendlyMessage(e);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Verification failed. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleResendOtp() async {
    if (!_canResend) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final phone = _formatPhoneNumber(widget.phoneNumber);
      await _authService.sendOtp(phoneNumber: phone);
      
      setState(() {
        _errorMessage = null;
        _canResend = false;
        _resendTimer = 60;
      });
      _startResendTimer();
      
      // Clear OTP fields
      for (var controller in _otpControllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
      
      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification code sent successfully!'),
          backgroundColor: Color(0xFF16A34A),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to resend code. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: AnimatedPadding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onCancel?.call();
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFF666666),
                      size: 18,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Logo
              SvgPicture.asset(
                'assets/images/protz_logo.svg',
                height: 32,
              ),
              
              const SizedBox(height: 24),
              
              // Title and subtitle
              const Text(
                'Verify Phone Number',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              const Text(
                'Enter the 6-digit code sent to',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 4),
              
              // Phone number display
              Text(
                widget.phoneNumber,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF007AFF),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Error message
              if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFECACA)),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Color(0xFFDC2626),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              
              // OTP input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return Container(
                    width: 40,
                    height: 48,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _otpControllers[index].text.isNotEmpty 
                            ? const Color(0xFF007AFF) 
                            : const Color(0xFFE5E5E5),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      onChanged: (value) => _onOtpChanged(value, index),
                    ),
                  );
                }),
              ),
              
              const SizedBox(height: 24),
              
              // Resend OTP
              GestureDetector(
                onTap: _canResend ? _handleResendOtp : null,
                child: Text(
                  _canResend 
                      ? 'Resend Code' 
                      : 'Resend in ${_resendTimer}s',
                  style: TextStyle(
                    fontSize: 14,
                    color: _canResend 
                        ? const Color(0xFF007AFF) 
                        : const Color(0xFF999999),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Verify button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleVerifyOTP,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF007AFF),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              disabledBackgroundColor: const Color(0xFFE5E5E5),
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
                                    'Verify Phone Number',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
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
          );
        },
      ),
    );
  }
}