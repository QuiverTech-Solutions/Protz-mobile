import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/widgets/auth_text_field.dart';


class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardHolderController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _ccvController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _cardHolderController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _ccvController.dispose();
    super.dispose();
  }

  String? _validateCardHolder(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card holder name is required';
    }
    if (value.length < 2) {
      return 'Card holder name must be at least 2 characters';
    }
    return null;
  }

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card number is required';
    }
    
    // Remove spaces for validation
    String cleanValue = value.replaceAll(' ', '');
    
    if (cleanValue.length != 16) {
      return 'Card number must be 16 digits';
    }
    
    // Basic Luhn algorithm check
    if (!_isValidCardNumber(cleanValue)) {
      return 'Invalid card number';
    }
    
    return null;
  }

  String? _validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }
    
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
      return 'Enter date in MM/YY format';
    }
    
    List<String> parts = value.split('/');
    int month = int.parse(parts[0]);
    int year = int.parse('20${parts[1]}');
    
    if (month < 1 || month > 12) {
      return 'Invalid month';
    }
    
    DateTime now = DateTime.now();
    DateTime expiryDate = DateTime(year, month);
    
    if (expiryDate.isBefore(DateTime(now.year, now.month))) {
      return 'Card has expired';
    }
    
    return null;
  }

  String? _validateCCV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CCV is required';
    }
    if (value.length != 3) {
      return 'CCV must be 3 digits';
    }
    return null;
  }

  bool _isValidCardNumber(String cardNumber) {
    int sum = 0;
    bool alternate = false;
    
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);
      
      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }
      
      sum += digit;
      alternate = !alternate;
    }
    
    return sum % 10 == 0;
  }

  Future<void> _addCard() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Card added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate back to wallet screen
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add card: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
          'Add a Card',
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
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              const Text(
                'Link a debit/credit card',
                style: TextStyle(
                  color: Color(0xFF1B5A96),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),

              // Card Holder's Name
              AuthTextField(
                controller: _cardHolderController,
                label: 'Card Holder\'s Name',
                hintText: 'Enter the name in which the card is registered',
                validator: _validateCardHolder,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 24),

              // Card Number
              AuthTextField(
                controller: _cardNumberController,
                label: 'Card Number',
                hintText: 'Enter card number',
                validator: _validateCardNumber,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  _CardNumberInputFormatter(),
                ],
              ),
              const SizedBox(height: 24),

              // Expiry Date
              AuthTextField(
                controller: _expiryDateController,
                label: 'Expiry Date',
                hintText: 'Enter expiry date in the format (mm/yy)',
                validator: _validateExpiryDate,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  _ExpiryDateInputFormatter(),
                ],
              ),
              const SizedBox(height: 24),

              // CCV
              AuthTextField(
                controller: _ccvController,
                label: 'CCV',
                hintText: 'Enter CCV',
                validator: _validateCCV,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'CCV is the 3-digit number behind the card.',
                style: TextStyle(
                  color: Color(0xFF1B5A96),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 48),

              // Add Card Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5A96),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: const Color(0xFF1B5A96).withOpacity(0.6),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Add Card',
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

// Custom input formatter for card number
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;
    String formattedText = '';
    
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formattedText += ' ';
      }
      formattedText += text[i];
    }
    
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

// Custom input formatter for expiry date
class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;
    String formattedText = '';
    
    for (int i = 0; i < text.length && i < 4; i++) {
      if (i == 2) {
        formattedText += '/';
      }
      formattedText += text[i];
    }
    
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}