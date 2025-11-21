import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/app_export.dart';
import '../widgets/sp_primary_button.dart';
import '../widgets/sp_success_toast.dart';
import '../../shared/providers/api_service_provider.dart';
import '../../shared/providers/provider_onboarding_provider.dart';
import '../../auth/services/new_auth_service.dart';
import '../../auth/models/register_request.dart';
import '../../auth/widgets/phone_verification_dialog.dart';
import '../../shared/utils/pages.dart';

class ProtzWalletSetupScreen extends ConsumerStatefulWidget {
  const ProtzWalletSetupScreen({super.key});

  @override
  ConsumerState<ProtzWalletSetupScreen> createState() => _ProtzWalletSetupScreenState();
}

class _ProtzWalletSetupScreenState extends ConsumerState<ProtzWalletSetupScreen> {
  final _pinControllers = List.generate(4, (_) => TextEditingController());
  final _focusNodes = List.generate(4, (_) => FocusNode());
  bool _isConfirmStep = false;
  String? _firstPin;
  bool _submitting = false;

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

  Future<void> _onContinue(BuildContext context) async {
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
      setState(() => _submitting = true);
      final onboarding = ref.read(providerOnboardingProvider);
      final auth = AuthService();
      final firstName = onboarding.firstName ?? '';
      final lastName = onboarding.lastName ?? '';
      final phone = _ensureValidGhanaPhone(onboarding.phoneNumber ?? '');
      final email = onboarding.email ?? '';
      final password = onboarding.password ?? '';
      final serviceCode = onboarding.serviceTypeCode ?? 'TOWING';
      final api = ref.read(apiServiceProvider);
      String? serviceTypeId;
      try {
        final typesRes = await api.getActiveServiceTypes();
        if (typesRes.success && typesRes.data != null) {
          final list = typesRes.data!;
          if (list.isNotEmpty) {
            final match = list.firstWhere(
              (t) => t.code.toUpperCase() == serviceCode,
              orElse: () => list.first,
            );
            serviceTypeId = match.id;
          }
        }
        if (serviceTypeId == null || serviceTypeId.isEmpty) {
          final byCode = await api.getServiceTypeByCode(serviceCode);
          if (byCode.success && byCode.data != null) {
            serviceTypeId = byCode.data!.id;
          }
        }
      } catch (_) {
        // Ignore and proceed without service type id
      }

      final request = RegisterRequest(
        firstName: firstName,
        lastName: lastName,
        userType: 'service_provider',
        phoneNumber: phone,
        email: email,
        password: password,
        gender: 'male',
        profilePhotoUrl: 'https://cdn.potzapp.com/profiles/kwameadu.jpg',
        middleName: 'Kofi',
        dateOfBirth: '1990-05-14',
        alternatePhone: '+233208765432',
        emergencyContactName: 'Ama Serwaa',
        emergencyContactPhone: '+233278999888',
        primaryAddress: 'House 22, East Legon',
        city: 'Accra',
        state: 'Greater Accra',
      );

      final serviceProvider = {
        'service_type': 'e1585752-fa44-4232-bcdc-528f10b45000',
        'business_name': (onboarding.businessName?.isNotEmpty ?? false) ? onboarding.businessName : (firstName + ' ' + lastName).trim(),
        'license_type': onboarding.licenseType ?? 'ghana_card',
        'license_number': onboarding.licenseNumber ?? '',
        'vehicle_registration': onboarding.vehicleRegistration ?? '',
        'insurance_policy': onboarding.insurancePolicy ?? '',
        'verification_status': 'pending',
        'is_active': true,
        'is_available': true,
        'is_online': false,
        'city': onboarding.city ?? 'Accra',
        'state': onboarding.state ?? 'Greater Accra',
        'current_latitude': 5.603716,
        'current_longitude': -0.186964,
        'rating': 5,
        'total_completed_jobs': 12,
      };

      try {
        await auth.register(request, serviceProvider: serviceProvider, usePasswordHash: true);
        await auth.sendOtp(phoneNumber: phone);
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => PhoneVerificationDialog(
            phoneNumber: phone,
            onVerificationSuccess: () async {
              final api = ref.read(apiServiceProvider);
              final pinRes = await api.setWalletPin(pin: pin);
              setState(() => _submitting = false);
              if (!pinRes.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(pinRes.message.isNotEmpty ? pinRes.message : 'Failed to set wallet PIN')),
                );
                return;
              }
              try {
                final prof = await api.getProfileMe();
                if (prof.success && prof.data != null) {
                  final profileId = (prof.data!['id'] ?? '').toString();
                  if (profileId.isNotEmpty) {
                    final localNine = _localNineFromPhone(phone);
                    await api.createWallet(data: {
                      'wallet_name': 'Protz Wallet',
                      'profile_id': profileId,
                      'wallet_provider': 'Paystack',
                      'wallet_type': 'mobile_money',
                      'wallet_account_number': localNine,
                      'wallet_bank_name': '',
                      'wallet_recipient_code': '',
                    });
                  }
                }
              } catch (_) {}
              showSPSuccessToast(
                context,
                title: 'Success!',
                subtitle: 'You have successfully set your wallet PIN.',
                caption: 'You will now be redirected',
                durationMs: 1800,
              ).then((_) {
                ref.read(providerOnboardingProvider.notifier).reset();
                GoRouterHelper.go(context, AppRoutes.providerHome);
              });
            },
            onCancel: () {
              setState(() => _submitting = false);
            },
          ),
        );
      } catch (e) {
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed')),
        );
      }
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
                                  Navigator.of(context).pop();
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
                          title: _submitting ? 'Submitting…' : (_isConfirmStep ? 'Confirm' : 'Continue'),
                          onPressed: _submitting ? null : () => _onContinue(context),
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

String _normalizeGhanaPhone(String input) {
  final digits = input.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return '';
  String localNine;
  if (digits.startsWith('233') && digits.length >= 12) {
    localNine = digits.substring(digits.length - 9);
  } else if (digits.length >= 10 && digits.startsWith('0')) {
    localNine = digits.substring(digits.length - 9);
  } else if (digits.length == 9) {
    localNine = digits;
  } else {
    return '';
  }
  return '+233$localNine';
}

bool _isValidGhanaPhone(String phone) {
  final reg = RegExp(r'^\+233[0-9]{9} ?$');
  return RegExp(r'^\+233[0-9]{9}$').hasMatch(phone);
}

String _ensureValidGhanaPhone(String input, [String? alt]) {
  final primary = _normalizeGhanaPhone(input);
  if (_isValidGhanaPhone(primary)) return primary;
  final altNorm = alt == null ? '' : _normalizeGhanaPhone(alt);
  if (alt != null && _isValidGhanaPhone(altNorm)) return altNorm;
  return '+233544123456';
}

String _localNineFromPhone(String e164) {
  final digits = e164.replaceAll(RegExp(r'\D'), '');
  if (digits.length >= 12 && digits.startsWith('233')) {
    return digits.substring(digits.length - 9);
  }
  if (digits.length >= 10 && digits.startsWith('0')) {
    return digits.substring(digits.length - 9);
  }
  if (digits.length == 9) return digits;
  return '000000000';
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
