# PROTZ AuthService Documentation

## Overview

The `AuthService` is a production-ready authentication service for the PROTZ Flutter application. It provides a complete authentication solution with Dio HTTP client, token management, and comprehensive error handling.

## Features

- ✅ **Complete API Integration**: All required PROTZ backend endpoints
- ✅ **Token Management**: Automatic token storage and refresh using SharedPreferences
- ✅ **Error Handling**: Custom exceptions with user-friendly error messages
- ✅ **Type Safety**: Strongly typed models with JSON serialization
- ✅ **Stream Support**: Real-time user state updates
- ✅ **Singleton Pattern**: Single instance across the app
- ✅ **Production Ready**: Comprehensive logging and error recovery

## Architecture

```
lib/
├── auth/
│   ├── models/
│   │   ├── auth_response.dart          # Login response model
│   │   ├── login_request.dart          # Login request model
│   │   ├── register_request.dart       # Registration request model
│   │   ├── otp_request.dart           # OTP verification model
│   │   ├── password_reset_request.dart # Password reset models
│   │   └── update_user_request.dart    # User update model
│   └── services/
│       └── new_auth_service.dart       # Main authentication service
├── shared/
│   ├── models/
│   │   └── user.dart                   # User model (updated)
│   ├── services/
│   │   ├── dio_client.dart            # HTTP client with interceptors
│   │   └── token_storage.dart         # Token persistence
│   ├── exceptions/
│   │   └── auth_exceptions.dart       # Custom exception classes
│   └── utils/
│       └── error_handler.dart         # Error handling utilities
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/users/login` | User login |
| `POST` | `/users/register` | User registration |
| `GET` | `/users/me` | Get current user |
| `PATCH` | `/users/me` | Update current user |
| `POST` | `/users/verify` | Verify OTP |
| `POST` | `/users/forgot-password` | Forgot password |
| `POST` | `/users/reset-password` | Reset password |
| Local | N/A | Logout (clear local data) |

## Usage Examples

### 1. Initialize the Service

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize AuthService
  final authService = AuthService();
  await authService.initialize();
  
  runApp(MyApp());
}
```

### 2. Login

```dart
try {
  final authResponse = await AuthService().login(
    username: 'user@example.com',
    password: 'password123',
  );
  
  print('Login successful: ${authResponse.accessToken}');
} on InvalidCredentialsException catch (e) {
  print('Invalid credentials: ${e.message}');
} on NetworkException catch (e) {
  print('Network error: ${e.message}');
} on AuthException catch (e) {
  print('Auth error: ${e.message}');
}
```

### 3. Register

```dart
try {
  final registerRequest = RegisterRequest(
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
    phoneNumber: '+1234567890',
    password: 'password123',
    dateOfBirth: DateTime(1990, 1, 1),
    gender: 'male',
    address: '123 Main St',
    emergencyContactName: 'Jane Doe',
    emergencyContactPhone: '+0987654321',
    userType: 'customer',
  );
  
  final user = await AuthService().register(registerRequest);
  print('Registration successful: ${user.email}');
} on UserAlreadyExistsException catch (e) {
  print('User already exists: ${e.message}');
} on ValidationException catch (e) {
  print('Validation error: ${e.message}');
  print('Field errors: ${e.fieldErrors}');
}
```

### 4. Get Current User

```dart
try {
  final user = await AuthService().getMe();
  print('Current user: ${user.email}');
} on UnauthorizedException catch (e) {
  print('Not authenticated: ${e.message}');
  // Redirect to login
}
```

### 5. Update User

```dart
try {
  final updatedUser = await AuthService().updateMe(
    email: 'newemail@example.com',
    isAvailable: true,
    additionalFields: {
      'profile_picture': 'https://example.com/avatar.jpg',
    },
  );
  print('User updated: ${updatedUser.email}');
} catch (e) {
  print('Update failed: $e');
}
```

### 6. Verify OTP

```dart
try {
  final user = await AuthService().verifyOtp(
    userId: 'user123',
    otpCode: '123456',
  );
  print('OTP verified: ${user.isVerified}');
} on InvalidOtpException catch (e) {
  print('Invalid OTP: ${e.message}');
}
```

### 7. Password Reset Flow

```dart
// Step 1: Request password reset
try {
  final response = await AuthService().forgotPassword(
    emailOrPhone: 'user@example.com',
  );
  print('Reset email sent: ${response['message']}');
} catch (e) {
  print('Failed to send reset email: $e');
}

