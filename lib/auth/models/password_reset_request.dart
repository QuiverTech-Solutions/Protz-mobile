import 'package:json_annotation/json_annotation.dart';

part 'password_reset_request.g.dart';

@JsonSerializable()
class ForgotPasswordRequest {
  @JsonKey(name: 'email_or_phone')
  final String emailOrPhone;

  const ForgotPasswordRequest({
    required this.emailOrPhone,
  });

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);

  @override
  String toString() {
    return 'ForgotPasswordRequest(emailOrPhone: $emailOrPhone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ForgotPasswordRequest &&
        other.emailOrPhone == emailOrPhone;
  }

  @override
  int get hashCode {
    return emailOrPhone.hashCode;
  }
}

@JsonSerializable()
class ResetPasswordRequest {
  @JsonKey(name: 'user_id')
  final String userId;
  
  @JsonKey(name: 'otp_code')
  final String otpCode;
  
  @JsonKey(name: 'new_password')
  final String newPassword;

  const ResetPasswordRequest({
    required this.userId,
    required this.otpCode,
    required this.newPassword,
  });

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);

  @override
  String toString() {
    return 'ResetPasswordRequest(userId: $userId, otpCode: $otpCode, newPassword: [HIDDEN])';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResetPasswordRequest &&
        other.userId == userId &&
        other.otpCode == otpCode &&
        other.newPassword == newPassword;
  }

  @override
  int get hashCode {
    return userId.hashCode ^ otpCode.hashCode ^ newPassword.hashCode;
  }
}