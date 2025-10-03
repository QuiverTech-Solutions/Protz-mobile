import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  @JsonKey(name: 'first_name')
  final String firstName;
  
  @JsonKey(name: 'last_name')
  final String lastName;
  
  @JsonKey(name: 'user_type')
  final String userType;
  
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  
  @JsonKey(name: 'profile_photo_url')
  final String profilePhotoUrl;
  
  final String gender;

  const UserProfile({
    required this.firstName,
    required this.lastName,
    required this.userType,
    required this.phoneNumber,
    required this.profilePhotoUrl,
    required this.gender,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  @override
  String toString() {
    return 'UserProfile(firstName: $firstName, lastName: $lastName, userType: $userType, phoneNumber: $phoneNumber, gender: $gender)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.userType == userType &&
        other.phoneNumber == phoneNumber &&
        other.profilePhotoUrl == profilePhotoUrl &&
        other.gender == gender;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        userType.hashCode ^
        phoneNumber.hashCode ^
        profilePhotoUrl.hashCode ^
        gender.hashCode;
  }
}