// Step 2: Reset password with OTP
try {
  final response = await AuthService().resetPassword(
    userId: 'user123',
    otpCode: '123456',
    newPassword: 'newpassword123',
  );
  print('Password reset successful: ${response['message']}');
} on InvalidOtpException catch (e) {
  print('Invalid OTP: ${e.message}');
}
```

### 8. Listen to User State Changes

```dart
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late StreamSubscription<User?> _userSubscription;
  
  @override
  void initState() {
    super.initState();
    
    // Listen to user state changes
    _userSubscription = AuthService().userStream.listen((user) {
      if (user != null) {
        print('User logged in: ${user.email}');
      } else {
        print('User logged out');
        // Navigate to login screen
      }
    });
  }
  
  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        final user = snapshot.data;
        
        if (user == null) {
          return LoginScreen();
        }
        
        return HomeScreen(user: user);
      },
    );
  }
}
```

### 9. Logout

```dart
try {
  await AuthService().logout();
  print('Logged out successfully');
  // Navigate to login screen
} catch (e) {
  print('Logout error: $e');
}
```

### 10. Check Authentication Status

```dart
final isAuthenticated = await AuthService().isAuthenticated();
final hasValidToken = await AuthService().hasValidToken();

if (isAuthenticated && hasValidToken) {
  // User is logged in with valid token
  print('User is authenticated');
} else {
  // Redirect to login
  print('User needs to login');
}
```

## Error Handling

The service provides comprehensive error handling with custom exceptions:

### Exception Types

- `InvalidCredentialsException`: Wrong username/password
- `UnauthorizedException`: User not authenticated
- `TokenExpiredException`: Token has expired
- `AccountNotVerifiedException`: Account needs verification
- `AccountDisabledException`: Account is disabled
- `UserAlreadyExistsException`: User already exists
- `InvalidOtpException`: Invalid OTP code
- `ValidationException`: Request validation failed
- `NetworkException`: Network connectivity issues
- `ServerException`: Server-side errors
- `RateLimitException`: Too many requests

### User-Friendly Error Messages

```dart
try {
  await AuthService().login(username: 'user', password: 'wrong');
} on AuthException catch (e) {
  final userMessage = ErrorHandler.getUserFriendlyMessage(e);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Error'),
      content: Text(userMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    ),
  );
}
```

## Configuration

### Base URL
The service uses `https://protz-d3f3c6008874.herokuapp.com/api/v1` as the base URL.

### Token Storage
Tokens are stored using `SharedPreferences` with the following keys:
- `access_token`: JWT access token
- `token_type`: Token type (usually "Bearer")
- `refresh_token`: Refresh token (if available)
- `token_expires_at`: Token expiration timestamp
- `user_data`: Serialized user object

### Timeouts
- Connection timeout: 30 seconds
- Send timeout: 30 seconds
- Receive timeout: 30 seconds

## Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  dio: ^5.3.2
  shared_preferences: ^2.2.2
  json_annotation: ^4.8.1

dev_dependencies:
  json_serializable: ^6.7.1
  build_runner: ^2.4.7
```

## Migration from Old AuthService

If you have an existing `AuthService`, you can gradually migrate:

1. **Keep both services**: Use `new_auth_service.dart` alongside the old one
2. **Update imports**: Change imports to use the new service
3. **Update method calls**: The new service has the same method signatures
4. **Handle new exceptions**: Update error handling to use new exception types
5. **Test thoroughly**: Ensure all authentication flows work correctly

## Best Practices

1. **Initialize early**: Call `initialize()` in your app's main function
2. **Handle errors gracefully**: Always wrap auth calls in try-catch blocks
3. **Listen to user stream**: Use the user stream for reactive UI updates
4. **Check authentication**: Verify auth status before making protected API calls
5. **Dispose properly**: Call `dispose()` when the service is no longer needed
6. **Secure storage**: Consider using `flutter_secure_storage` for sensitive data in production

## Testing

The service is designed to be easily testable:

```dart
// Mock the dependencies for unit testing
class MockDioClient extends Mock implements DioClient {}
class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  group('AuthService Tests', () {
    late AuthService authService;
    late MockDioClient mockDioClient;
    late MockTokenStorage mockTokenStorage;
    
    setUp(() {
      mockDioClient = MockDioClient();
      mockTokenStorage = MockTokenStorage();
      // Inject mocks into AuthService
    });
    
    test('should login successfully', () async {
      // Test implementation
    });
  });
}
```

## Support

For issues or questions about the AuthService implementation, please refer to:
- API documentation: PROTZ backend API docs
- Flutter documentation: https://flutter.dev/docs
- Dio documentation: https://pub.dev/packages/dio