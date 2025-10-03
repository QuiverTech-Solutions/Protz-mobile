import 'package:json_annotation/json_annotation.dart';

part 'otp_request.g.dart';

@JsonSerializable()
class OtpRequest {
  @JsonKey(name: 'user_id')
  final String userId;
  
  @JsonKey(name: 'otp_code')
  final String otpCode;

  const OtpRequest({
    required this.userId,
    required this.otpCode,
  });

  factory OtpRequest.fromJson(Map<String, dynamic> json) =>
      _$OtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$OtpRequestToJson(this);

  @override
  String toString() {
    return 'OtpRequest(userId: $userId, otpCode: $otpCode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OtpRequest &&
        other.userId == userId &&
        other.otpCode == otpCode;
  }

  @override
  int get hashCode {
    return userId.hashCode ^ otpCode.hashCode;
  }
}