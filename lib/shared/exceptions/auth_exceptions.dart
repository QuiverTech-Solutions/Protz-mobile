/// Custom exceptions for authentication-related errors
class AuthException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;

  const AuthException(
    this.message, {
    this.code,
    this.statusCode,
  });

  @override
  String toString() => 'AuthException: $message';
}

/// Exception thrown when login credentials are invalid
class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException([String? message])
      : super(message ?? 'Invalid username or password', code: 'INVALID_CREDENTIALS');
}

/// Exception thrown when user is not authenticated
class UnauthorizedException extends AuthException {
  const UnauthorizedException([String? message])
      : super(message ?? 'User is not authenticated', code: 'UNAUTHORIZED');
}

/// Exception thrown when token has expired
class TokenExpiredException extends AuthException {
  const TokenExpiredException([String? message])
      : super(message ?? 'Authentication token has expired', code: 'TOKEN_EXPIRED');
}

/// Exception thrown when user account is not verified
class AccountNotVerifiedException extends AuthException {
  const AccountNotVerifiedException([String? message])
      : super(message ?? 'Account is not verified', code: 'ACCOUNT_NOT_VERIFIED');
}

/// Exception thrown when user account is disabled or suspended
class AccountDisabledException extends AuthException {
  const AccountDisabledException([String? message])
      : super(message ?? 'Account has been disabled', code: 'ACCOUNT_DISABLED');
}

/// Exception thrown when registration fails due to existing user
class UserAlreadyExistsException extends AuthException {
  const UserAlreadyExistsException([String? message])
      : super(message ?? 'User already exists with this email or phone', code: 'USER_EXISTS');
}

/// Exception thrown when OTP verification fails
class InvalidOtpException extends AuthException {
  const InvalidOtpException([String? message])
      : super(message ?? 'Invalid or expired OTP code', code: 'INVALID_OTP');
}

/// Exception thrown when password reset fails
class PasswordResetException extends AuthException {
  const PasswordResetException([String? message])
      : super(message ?? 'Password reset failed', code: 'PASSWORD_RESET_FAILED');
}

/// Exception thrown when network request fails
class NetworkException extends AuthException {
  const NetworkException([String? message])
      : super(message ?? 'Network connection failed', code: 'NETWORK_ERROR');
}

/// Exception thrown when server returns an error
class ServerException extends AuthException {
  const ServerException(String message, {int? statusCode})
      : super(message, code: 'SERVER_ERROR', statusCode: statusCode);
}

/// Exception thrown when request validation fails
class ValidationException extends AuthException {
  final Map<String, List<String>>? fieldErrors;

  const ValidationException(
    String message, {
    this.fieldErrors,
  }) : super(message, code: 'VALIDATION_ERROR');
}

/// Exception thrown when rate limit is exceeded
class RateLimitException extends AuthException {
  const RateLimitException([String? message])
      : super(message ?? 'Too many requests. Please try again later.', code: 'RATE_LIMIT');
}