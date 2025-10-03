import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../shared/models/user.dart';
import '../../shared/services/dio_client.dart';
import '../../shared/services/token_storage.dart';
import '../../shared/exceptions/auth_exceptions.dart';
import '../../shared/utils/error_handler.dart';
import '../models/auth_response.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
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
      final isLoggedIn = await _tokenStorage.isLoggedIn();
      if (isLoggedIn) {
        _currentUser = await _tokenStorage.getUser();
        _userController.add(_currentUser);
        
        // Optionally refresh user data from server
        try {
          await getMe();
        } catch (e) {
          if (kDebugMode) {
            print('Failed to refresh user data on initialization: $e');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing AuthService: $e');
      }
    }
  }

  /// Login with username and password
  /// POST /users/login
  Future<AuthResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      final loginRequest = LoginRequest(
        username: username,
        password: password,
      );

      final response = await _dioClient.post<Map<String, dynamic>>(
        '/users/login',
        data: loginRequest.toJson(),
      );

      if (response.data == null) {
        throw const ServerException('Invalid response from server');
      }

      final authResponse = AuthResponse.fromJson(response.data!);
      
      // Store token
      await _tokenStorage.saveToken(
        accessToken: authResponse.accessToken,
        tokenType: authResponse.tokenType,
        refreshToken: authResponse.refreshToken,
        expiresIn: authResponse.expiresIn,
      );

      // Update Dio client with new token
      await _dioClient.setToken(authResponse.accessToken);

      // Get user data after successful login
      await getMe();

      return authResponse;
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  /// Register new user
  /// POST /users/register
  Future<User> register(RegisterRequest registerRequest) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/users/register',
        data: registerRequest.toJson(),
      );

      if (response.data == null) {
        throw const ServerException('Invalid response from server');
      }

      final user = User.fromJson(response.data!);
      
      // Store user data
      _currentUser = user;
      await _tokenStorage.saveUser(user);
      _userController.add(_currentUser);

      return user;
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        print('Registration error: $e');
      }
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  /// Get current user data
  /// GET /users/me
  Future<User> getMe() async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>('/users/me');

      if (response.data == null) {
        throw const ServerException('Invalid response from server');
      }

      final user = User.fromJson(response.data!);
      
      // Update stored user data
      _currentUser = user;
      await _tokenStorage.saveUser(user);
      _userController.add(_currentUser);

      return user;
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        print('Get user error: $e');
      }
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

      final response = await _dioClient.patch<Map<String, dynamic>>(
        '/users/me',
        data: updateData,
      );

      if (response.data == null) {
        throw const ServerException('Invalid response from server');
      }

      final user = User.fromJson(response.data!);
      
      // Update stored user data
      _currentUser = user;
      await _tokenStorage.saveUser(user);
      _userController.add(_currentUser);

      return user;
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        print('Update user error: $e');
      }
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
      final otpRequest = OtpRequest(
        userId: userId,
        otpCode: otpCode,
      );

      final response = await _dioClient.post<Map<String, dynamic>>(
        '/users/verify',
        data: otpRequest.toJson(),
      );

      if (response.data == null) {
        throw const ServerException('Invalid response from server');
      }

      final user = User.fromJson(response.data!);
      
      // Update stored user data
      _currentUser = user;
      await _tokenStorage.saveUser(user);
      _userController.add(_currentUser);

      return user;
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        print('OTP verification error: $e');
      }
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  /// Forgot password
  /// POST /users/forgot-password
  Future<Map<String, dynamic>> forgotPassword({
    required String emailOrPhone,
  }) async {
    try {
      final forgotPasswordRequest = ForgotPasswordRequest(
        emailOrPhone: emailOrPhone,
      );

      final response = await _dioClient.post<Map<String, dynamic>>(
        '/users/forgot-password',
        data: forgotPasswordRequest.toJson(),
      );

      if (response.data == null) {
        throw const ServerException('Invalid response from server');
      }

      return response.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        print('Forgot password error: $e');
      }
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
      final resetPasswordRequest = ResetPasswordRequest(
        userId: userId,
        otpCode: otpCode,
        newPassword: newPassword,
      );

      final response = await _dioClient.post<Map<String, dynamic>>(
        '/users/reset-password',
        data: resetPasswordRequest.toJson(),
      );

      if (response.data == null) {
        throw const ServerException('Invalid response from server');
      }

      return response.data!;
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      if (kDebugMode) {
        print('Reset password error: $e');
      }
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  /// Logout user (clear local data)
  Future<void> logout() async {
    try {
      // Clear all stored data
      await _tokenStorage.clearAll();
      await _dioClient.clearToken();
      
      // Clear current user
      _currentUser = null;
      _userController.add(null);
      
      if (kDebugMode) {
        print('User logged out successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Logout error: $e');
      }
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      return await _tokenStorage.isLoggedIn();
    } catch (e) {
      if (kDebugMode) {
        print('Error checking authentication status: $e');
      }
      return false;
    }
  }

  /// Refresh user data from server
  Future<void> refreshUser() async {
    try {
      if (await isAuthenticated()) {
        await getMe();
      }
    } on AuthException {
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing user data: $e');
      }
      throw ErrorHandler.handleGeneralError(e);
    }
  }

  /// Get stored token
  Future<String?> getToken() async {
    return await _tokenStorage.getAccessToken();
  }

  /// Check if token is valid
  Future<bool> hasValidToken() async {
    return await _tokenStorage.hasValidToken();
  }

  /// Dispose resources
  void dispose() {
    _userController.close();
  }
}