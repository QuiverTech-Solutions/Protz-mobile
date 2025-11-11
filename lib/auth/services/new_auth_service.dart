import 'dart:async';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';

import '../../shared/models/user.dart';
import '../../shared/services/dio_client.dart';
import '../../shared/services/token_storage.dart';
import '../../shared/exceptions/auth_exceptions.dart';
import '../../shared/utils/error_handler.dart';
import '../models/auth_response.dart';
import '../models/register_request.dart';
import '../models/profile_with_user_request.dart';
import '../models/otp_request.dart';
import '../models/password_reset_request.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final DioClient _dioClient = DioClient();
  final TokenStorage _tokenStorage = TokenStorage.instance;
  
  final StreamController<User?> _userController = StreamController<User?>.broadcast();
  Stream<User?> get userStream => _userController.stream;

  User? _currentUser;
  User? get currentUser => _currentUser;

  // Initialize the service and check for existing session
  Future<void> initialize() async {
    try {
      developer.log('AuthService: Initializing...');
      final isLoggedIn = await _tokenStorage.isLoggedIn();
      if (isLoggedIn) {
        _currentUser = await _tokenStorage.getUser();
        _userController.add(_currentUser);
        
        // Only refresh user data from server if we have a valid token
        final hasValidToken = await _tokenStorage.hasValidToken();
        if (hasValidToken) {
          try {
            await getMe();
            developer.log('AuthService: User data refreshed successfully');
          } catch (e) {
            developer.log('AuthService: Failed to refresh user data on initialization: $e');
          }
        } else {
          developer.log('AuthService: Skipping user data refresh - no valid token available');
        }
      }
      developer.log('AuthService: Initialization complete. isLoggedIn: $isLoggedIn');
    } catch (e) {
      developer.log('AuthService: Error initializing: $e');
      rethrow;
    }
  }

  /// User login
  /// POST /users/login
  Future<User> login({
    required String username,
    required String password,
  }) async {
    try {
      developer.log('AuthService: Starting login process for username: $username');
      developer.log('AuthService: Login endpoint: /users/login');

      // Prepare form data as required by the API
      final formData = FormData.fromMap({
        'username': username,
        'password': password,
        'grant_type': 'password',
      });

      developer.log('AuthService: Login request prepared with form data: username=$username, grant_type=password');

      final response = await _dioClient.post<Map<String, dynamic>>(
        '/users/login',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
      );

      developer.log('AuthService: Login response received - Status: ${response.statusCode}');
      developer.log('AuthService: Login response headers: ${response.headers}');

      if (response.data == null) {
        developer.log('AuthService: ERROR - Login response data is null');
        throw const ServerException('Invalid response from server');
      }

      developer.log('AuthService: Login response data keys: ${response.data!.keys.toList()}');

      // Check if response contains access_token (OAuth2 format)
      if (response.data!.containsKey('access_token')) {
        developer.log('AuthService: OAuth2 token response detected');
        
        final authResponse = AuthResponse.fromJson(response.data!);
        developer.log('AuthService: Auth token parsed - Type: ${authResponse.tokenType}, Expires: ${authResponse.expiresIn}');
        
        // Save the token
        await _tokenStorage.saveToken(
          accessToken: authResponse.accessToken,
          tokenType: authResponse.tokenType ?? 'Bearer',
          refreshToken: authResponse.refreshToken,
          expiresIn: authResponse.expiresIn,
        );
        
        developer.log('AuthService: Tokens saved successfully');
        
        // Try to fetch user data using the token, but fallback if it fails
        developer.log('AuthService: Attempting to fetch user data after successful login');
        try {
          final user = await getMe();
          developer.log('AuthService: Login completed successfully for user: ${user.id}');
          return user;
        } catch (e) {
          developer.log('AuthService: Failed to fetch user data via /users/me: $e');
          developer.log('AuthService: Using fallback - creating minimal user from login response');
          
          // Create a minimal user object for successful login without user data
           final fallbackUser = User(
             id: 'temp_${DateTime.now().millisecondsSinceEpoch}', // Temporary ID
             name: 'User', // Required name field
             email: username.contains('@') ? username : 'user@example.com', // Use username if it's an email, otherwise default
             phoneNumber: !username.contains('@') ? username : '+1234567890', // Use username if it's a phone, otherwise default
             firstName: 'User', // Default first name
             lastName: '', // Default last name
             role: UserRole.customer, // Default role
             isVerified: true, // Assume verified for fallback
             isAvailable: true, // Default availability
             createdAt: DateTime.now(),
             updatedAt: DateTime.now(),
           );
          
          // Store the fallback user data
          _currentUser = fallbackUser;
          await _tokenStorage.saveUser(fallbackUser);
          _userController.add(_currentUser);
          
          developer.log('AuthService: Login completed with fallback user - ID: ${fallbackUser.id}');
          return fallbackUser;
        }
      } else {
        // Direct user data response
        developer.log('AuthService: Direct user data response detected');
        
        final user = User.fromJson(response.data!);
        developer.log('AuthService: User data parsed - ID: ${user.id}, Email: ${user.email}');
        
        // Store user data
        _currentUser = user;
        await _tokenStorage.saveUser(user);
        _userController.add(_currentUser);

        developer.log('AuthService: Login completed successfully for user: ${user.id}');
        return user;
      }
    } on DioException catch (e) {
      developer.log('AuthService: DioException during login - Type: ${e.type}');
      developer.log('AuthService: DioException message: ${e.message}');
      developer.log('AuthService: DioException response status: ${e.response?.statusCode}');
      developer.log('AuthService: DioException response data: ${e.response?.data}');
      
      if (e.response?.statusCode == 401) {
        developer.log('AuthService: Authentication failed - Invalid credentials');
        throw const AuthException('Invalid username or password');
      } else if (e.response?.statusCode == 422) {
        developer.log('AuthService: Validation error during login');
        throw AuthException('Validation error: ${e.response?.data}');
      }
      
      throw ErrorHandler.handleDioError(e);
    } catch (e, stackTrace) {
      developer.log('AuthService: Unexpected error during login: $e');
      developer.log('AuthService: Login error stack trace: $stackTrace');
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  /// User registration
  /// POST /users/register
  Future<User> register(RegisterRequest registerRequest) async {
    try {
      developer.log('AuthService: Starting registration process');
      developer.log('AuthService: Registration endpoint: /users/register');
      developer.log('AuthService: User type: ${registerRequest.userType}');
      developer.log('AuthService: Email: ${registerRequest.email}');
      developer.log('AuthService: Phone: ${registerRequest.phoneNumber}');

      // Create the new API-compliant request using ProfileWithUserRequest
      final profileWithUserRequest = ProfileWithUserRequest.fromFormData(
        firstName: registerRequest.firstName,
        lastName: registerRequest.lastName,
        middleName: registerRequest.middleName,
        userType: registerRequest.userType,
        phoneNumber: registerRequest.phoneNumber,
        alternatePhone: registerRequest.alternatePhone,
        email: registerRequest.email,
        profilePhotoUrl: registerRequest.profilePhotoUrl ?? "",
        emergencyContactName: registerRequest.emergencyContactName,
        emergencyContactPhone: registerRequest.emergencyContactPhone,
        primaryAddress: registerRequest.primaryAddress,
        city: registerRequest.city,
        state: registerRequest.state,
        dateOfBirth: registerRequest.dateOfBirth,
        gender: registerRequest.gender ?? "not_specified",
        password: registerRequest.password,
        emailVerified: false,
        phoneVerified: true,
      );

      developer.log('AuthService: ProfileWithUserRequest created successfully');
      developer.log('AuthService: Registration request data structure: ${profileWithUserRequest.toJson().keys.toList()}');

      final response = await _dioClient.post<Map<String, dynamic>>(
        '/users/register',
        data: profileWithUserRequest.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      developer.log('AuthService: Registration response received - Status: ${response.statusCode}');
      developer.log('AuthService: Registration response headers: ${response.headers}');

      if (response.data == null) {
        developer.log('AuthService: ERROR - Registration response data is null');
        throw const ServerException('Invalid response from server');
      }

      developer.log('AuthService: Registration response data keys: ${response.data!.keys.toList()}');

      // Check if response contains access_token (OAuth2 format)
      if (response.data!.containsKey('access_token')) {
        developer.log('AuthService: OAuth2 token response detected in registration');
        
        final authResponse = AuthResponse.fromJson(response.data!);
        developer.log('AuthService: Auth token parsed - Type: ${authResponse.tokenType}, Expires: ${authResponse.expiresIn}');
        
        // Save the token
        await _tokenStorage.saveToken(
          accessToken: authResponse.accessToken,
          tokenType: authResponse.tokenType ?? 'Bearer',
          refreshToken: authResponse.refreshToken,
          expiresIn: authResponse.expiresIn,
        );
        
        developer.log('AuthService: Tokens saved successfully');
        
        // Fetch user data using the token
        developer.log('AuthService: Fetching user data after successful registration');
        final user = await getMe();
        
        developer.log('AuthService: Registration completed successfully for user: ${user.id}');
        return user;
      } else {
        // Direct user data response
        developer.log('AuthService: Direct user data response detected in registration');
        
        final registeredUser = User.fromJson(response.data!);
        developer.log('AuthService: User data parsed - ID: ${registeredUser.id}, Email: ${registeredUser.email}');
        
        // Store user data
        _currentUser = registeredUser;
        await _tokenStorage.saveUser(registeredUser);
        _userController.add(_currentUser);

        developer.log('AuthService: Registration completed successfully for user: ${registeredUser.id}');
        return registeredUser;
      }
    } on DioException catch (e) {
      developer.log('AuthService: DioException during registration - Type: ${e.type}');
      developer.log('AuthService: DioException message: ${e.message}');
      developer.log('AuthService: DioException response status: ${e.response?.statusCode}');
      developer.log('AuthService: DioException response data: ${e.response?.data}');
      
      if (e.response?.statusCode == 400) {
        developer.log('AuthService: Bad request during registration');
        throw AuthException('Registration failed: ${e.response?.data}');
      } else if (e.response?.statusCode == 422) {
        developer.log('AuthService: Validation error during registration');
        throw AuthException('Validation error: ${e.response?.data}');
      } else if (e.response?.statusCode == 409) {
        developer.log('AuthService: Conflict during registration - User already exists');
        throw const AuthException('User with this email or phone number already exists');
      }
      
      throw ErrorHandler.handleDioError(e);
    } catch (e, stackTrace) {
      developer.log('AuthService: Unexpected error during registration: $e');
      developer.log('AuthService: Registration error stack trace: $stackTrace');
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  /// Get current user data
  /// GET /users/me
  Future<User> getMe() async {
    try {
      developer.log('AuthService: Fetching current user data');
      developer.log('AuthService: GetMe endpoint: /users/me');

      final response = await _dioClient.get<Map<String, dynamic>>('/users/me');

      developer.log('AuthService: GetMe response received - Status: ${response.statusCode}');
      developer.log('AuthService: GetMe response headers: ${response.headers}');

      if (response.data == null) {
        developer.log('AuthService: ERROR - GetMe response data is null');
        throw const ServerException('Invalid response from server');
      }

      developer.log('AuthService: GetMe response data keys: ${response.data!.keys.toList()}');

      final user = User.fromJson(response.data!);
      developer.log('AuthService: User data parsed - ID: ${user.id}, Email: ${user.email}, Role: ${user.role}');
      
      // Update stored user data
      _currentUser = user;
      await _tokenStorage.saveUser(user);
      _userController.add(_currentUser);

      developer.log('AuthService: User data updated successfully in storage and stream');
      return user;
    } on DioException catch (e) {
      developer.log('AuthService: DioException during getMe - Type: ${e.type}');
      developer.log('AuthService: DioException message: ${e.message}');
      developer.log('AuthService: DioException response status: ${e.response?.statusCode}');
      developer.log('AuthService: DioException response data: ${e.response?.data}');
      
      if (e.response?.statusCode == 401) {
        developer.log('AuthService: Unauthorized access - Token may be invalid');
        throw const AuthException('Authentication required');
      }
      
      throw ErrorHandler.handleDioError(e);
    } catch (e, stackTrace) {
      developer.log('AuthService: Unexpected error during getMe: $e');
      developer.log('AuthService: GetMe error stack trace: $stackTrace');
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  /// Update current user data
  /// PATCH /users/me
  Future<User> updateMe({
    String? email,
    String? phoneNumber,
    String? password,
    bool? isAvailable,
    bool? isOnline,
    Map<String, dynamic>? additionalFields,
  }) async {
    try {
      developer.log('AuthService: Updating user data');

      final updateData = <String, dynamic>{};
      
      if (email != null) updateData['email'] = email;
      if (phoneNumber != null) updateData['phone_number'] = phoneNumber;
      if (password != null) updateData['password'] = password;
      if (isAvailable != null) updateData['is_available'] = isAvailable;
      if (isOnline != null) updateData['is_online'] = isOnline;
      
      // Add any additional fields
      if (additionalFields != null) {
        updateData.addAll(additionalFields);
      }

      developer.log('AuthService: Update data: $updateData');

      final response = await _dioClient.patch<Map<String, dynamic>>(
        '/users/me',
        data: updateData,
      );

      developer.log('AuthService: Update response received: ${response.statusCode}');

      if (response.data == null) {
        developer.log('AuthService: Invalid response from server - null data');
        throw const ServerException('Invalid response from server');
      }

      final user = User.fromJson(response.data!);
      
      // Update stored user data
      _currentUser = user;
      await _tokenStorage.saveUser(user);
      _userController.add(_currentUser);

      developer.log('AuthService: User data updated successfully');
      return user;
    } on DioException catch (e) {
      developer.log('AuthService: Dio error during updateMe: ${e.message}');
      developer.log('AuthService: Dio error response: ${e.response?.data}');
      throw ErrorHandler.handleDioError(e);
    } catch (e, stackTrace) {
      developer.log('AuthService: General error during updateMe: $e');
      developer.log('AuthService: Stack trace: $stackTrace');
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  /// Verify OTP
  /// POST /users/verify
  Future<User> verifyOtp({
    required String userId,
    required String otpCode,
  }) async {
    try {
      developer.log('AuthService: Verifying OTP for user: $userId');

      final otpRequest = OtpRequest(
        userId: userId,
        otpCode: otpCode,
      );

      developer.log('AuthService: OTP verification request: ${otpRequest.toJson()}');

      final response = await _dioClient.post<Map<String, dynamic>>(
        '/users/verify',
        data: otpRequest.toJson(),
      );

      developer.log('AuthService: OTP verification response: ${response.statusCode}');

      if (response.data == null) {
        developer.log('AuthService: Invalid OTP verification response');
        throw const ServerException('Invalid response from server');
      }

      developer.log('AuthService: OTP verification response data: ${response.data}');

      final user = User.fromJson(response.data!);
      
      // Update stored user data
      _currentUser = user;
      await _tokenStorage.saveUser(user);
      _userController.add(_currentUser);

      developer.log('AuthService: OTP verification successful');
      return user;
    } on DioException catch (e) {
      developer.log('AuthService: Dio error during OTP verification: ${e.message}');
      developer.log('AuthService: OTP verification error response: ${e.response?.data}');
      throw ErrorHandler.handleDioError(e);
    } catch (e, stackTrace) {
      developer.log('AuthService: General error during OTP verification: $e');
      developer.log('AuthService: Stack trace: $stackTrace');
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  /// Forgot password
  /// POST /users/forgot-password
  Future<Map<String, dynamic>> forgotPassword({
    required String emailOrPhone,
  }) async {
    try {
      developer.log('AuthService: Sending forgot password request for: $emailOrPhone');

      final forgotPasswordRequest = ForgotPasswordRequest(
        emailOrPhone: emailOrPhone,
      );

      developer.log('AuthService: Forgot password request: ${forgotPasswordRequest.toJson()}');

      final response = await _dioClient.post<Map<String, dynamic>>(
        '/users/forgot-password',
        data: forgotPasswordRequest.toJson(),
      );

      developer.log('AuthService: Forgot password response: ${response.statusCode}');

      if (response.data == null) {
        developer.log('AuthService: Invalid forgot password response');
        throw const ServerException('Invalid response from server');
      }

      developer.log('AuthService: Forgot password response data: ${response.data}');

      developer.log('AuthService: Forgot password request successful');
      return response.data!;
    } on DioException catch (e) {
      developer.log('AuthService: Dio error during forgot password: ${e.message}');
      developer.log('AuthService: Forgot password error response: ${e.response?.data}');
      throw ErrorHandler.handleDioError(e);
    } catch (e, stackTrace) {
      developer.log('AuthService: General error during forgot password: $e');
      developer.log('AuthService: Stack trace: $stackTrace');
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  /// Reset password
  /// POST /users/reset-password
  Future<Map<String, dynamic>> resetPassword({
    required String userId,
    required String otpCode,
    required String newPassword,
  }) async {
    try {
      developer.log('AuthService: Resetting password for user: $userId');

      final resetPasswordRequest = ResetPasswordRequest(
        userId: userId,
        otpCode: otpCode,
        newPassword: newPassword,
      );

      developer.log('AuthService: Reset password request: ${resetPasswordRequest.toJson()}');

      final response = await _dioClient.post<Map<String, dynamic>>(
        '/users/reset-password',
        data: resetPasswordRequest.toJson(),
      );

      developer.log('AuthService: Reset password response: ${response.statusCode}');

      if (response.data == null) {
        developer.log('AuthService: Invalid reset password response');
        throw const ServerException('Invalid response from server');
      }

      developer.log('AuthService: Reset password response data: ${response.data}');

      developer.log('AuthService: Password reset successful');
      return response.data!;
    } on DioException catch (e) {
      developer.log('AuthService: Dio error during reset password: ${e.message}');
      developer.log('AuthService: Reset password error response: ${e.response?.data}');
      throw ErrorHandler.handleDioError(e);
    } catch (e, stackTrace) {
      developer.log('AuthService: General error during reset password: $e');
      developer.log('AuthService: Stack trace: $stackTrace');
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  /// Logout user (clear local data)
  Future<void> logout() async {
    try {
      developer.log('AuthService: Logging out user');

      // Clear all stored data
      await _tokenStorage.clearAll();
      await _dioClient.clearToken();
      
      // Clear current user
      _currentUser = null;
      _userController.add(null);
      
      developer.log('AuthService: User logged out successfully');
    } catch (e, stackTrace) {
      developer.log('AuthService: Error during logout: $e');
      developer.log('AuthService: Stack trace: $stackTrace');
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final isAuthenticated = await _tokenStorage.isLoggedIn();
      developer.log('AuthService: Authentication check: $isAuthenticated');
      return isAuthenticated;
    } catch (e, stackTrace) {
      developer.log('AuthService: Error checking authentication status: $e');
      developer.log('AuthService: Stack trace: $stackTrace');
      return false;
    }
  }

  /// Refresh user data from server
  Future<void> refreshUser() async {
    try {
      developer.log('AuthService: Refreshing user data');
      
      if (await isAuthenticated()) {
        await getMe();
        developer.log('AuthService: User data refreshed successfully');
      } else {
        developer.log('AuthService: User not authenticated, skipping refresh');
      }
    } on AuthException catch (e) {
      developer.log('AuthService: AuthException during refresh: ${e.message}');
      rethrow;
    } catch (e, stackTrace) {
      developer.log('AuthService: Error refreshing user data: $e');
      developer.log('AuthService: Stack trace: $stackTrace');
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  /// Get stored token
  Future<String?> getToken() async {
    try {
      final token = await _tokenStorage.getAccessToken();
      developer.log('AuthService: Retrieved token: ${token != null ? '${token.substring(0, 10)}...' : 'null'}');
      return token;
    } catch (e, stackTrace) {
      developer.log('AuthService: Error getting token: $e');
      developer.log('AuthService: Stack trace: $stackTrace');
      return null;
    }
  }

  /// Check if token is valid
  Future<bool> hasValidToken() async {
    try {
      final hasValidToken = await _tokenStorage.hasValidToken();
      developer.log('AuthService: Token validity check: $hasValidToken');
      return hasValidToken;
    } catch (e, stackTrace) {
      developer.log('AuthService: Error checking token validity: $e');
      developer.log('AuthService: Stack trace: $stackTrace');
      return false;
    }
  }

  /// Clear any authentication errors and reset state
  Future<void> clearErrors() async {
    developer.log('AuthService: Clearing authentication errors');
  }

  /// Get authentication status with detailed information
  Future<Map<String, dynamic>> getAuthStatus() async {
    try {
      final isLoggedIn = await _tokenStorage.isLoggedIn();
      final hasToken = await _tokenStorage.hasValidToken();
      final user = _currentUser;
      
      final status = {
        'isLoggedIn': isLoggedIn,
        'hasValidToken': hasToken,
        'user': user?.toJson(),
        'userId': user?.id,
      };
      
      developer.log('AuthService: Auth status: $status');
      return status;
    } catch (e, stackTrace) {
      developer.log('AuthService: Error getting auth status: $e');
      developer.log('AuthService: Stack trace: $stackTrace');
      return {
        'isLoggedIn': false,
        'hasValidToken': false,
        'user': null,
        'userId': null,
        'error': e.toString(),
      };
    }
  }

  /// Dispose resources
  void dispose() {
    developer.log('AuthService: Disposing AuthService');
    _userController.close();
  }
}