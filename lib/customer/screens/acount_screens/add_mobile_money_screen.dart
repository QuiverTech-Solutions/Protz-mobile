import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/widgets/auth_text_field.dart';
import '../../../shared/screens/widgets/account_verification_popup.dart';

class AddMobileMoneyScreen extends StatefulWidget {
  const AddMobileMoneyScreen({super.key});

  @override
  State<AddMobileMoneyScreen> createState() => _AddMobileMoneyScreenState();
}

class _AddMobileMoneyScreenState extends State<AddMobileMoneyScreen> {
  final TextEditingController _accountNumberController = TextEditingController();
  String? _selectedProvider;

  final List<String> _mobileMoneyProviders = [
    'MTN Mobile Money',
    'Vodafone Cash',
    'AirtelTigo Money',
  ];

  @override
  void dispose() {
    _accountNumberController.dispose();
    super.dispose();
  }

  String? _validateAccountNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your account number';
    }
    if (value.length < 10) {
      return 'Account number must be at least 10 digits';
    }
    return null;
  }

  void _handleVerify() {
    if (_selectedProvider == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a mobile money service provider'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_accountNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your account number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show verification popup
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AccountVerificationPopup(
          phoneNumber: _accountNumberController.text,
          onVerificationSuccess: () {
            // Handle successful verification
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Mobile money account verified successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            
            // Navigate back to wallet screen
            context.pop();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Add a Mobile Money Account',
          style: TextStyle(
            color: Color(0xFF1B5A96),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              const Text(
                'Link a mobile money account',
                style: TextStyle(
                  color: Color(0xFF1B5A96),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),

              // Provider dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Name of provider',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD1D5DB)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedProvider,
                        isExpanded: true,
                        hint: const Text(
                          'Select mobile money service provider',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF6B7280),
                        ),
                        items: _mobileMoneyProviders.map((String provider) {
                          return DropdownMenuItem<String>(
                            value: provider,
                            child: Text(
                              provider,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF111827),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedProvider = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Account number field
              AuthTextField(
                controller: _accountNumberController,
                label: 'Account Number',
                hintText: 'Enter account number',
                validator: _validateAccountNumber,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 8),
              const Text(
                'The account number is the same as the phone number used to register for mobile money services.',
                style: TextStyle(
                  color: Color(0xFF1B5A96),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 48),

              // Verify button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleVerify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5A96),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Verify',
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
    );
  }
}