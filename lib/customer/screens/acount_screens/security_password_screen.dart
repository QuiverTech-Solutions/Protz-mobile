import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/utils/pages.dart';
import '../../core/app_export.dart';
import '../../../auth/widgets/auth_text_field.dart';
import '../../widgets/custom_button.dart';

enum TwoFactorMethod { email, phone }

class SecurityPasswordScreen extends StatefulWidget {
  const SecurityPasswordScreen({super.key});

  @override
  State<SecurityPasswordScreen> createState() => _SecurityPasswordScreenState();
}

class _SecurityPasswordScreenState extends State<SecurityPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  final String _maskedEmail = 'j*****e@gmail.com';
  final String _maskedPhone = '02** *** *19';

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) return 'Password is required';
    if (password.length < 8) return 'Use 8+ characters for strong security';
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasLower = password.contains(RegExp(r'[a-z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    if (!(hasUpper && hasLower && hasDigit)) {
      return 'Include upper, lower case letters and a number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? confirm) {
    if (confirm == null || confirm.isEmpty) return 'Please confirm your password';
    if (confirm != _newPasswordController.text) return 'Passwords do not match';
    if (_currentPasswordController.text.isNotEmpty &&
        _currentPasswordController.text == _newPasswordController.text) {
      return 'New password must differ from current password';
    }
    return null;
  }

  void _showTwoFAMethodSheet() {
    TwoFactorMethod selected = TwoFactorMethod.email;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      '2-Factor Authentication',
                      style: TextStyleHelper.instance.title18MediumPoppins.copyWith(
                        color: appTheme.light_blue_900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Select an option for 2FA.',
                      style: TextStyleHelper.instance.body12RegularPoppins?.copyWith(
                        color: appTheme.gray_900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _TwoFAOptionTile(
                label: 'Via Email address',
                detail: _maskedEmail,
                icon: Icons.email_outlined,
                selected: selected == TwoFactorMethod.email,
                onTap: () {
                  setState(() => selected = TwoFactorMethod.email);
                },
              ),
              const SizedBox(height: 12),
              _TwoFAOptionTile(
                label: 'Via Phone Number',
                detail: _maskedPhone,
                icon: Icons.phone_in_talk_outlined,
                selected: selected == TwoFactorMethod.phone,
                onTap: () {
                  setState(() => selected = TwoFactorMethod.phone);
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Continue',
                onPressed: () {
                  Navigator.of(context).pop();
                  _showOTPVerificationSheet(selected);
                },
                backgroundColor: const Color(0xFF086688),
                textColor: Colors.white,
                height: 50,
                isFullWidth: true,
                borderRadius: 12,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOTPVerificationSheet(TwoFactorMethod method) {
    final List<TextEditingController> otpControllers =
        List.generate(6, (_) => TextEditingController());
    final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
    int resendTimer = 60;
    bool canResend = false;
    Timer? timer;

    void startTimer() {
      canResend = false;
      resendTimer = 60;
      timer?.cancel();
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted) return;
        setState(() {
          if (resendTimer > 0) {
            resendTimer--;
          } else {
            canResend = true;
            t.cancel();
          }
        });
      });
    }

    String code() => otpControllers.map((c) => c.text).join();

    void disposeLocals() {
      for (final c in otpControllers) c.dispose();
      for (final n in focusNodes) n.dispose();
      timer?.cancel();
    }

    startTimer();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '2-Factor Authentication',
                    style: TextStyleHelper.instance.title18MediumPoppins.copyWith(
                      color: appTheme.light_blue_900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    method == TwoFactorMethod.email
                        ? 'Verify your email address to proceed.'
                        : 'Verify your phone number to proceed.',
                    style: TextStyleHelper.instance.body12RegularPoppins?.copyWith(
                      color: appTheme.gray_900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return _OtpBox(
                        controller: otpControllers[index],
                        focusNode: focusNodes[index],
                        onChanged: (val) {
                          if (val.length == 1) {
                            if (index < 5) {
                              focusNodes[index + 1].requestFocus();
                            } else {
                              focusNodes[index].unfocus();
                            }
                          }
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    canResend
                        ? 'You can request a new code'
                        : 'Request code resend in ${resendTimer}s',
                    style: TextStyleHelper.instance.label10RegularPoppins?.copyWith(
                      color: appTheme.light_blue_900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Enable 2FA',
                    onPressed: () {
                      if (code().length == 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('2FA enabled successfully'),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    backgroundColor: const Color(0xFF086688),
                    textColor: Colors.white,
                    height: 50,
                    isFullWidth: true,
                    borderRadius: 12,
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(disposeLocals);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
        title: const Text('Security & Passwords'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '2-Factor Authentication',
                style: TextStyleHelper.instance.title18MediumPoppins.copyWith(
                  color: appTheme.light_blue_900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Turn on 2FA to give your account an extra layer of protection.',
                style: TextStyleHelper.instance.body12RegularPoppins?.copyWith(
                  color: appTheme.gray_900,
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Enable 2FA',
                onPressed: _showTwoFAMethodSheet,
                backgroundColor: const Color(0xFF086688),
                textColor: Colors.white,
                height: 50,
                isFullWidth: true,
                borderRadius: 12,
              ),
              const SizedBox(height: 16),
              Divider(color: appTheme.light_blue_50),
              const SizedBox(height: 12),

              Text(
                'Update your password',
                style: TextStyleHelper.instance.title18MediumPoppins.copyWith(
                  color: appTheme.light_blue_900,
                ),
              ),
              const SizedBox(height: 12),
              Text('Current password', style: TextStyleHelper.instance.body12RegularPoppins.copyWith(
                fontWeight: FontWeight.w500,
                color: appTheme.gray_900,
              )),
              const SizedBox(height: 8),
              AuthTextField(
                controller: _currentPasswordController,
                label: '',
                hintText: 'Enter current password',
                obscureText: !_showCurrent,
                validator: _validatePassword,
                inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                suffixIcon: IconButton(
                  icon: Icon(_showCurrent ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _showCurrent = !_showCurrent),
                ),
              ),
              const SizedBox(height: 16),
              Text('New password', style: TextStyleHelper.instance.body12RegularPoppins.copyWith(
                fontWeight: FontWeight.w500,
                color: appTheme.gray_900,
              )),
              const SizedBox(height: 8),
              AuthTextField(
                controller: _newPasswordController,
                label: '',
                hintText: 'Enter new password',
                obscureText: !_showNew,
                validator: _validatePassword,
                inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                suffixIcon: IconButton(
                  icon: Icon(_showNew ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _showNew = !_showNew),
                ),
              ),
              const SizedBox(height: 16),
              Text('Confirm password', style: TextStyleHelper.instance.body12RegularPoppins.copyWith(
                fontWeight: FontWeight.w500,
                color: appTheme.gray_900,
              )),
              const SizedBox(height: 8),
              AuthTextField(
                controller: _confirmPasswordController,
                label: '',
                hintText: 'Re-enter new password',
                obscureText: !_showConfirm,
                validator: _validateConfirmPassword,
                inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                suffixIcon: IconButton(
                  icon: Icon(_showConfirm ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _showConfirm = !_showConfirm),
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Save Changes',
                onPressed: () {
                  final isValid = (_validatePassword(_currentPasswordController.text) == null) &&
                      (_validatePassword(_newPasswordController.text) == null) &&
                      (_validateConfirmPassword(_confirmPasswordController.text) == null);
                  if (!isValid) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fix the errors before saving'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password updated securely'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  _currentPasswordController.clear();
                  _newPasswordController.clear();
                  _confirmPasswordController.clear();
                },
                backgroundColor: const Color(0xFF086688),
                textColor: Colors.white,
                height: 50,
                isFullWidth: true,
                borderRadius: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TwoFAOptionTile extends StatelessWidget {
  final String label;
  final String detail;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _TwoFAOptionTile({
    required this.label,
    required this.detail,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: appTheme.light_blue_50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: appTheme.light_blue_900),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyleHelper.instance.body12RegularPoppins.copyWith(
                    fontWeight: FontWeight.w500,
                    color: appTheme.gray_900,
                  )),
                  const SizedBox(height: 4),
                  Text(
                    detail,
                    style: TextStyleHelper.instance.body12RegularPoppins?.copyWith(
                      color: appTheme.light_blue_900,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: appTheme.light_blue_900,
            )
          ],
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onChanged;
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: appTheme.light_blue_50),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: appTheme.light_blue_900),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}