import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  @JsonKey(name: 'first_name')
  final String firstName;
  
  @JsonKey(name: 'last_name')
  final String lastName;
  
  final String email;
  
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  
  final String password;
  
  @JsonKey(name: 'date_of_birth')
  final String dateOfBirth;
  
  final String gender;
  
  final String address;
  
  @JsonKey(name: 'emergency_contact_name')
  final String emergencyContactName;
  
  @JsonKey(name: 'emergency_contact_phone')
  final String emergencyContactPhone;
  
  @JsonKey(name: 'user_type')
  final String userType;
  
  // Optional provider-specific fields
  @JsonKey(name: 'service_type')
  final String? serviceType;
  
  @JsonKey(name: 'vehicle_type')
  final String? vehicleType;
  
  @JsonKey(name: 'license_number')
  final String? licenseNumber;
  
  @JsonKey(name: 'years_of_experience')
  final int? yearsOfExperience;

  const UserData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.userType,
    this.serviceType,
    this.vehicleType,
    this.licenseNumber,
    this.yearsOfExperience,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  @override
  String toString() {
    return 'UserData(firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, userType: $userType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserData &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.password == password &&
        other.dateOfBirth == dateOfBirth &&
        other.gender == gender &&
        other.address == address &&
        other.emergencyContactName == emergencyContactName &&
        other.emergencyContactPhone == emergencyContactPhone &&
        other.userType == userType &&
        other.serviceType == serviceType &&
        other.vehicleType == vehicleType &&
        other.licenseNumber == licenseNumber &&
        other.yearsOfExperience == yearsOfExperience;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        password.hashCode ^
        dateOfBirth.hashCode ^
        gender.hashCode ^
        address.hashCode ^
        emergencyContactName.hashCode ^
        emergencyContactPhone.hashCode ^
        userType.hashCode ^
        serviceType.hashCode ^
        vehicleType.hashCode ^
        licenseNumber.hashCode ^
        yearsOfExperience.hashCode;
  }
}