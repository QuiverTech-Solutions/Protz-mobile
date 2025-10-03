import 'package:json_annotation/json_annotation.dart';

part 'update_user_request.g.dart';

@JsonSerializable()
class UpdateUserRequest {
  final String? email;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String? password;
  @JsonKey(name: 'is_available')
  final bool? isAvailable;
  @JsonKey(name: 'is_online')
  final bool? isOnline;
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  final String? address;
  @JsonKey(name: 'emergency_contact_name')
  final String? emergencyContactName;
  @JsonKey(name: 'emergency_contact_phone')
  final String? emergencyContactPhone;

  const UpdateUserRequest({
    this.email,
    this.phoneNumber,
    this.password,
    this.isAvailable,
    this.isOnline,
    this.firstName,
    this.lastName,
    this.address,
    this.emergencyContactName,
    this.emergencyContactPhone,
  });

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserRequestToJson(this);

  UpdateUserRequest copyWith({
    String? email,
    String? phoneNumber,
    String? password,
    bool? isAvailable,
    bool? isOnline,
    String? firstName,
    String? lastName,
    String? address,
    String? emergencyContactName,
    String? emergencyContactPhone,
  }) {
    return UpdateUserRequest(
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      isAvailable: isAvailable ?? this.isAvailable,
      isOnline: isOnline ?? this.isOnline,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
    );
  }

  @override
  String toString() {
    return 'UpdateUserRequest(email: $email, phoneNumber: $phoneNumber, isAvailable: $isAvailable, isOnline: $isOnline, firstName: $firstName, lastName: $lastName, address: $address, emergencyContactName: $emergencyContactName, emergencyContactPhone: $emergencyContactPhone)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UpdateUserRequest &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.password == password &&
        other.isAvailable == isAvailable &&
        other.isOnline == isOnline &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.address == address &&
        other.emergencyContactName == emergencyContactName &&
        other.emergencyContactPhone == emergencyContactPhone;
  }

  @override
  int get hashCode {
    return Object.hash(
      email,
      phoneNumber,
      password,
      isAvailable,
      isOnline,
      firstName,
      lastName,
      address,
      emergencyContactName,
      emergencyContactPhone,
    );
  }
}