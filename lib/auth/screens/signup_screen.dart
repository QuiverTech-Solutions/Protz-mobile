import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import '../widgets/auth_text_field.dart';
import '../services/new_auth_service.dart';
import '../models/register_request.dart';
import '../models/user_data.dart';
import '../models/user_profile.dart';
import '../../shared/exceptions/auth_exceptions.dart';
import '../../shared/utils/error_handler.dart';
import '../../shared/utils/pages.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emergencyContactNameController = TextEditingController();
  final TextEditingController _emergencyContactPhoneController = TextEditingController();
  
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _agreeToTerms = false;
  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _dateOfBirthError;
  String? _addressError;
  String? _emergencyContactNameError;
  String? _emergencyContactPhoneError;
  String? _errorMessage;
  String _selectedGender = 'Male';

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
                // Header section with title
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2B2930),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Create your account to get\nstarted with our services',
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
                        padding: const EdgeInsets.only(
                            left: 32,
                            right: 32,
                            top: 100,
                            bottom: 32,
                            ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                          
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
                          
                              // Name Field
                              AuthTextField(
                                controller: _nameController,
                                label: 'Name',
                                hintText: 'Name',
                                keyboardType: TextInputType.name,
                                textCapitalization: TextCapitalization.words,
                                validator: _validateName,
                              ),
                              const SizedBox(height: 16),
                          
                              // Email Field
                              AuthTextField(
                                controller: _emailController,
                                label: 'Email',
                                hintText: 'example@gmail.com',
                                keyboardType: TextInputType.emailAddress,
                                validator: _validateEmail,
                              ),
                              const SizedBox(height: 16),
                          
                              // Phone Field
                              AuthTextField(
                                controller: _phoneController,
                                label: 'Phone Number',
                                hintText: '+1234567890',
                                keyboardType: TextInputType.phone,
                                validator: _validatePhone,
                              ),
                              const SizedBox(height: 16),
                          
                              // Date of Birth Field
                              GestureDetector(
                                onTap: () => _selectDateOfBirth(context),
                                child: AbsorbPointer(
                                  child: AuthTextField(
                                    controller: _dateOfBirthController,
                                    label: 'Date of Birth',
                                    hintText: 'Select your date of birth',
                                    validator: _validateDateOfBirth,
                                    suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF086688)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                          
                              // Gender Field
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Gender',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2B2930),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xFFE0E0E0)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedGender,
                                        isExpanded: true,
                                        items: ['Male', 'Female', 'Other'].map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                                color: Color(0xFF2B2930),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedGender = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                          
                              // Address Field
                              AuthTextField(
                                controller: _addressController,
                                label: 'Address',
                                hintText: 'Enter your address',
                                keyboardType: TextInputType.streetAddress,
                                validator: _validateAddress,
                                maxLines: 2,
                              ),
                              const SizedBox(height: 16),
                          
                              // Emergency Contact Name Field
                              AuthTextField(
                                controller: _emergencyContactNameController,
                                label: 'Emergency Contact Name',
                                hintText: 'Enter emergency contact name',
                                keyboardType: TextInputType.name,
                                textCapitalization: TextCapitalization.words,
                                validator: _validateEmergencyContactName,
                              ),
                              const SizedBox(height: 16),
                          
                              // Emergency Contact Phone Field
                              AuthTextField(
                                controller: _emergencyContactPhoneController,
                                label: 'Emergency Contact Phone',
                                hintText: '+1234567890',
                                keyboardType: TextInputType.phone,
                                validator: _validateEmergencyContactPhone,
                              ),
                              const SizedBox(height: 16),
                          
                              // Password Field
                              AuthTextField(
                                controller: _passwordController,
                                label: 'Password',
                                hintText: '••••••••••',
                                obscureText: true,
                                validator: _validatePassword,
                              ),
                              const SizedBox(height: 16),
                          
                              // Re-enter Password Field
                              AuthTextField(
                                controller: _confirmPasswordController,
                                label: 'Re-enter Password',
                                hintText: '••••••••••',
                                obscureText: true,
                                validator: _validateConfirmPassword,
                              ),
                          
                              const SizedBox(height: 16),
                          
                              // Terms and Conditions Checkbox
                              Row(
                                children: [
                                  Checkbox(
                                    value: _agreeToTerms,
                                    onChanged: (value) {
                                      setState(() {
                                        _agreeToTerms = value ?? false;
                                      });
                                    },
                                    activeColor: const Color(0xFF086688),
                                  ),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          color: Color(0xFF322F35),
                                        ),
                                        children: [
                                          const TextSpan(text: 'I agree to the '),
                                          TextSpan(
                                            text: 'Terms & Conditions',
                                            style: const TextStyle(
                                              color: Color(0xFF086688),
                                              fontWeight: FontWeight.w600,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                // Navigate to terms and conditions
                                                context.push('/terms-conditions');
                                              },
                                          ),
                                          const TextSpan(text: ' and '),
                                          TextSpan(
                                            text: 'Privacy Policy',
                                            style: const TextStyle(
                                              color: Color(0xFF086688),
                                              fontWeight: FontWeight.w600,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                // Navigate to privacy policy
                                                context.push('/privacy-policy');
                                              },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                          
                              // Sign Up Button
                              SizedBox(
                                //width: ,
                                height: 50,
                                child: Center(
                                  child: ElevatedButton( 
                                    onPressed: _isLoading ? null : _handleSignUp,
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
                                            'Sign Up',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                          
                              // Login Link
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
                                          text: "Already have an account? "),
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () {
                                            // Navigate back to login screen
                                            context.go(AppRoutes.login);
                                          },
                                          child: const Text(
                                            'Login',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignUp() async {
  // Clear previous error
  setState(() {
    _errorMessage = null;
  });

  if (!_validateInputs()) {
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    final nameParts = _nameController.text.trim().split(' ');
    
    // Parse date of birth to proper format (YYYY-MM-DD)
    String formattedDateOfBirth = '';
    if (_dateOfBirthController.text.isNotEmpty) {
      final dateParts = _dateOfBirthController.text.split('/');
      if (dateParts.length == 3) {
        // Convert from DD/MM/YYYY to YYYY-MM-DD
        formattedDateOfBirth = '${dateParts[2]}-${dateParts[1].padLeft(2, '0')}-${dateParts[0].padLeft(2, '0')}';
      }
    }
    
    // Create the register request with the correct flat structure
    final registerRequest = RegisterRequest(
      firstName: nameParts.isNotEmpty ? nameParts[0] : '',
      lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
      userType: 'user',
      phoneNumber: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      dateOfBirth: formattedDateOfBirth.isNotEmpty ? formattedDateOfBirth : null,
      gender: _selectedGender.toLowerCase(),
      primaryAddress: _addressController.text.trim(),
      emergencyContactName: _emergencyContactNameController.text.trim(),
      emergencyContactPhone: _emergencyContactPhoneController.text.trim(),
      profilePhotoUrl: null,
      city: null,
      state: null,
      alternatePhone: null,
      middleName: null,
    );

    final user = await _authService.register(registerRequest);

    // Registration successful, navigate to OTP verification
    if (mounted) {
      context.go('${AppRoutes.otpVerification}?userId=${user.id}&phone=${user.phoneNumber}');
    }
  } on AuthException catch (e) {
    setState(() {
      _errorMessage = ErrorHandler.getUserFriendlyMessage(e);
    });
  } catch (e) {
    setState(() {
      _errorMessage = 'An unexpected error occurred. Please try again.';
    });
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  bool _validateInputs() {
    setState(() {
      _nameError = _validateName(_nameController.text);
      _emailError = _validateEmail(_emailController.text);
      _phoneError = _validatePhone(_phoneController.text);
      _dateOfBirthError = _validateDateOfBirth(_dateOfBirthController.text);
      _addressError = _validateAddress(_addressController.text);
      _emergencyContactNameError = _validateEmergencyContactName(_emergencyContactNameController.text);
      _emergencyContactPhoneError = _validateEmergencyContactPhone(_emergencyContactPhoneController.text);
      _passwordError = _validatePassword(_passwordController.text);
      _confirmPasswordError =
          _validateConfirmPassword(_confirmPasswordController.text);
    });

    return _nameError == null &&
        _emailError == null &&
        _phoneError == null &&
        _dateOfBirthError == null &&
        _addressError == null &&
        _emergencyContactNameError == null &&
        _emergencyContactPhoneError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _agreeToTerms;
  }

  String? _validateName(String? name) {
    if (name == null || name.isEmpty) return 'Name is required';
    if (name.length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) return 'Phone number is required';
    // Remove all non-digit characters for validation
    String digitsOnly = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length < 10) return 'Phone number must be at least 10 digits';
    return null;
  }

  String? _validateDateOfBirth(String? dateOfBirth) {
    if (dateOfBirth == null || dateOfBirth.isEmpty) return 'Date of birth is required';
    return null;
  }

  String? _validateAddress(String? address) {
    if (address == null || address.isEmpty) return 'Address is required';
    if (address.length < 10) return 'Please enter a complete address';
    return null;
  }

  String? _validateEmergencyContactName(String? name) {
    if (name == null || name.isEmpty) return 'Emergency contact name is required';
    if (name.length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  String? _validateEmergencyContactPhone(String? phone) {
    if (phone == null || phone.isEmpty) return 'Emergency contact phone is required';
    // Remove all non-digit characters for validation
    String digitsOnly = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length < 10) return 'Phone number must be at least 10 digits';
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty)
      return 'Please confirm your password';
    if (_passwordController.text != confirmPassword)
      return 'Passwords do not match';
    return null;
  }

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 6570)), // Must be at least 18
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF086688),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF2B2930),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
    _addressController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactPhoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
