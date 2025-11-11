import 'package:json_annotation/json_annotation.dart';

part 'profile_with_user_request.g.dart';

@JsonSerializable(includeIfNull: false)
class ProfileCreate {
  @JsonKey(name: 'first_name')
  final String firstName;
  
  @JsonKey(name: 'last_name')
  final String lastName;
  
  @JsonKey(name: 'middle_name')
  final String? middleName;
  
  @JsonKey(name: 'user_type')
  final String userType;
  
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  
  @JsonKey(name: 'alternate_phone')
  final String? alternatePhone;
  
  final String? email;
  
  @JsonKey(name: 'profile_photo_url')
  final String profilePhotoUrl;
  
  @JsonKey(name: 'emergency_contact_name')
  final String? emergencyContactName;
  
  @JsonKey(name: 'emergency_contact_phone')
  final String? emergencyContactPhone;
  
  @JsonKey(name: 'primary_address')
  final String? primaryAddress;
  
  final String? city;
  
  final String? state;
  
  @JsonKey(name: 'date_of_birth')
  final String? dateOfBirth;
  
  final String gender;
  
  @JsonKey(name: 'email_verified')
  final bool emailVerified;
  
  @JsonKey(name: 'phone_verified')
  final bool phoneVerified;

  const ProfileCreate({
    required this.firstName,
    required this.lastName,
    this.middleName,
    required this.userType,
    required this.phoneNumber,
    this.alternatePhone,
    this.email,
    required this.profilePhotoUrl,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.primaryAddress,
    this.city,
    this.state,
    this.dateOfBirth,
    required this.gender,
    this.emailVerified = false,
    this.phoneVerified = true,
  });

  factory ProfileCreate.fromJson(Map<String, dynamic> json) =>
      _$ProfileCreateFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileCreateToJson(this);
}

@JsonSerializable(includeIfNull: false)
class UserCreate {
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  
  final String? email;
  
  @JsonKey(name: 'password_hash')
  final String? passwordHash;
  
  @JsonKey(name: 'user_type')
  final String userType;
  
  @JsonKey(name: 'email_verified')
  final bool emailVerified;
  
  @JsonKey(name: 'phone_verified')
  final bool phoneVerified;
  
  @JsonKey(name: 'is_active')
  final bool isActive;

  const UserCreate({
    required this.phoneNumber,
    this.email,
    this.passwordHash,
    required this.userType,
    this.emailVerified = false,
    this.phoneVerified = true,
    this.isActive = true,
  });

  factory UserCreate.fromJson(Map<String, dynamic> json) =>
      _$UserCreateFromJson(json);

  Map<String, dynamic> toJson() => _$UserCreateToJson(this);
}

@JsonSerializable(includeIfNull: false)
class ServiceProviderCreate {
  @JsonKey(name: 'business_name')
  final String? businessName;
  
  @JsonKey(name: 'business_license')
  final String? businessLicense;
  
  @JsonKey(name: 'service_area')
  final String? serviceArea;
  
  @JsonKey(name: 'years_of_experience')
  final int? yearsOfExperience;

  const ServiceProviderCreate({
    this.businessName,
    this.businessLicense,
    this.serviceArea,
    this.yearsOfExperience,
  });

  factory ServiceProviderCreate.fromJson(Map<String, dynamic> json) =>
      _$ServiceProviderCreateFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceProviderCreateToJson(this);
}

@JsonSerializable(includeIfNull: false)
class ProfileWithUserRequest {
  @JsonKey(name: 'first_name')
  final String firstName;
  
  @JsonKey(name: 'last_name')
  final String lastName;
  
  @JsonKey(name: 'middle_name')
  final String? middleName;
  
  @JsonKey(name: 'user_type')
  final String userType;
  
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  
  @JsonKey(name: 'alternate_phone')
  final String? alternatePhone;
  
  final String? email;
  
  @JsonKey(name: 'profile_photo_url')
  final String profilePhotoUrl;
  
  @JsonKey(name: 'emergency_contact_name')
  final String? emergencyContactName;
  
  @JsonKey(name: 'emergency_contact_phone')
  final String? emergencyContactPhone;
  
  @JsonKey(name: 'primary_address')
  final String? primaryAddress;
  
  final String? city;
  
  final String? state;
  
  @JsonKey(name: 'date_of_birth')
  final String? dateOfBirth;
  
  final String gender;
  
  @JsonKey(name: 'email_verified')
  final bool emailVerified;
  
  @JsonKey(name: 'phone_verified')
  final bool phoneVerified;
  
  final ProfileCreate profile;
  
  final UserCreate user;
  
  @JsonKey(name: 'service_provider')
  final ServiceProviderCreate? serviceProvider;
  
  // Password field for client-side use (not sent to API)
  @JsonKey(includeToJson: false, includeFromJson: false)
  final String? password;

  const ProfileWithUserRequest({
    required this.firstName,
    required this.lastName,
    this.middleName,
    required this.userType,
    required this.phoneNumber,
    this.alternatePhone,
    this.email,
    required this.profilePhotoUrl,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.primaryAddress,
    this.city,
    this.state,
    this.dateOfBirth,
    required this.gender,
    this.emailVerified = false,
    this.phoneVerified = true,
    required this.profile,
    required this.user,
    this.serviceProvider,
    this.password,
  });

  factory ProfileWithUserRequest.fromJson(Map<String, dynamic> json) =>
      _$ProfileWithUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileWithUserRequestToJson(this);

  // Factory constructor to create from simple form data
  factory ProfileWithUserRequest.fromFormData({
    required String firstName,
    required String lastName,
    String? middleName,
    required String userType,
    required String phoneNumber,
    String? alternatePhone,
    String? email,
    String? profilePhotoUrl,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? primaryAddress,
    String? city,
    String? state,
    String? dateOfBirth,
    required String gender,
    String? password,
    bool emailVerified = false,
    bool phoneVerified = true,
    ServiceProviderCreate? serviceProvider,
  }) {
    final profile = ProfileCreate(
      firstName: firstName,
      lastName: lastName,
      middleName: middleName,
      userType: userType,
      phoneNumber: phoneNumber,
      alternatePhone: alternatePhone,
      email: email,
      profilePhotoUrl: profilePhotoUrl ?? "",
      emergencyContactName: emergencyContactName,
      emergencyContactPhone: emergencyContactPhone,
      primaryAddress: primaryAddress,
      city: city,
      state: state,
      dateOfBirth: dateOfBirth,
      gender: gender,
      emailVerified: emailVerified,
      phoneVerified: phoneVerified,
    );

    final user = UserCreate(
      phoneNumber: phoneNumber,
      email: email,
      passwordHash: null, // Will be handled by backend
      userType: userType,
      emailVerified: emailVerified,
      phoneVerified: phoneVerified,
      isActive: true,
    );

    return ProfileWithUserRequest(
      firstName: firstName,
      lastName: lastName,
      middleName: middleName,
      userType: userType,
      phoneNumber: phoneNumber,
      alternatePhone: alternatePhone,
      email: email,
      profilePhotoUrl: profilePhotoUrl ?? "",
      emergencyContactName: emergencyContactName,
      emergencyContactPhone: emergencyContactPhone,
      primaryAddress: primaryAddress,
      city: city,
      state: state,
      dateOfBirth: dateOfBirth,
      gender: gender,
      emailVerified: emailVerified,
      phoneVerified: phoneVerified,
      profile: profile,
      user: user,
      serviceProvider: serviceProvider,
      password: password,
    );
  }

  @override
  String toString() {
    return 'ProfileWithUserRequest(firstName: $firstName, lastName: $lastName, email: $email, userType: $userType)';
  }
}