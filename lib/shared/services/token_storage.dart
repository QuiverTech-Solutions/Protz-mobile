import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class TokenStorage {
  static const String _tokenKey = 'auth_token';
  static const String _tokenTypeKey = 'token_type';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'current_user';
  static const String _expiresAtKey = 'token_expires_at';
  
  static TokenStorage? _instance;
  static TokenStorage get instance => _instance ??= TokenStorage._();
  
  TokenStorage._();
  
  SharedPreferences? _prefs;
  
  Future<void> _ensureInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
  
  // Token management
  Future<void> saveToken({
    required String accessToken,
    required String tokenType,
    String? refreshToken,
    int? expiresIn,
  }) async {
    try {
      await _ensureInitialized();
      
      await _prefs!.setString(_tokenKey, accessToken);
      await _prefs!.setString(_tokenTypeKey, tokenType);
      
      if (refreshToken != null) {
        await _prefs!.setString(_refreshTokenKey, refreshToken);
      }
      
      if (expiresIn != null) {
        final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));
        await _prefs!.setString(_expiresAtKey, expiresAt.toIso8601String());
      }
      
      if (kDebugMode) {
        print('Token saved successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving token: $e');
      }
      rethrow;
    }
  }
  
  Future<String?> getAccessToken() async {
    try {
      await _ensureInitialized();
      return _prefs!.getString(_tokenKey);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting access token: $e');
      }
      return null;
    }
  }
  
  Future<String?> getTokenType() async {
    try {
      await _ensureInitialized();
      return _prefs!.getString(_tokenTypeKey);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting token type: $e');
      }
      return null;
    }
  }
  
  Future<String?> getRefreshToken() async {
    try {
      await _ensureInitialized();
      return _prefs!.getString(_refreshTokenKey);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting refresh token: $e');
      }
      return null;
    }
  }
  
  Future<bool> isTokenExpired() async {
    try {
      await _ensureInitialized();
      final expiresAtString = _prefs!.getString(_expiresAtKey);
      
      if (expiresAtString == null) {
        return false; // If no expiry is set, assume token is still valid
      }
      
      final expiresAt = DateTime.parse(expiresAtString);
      return DateTime.now().isAfter(expiresAt);
    } catch (e) {
      if (kDebugMode) {
        print('Error checking token expiry: $e');
      }
      return true; // Assume expired on error
    }
  }
  
  Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    if (token == null || token.isEmpty) {
      return false;
    }
    
    final isExpired = await isTokenExpired();
    return !isExpired;
  }
  
  // User management
  Future<void> saveUser(User user) async {
    try {
      await _ensureInitialized();
      final userJson = jsonEncode(user.toJson());
      await _prefs!.setString(_userKey, userJson);
      
      if (kDebugMode) {
        print('User saved successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving user: $e');
      }
      rethrow;
    }
  }
  
  Future<User?> getUser() async {
    try {
      await _ensureInitialized();
      final userJson = _prefs!.getString(_userKey);
      
      if (userJson == null || userJson.isEmpty) {
        return null;
      }
      
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return User.fromJson(userMap);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user: $e');
      }
      return null;
    }
  }
  
  // Clear all stored data
  Future<void> clearAll() async {
    try {
      await _ensureInitialized();
      
      await Future.wait([
        _prefs!.remove(_tokenKey),
        _prefs!.remove(_tokenTypeKey),
        _prefs!.remove(_refreshTokenKey),
        _prefs!.remove(_userKey),
        _prefs!.remove(_expiresAtKey),
      ]);
      
      if (kDebugMode) {
        print('All stored data cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing stored data: $e');
      }
      rethrow;
    }
  }
  
  // Clear only token data (keep user data)
  Future<void> clearTokens() async {
    try {
      await _ensureInitialized();
      
      await Future.wait([
        _prefs!.remove(_tokenKey),
        _prefs!.remove(_tokenTypeKey),
        _prefs!.remove(_refreshTokenKey),
        _prefs!.remove(_expiresAtKey),
      ]);
      
      if (kDebugMode) {
        print('Token data cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing token data: $e');
      }
      rethrow;
    }
  }
  
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final hasToken = await hasValidToken();
    final user = await getUser();
    return hasToken && user != null;
  }
  
  // Get authorization header value
  Future<String?> getAuthorizationHeader() async {
    final token = await getAccessToken();
    final tokenType = await getTokenType();
    
    if (token == null || token.isEmpty) {
      return null;
    }
    
    return '${tokenType ?? 'Bearer'} $token';
  }
}