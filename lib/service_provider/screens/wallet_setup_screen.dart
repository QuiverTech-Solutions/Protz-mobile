import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_export.dart';
import '../widgets/sp_primary_button.dart';

class ProtzWalletSetupScreen extends StatefulWidget {
  const ProtzWalletSetupScreen({super.key});

  @override
  State<ProtzWalletSetupScreen> createState() => _ProtzWalletSetupScreenState();
}

class _ProtzWalletSetupScreenState extends State<ProtzWalletSetupScreen> {
  final _pinControllers = List.generate(4, (_) => TextEditingController());
  final _focusNodes = List.generate(4, (_) => FocusNode());
  bool _isConfirmStep = false;
  String? _firstPin;

  @override
  void dispose() {
    for (final c in _pinControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  // Backspace handling moved to onChanged to avoid FocusNode conflicts

  String _pin() => _pinControllers.map((c) => c.text).join();

  void _clearPin() {
    for (final c in _pinControllers) {
      c.clear();
    }
  }

  void _onContinue(BuildContext context) {
    final pin = _pin();
    if (pin.length != 4 || pin.contains(RegExp(r'\D'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid 4-digit PIN')),
      );
      return;
    }
    if (!_isConfirmStep) {
      _firstPin = pin;
      setState(() {
        _isConfirmStep = true;
      });
      _clearPin();
      _focusNodes.first.requestFocus();
    } else {
      if (pin != _firstPin) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PINs do not match. Please try again.')),
        );
        _clearPin();
        _focusNodes.first.requestFocus();
        return;
      }
      // TODO: Hook to actual route (e.g., provider home) when available
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: appTheme.white_A700,
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.h),
                child: SizedBox(
                  width: 345.h,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BackButton(
                              color: appTheme.light_blue_900,
                              onPressed: () {
                                if (_isConfirmStep) {
                                  setState(() {
                                    _isConfirmStep = false;
                                  });
                                  _clearPin();
                                  _focusNodes.first.requestFocus();
                                } else {
                                  Navigator.of(context).maybePop();
                                }
                              },
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Protz Wallet',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24.fSize,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                    color: appTheme.light_blue_900,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Set up your Protz Wallet',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.fSize,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins',
                                    color: appTheme.blue_gray_400,
                                  ),
                                ),
                              ],
                            ),
                            Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Step 3/3',
                            style:
                                SPTextStyleHelper.instance.body12RegularPoppins,
                          ),
                        ),
                          ],
                          
                        ),
                       

                        SizedBox(height: 24.h),

                        // Info Card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20.h),
                          decoration: BoxDecoration(
                            color: appTheme.light_blue_50,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: appTheme.light_blue_900.withOpacity(0.1),
                              width: 4,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.account_balance_wallet,
                                      size: 16.h,
                                      color: appTheme.light_blue_900),
                                  SizedBox(width: 6.h),
                                  Text(
                                    'Protz Wallet',
                                    style: TextStyle(
                                      fontSize: 10.fSize,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins',
                                      color: appTheme.light_blue_900,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Your ',
                                      style: TextStyle(
                                        fontSize: 14.fSize,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins',
                                        color: appTheme.gray_900,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Protz Wallet ',
                                      style: TextStyle(
                                        fontSize: 14.fSize,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                        color: appTheme.gray_900,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          'is an in-app wallet through which you will receive payments from successful deliveries.',
                                      style: TextStyle(
                                        fontSize: 14.fSize,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins',
                                        color: appTheme.gray_900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 40.h),

                        // Title & Caption
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _isConfirmStep
                                    ? 'Confirm your Pin'
                                    : 'Create a Pin for your Protzy Wallet',
                                style: TextStyle(
                                  color: const Color(0xFF1E1E1E),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                _isConfirmStep
                                    ? 'Re-enter your 4-digit PIN to confirm'
                                    : '(This pin will be required to access your wallet always)',
                                style: SPTextStyleHelper
                                    .instance.body12RegularPoppins,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // PIN boxes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                                  4,
                                  (i) => _PinBox(
                                        controller: _pinControllers[i],
                                        focusNode: _focusNodes[i],
                                        onChanged: (v) => _onChanged(i, v),
                                      ))
                              .expand((w) => [w, SizedBox(width: 24.h)])
                              .toList()
                            ..removeLast(),
                        ),

                        SizedBox(height: 40.h),

                        // Continue button
                        SPPrimaryButton(
                          title: _isConfirmStep ? 'Confirm' : 'Continue',
                          onPressed: () => _onContinue(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PinBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _PinBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isFocused = focusNode.hasFocus;
    return SizedBox(
      width: 48.h,
      height: 48.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: appTheme.white_A700,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isFocused ? appTheme.light_blue_900 : appTheme.blue_gray_400,
          ),
        ),
        child: Center(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(
              fontSize: 28.fSize,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              color: appTheme.light_blue_900,
            ),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
