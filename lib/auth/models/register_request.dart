import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable(includeIfNull: false)
class RegisterRequest {
  @JsonKey(name: 'first_name')
  final String firstName;
  
  @JsonKey(name: 'last_name')
  final String lastName;
  
  @JsonKey(name: 'user_type')
  final String userType;
  
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  
  final String email;
  
  final String password;
  
  @JsonKey(name: 'date_of_birth')
  final String? dateOfBirth;
  
  final String? gender;
  
  @JsonKey(name: 'primary_address')
  final String? primaryAddress;
  
  @JsonKey(name: 'emergency_contact_name')
  final String? emergencyContactName;
  
  @JsonKey(name: 'emergency_contact_phone')
  final String? emergencyContactPhone;
  
  @JsonKey(name: 'profile_photo_url')
  final String? profilePhotoUrl;
  
  final String? city;
  
  final String? state;
  
  @JsonKey(name: 'alternate_phone')
  final String? alternatePhone;
  
  @JsonKey(name: 'middle_name')
  final String? middleName;

  const RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.userType,
    required this.phoneNumber,
    required this.email,
    required this.password,
    this.dateOfBirth,
    this.gender,
    this.primaryAddress,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.profilePhotoUrl,
    this.city,
    this.state,
    this.alternatePhone,
    this.middleName,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);

  @override
  String toString() {
    return 'RegisterRequest(firstName: $firstName, lastName: $lastName, email: $email)';
  }
}