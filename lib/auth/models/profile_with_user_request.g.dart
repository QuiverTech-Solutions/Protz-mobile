// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_with_user_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileCreate _$ProfileCreateFromJson(Map<String, dynamic> json) =>
    ProfileCreate(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      middleName: json['middle_name'] as String?,
      userType: json['user_type'] as String,
      phoneNumber: json['phone_number'] as String,
      alternatePhone: json['alternate_phone'] as String?,
      email: json['email'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String,
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
      primaryAddress: json['primary_address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      gender: json['gender'] as String,
      emailVerified: json['email_verified'] as bool? ?? false,
      phoneVerified: json['phone_verified'] as bool? ?? true,
    );

Map<String, dynamic> _$ProfileCreateToJson(ProfileCreate instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      if (instance.middleName case final value?) 'middle_name': value,
      'user_type': instance.userType,
      'phone_number': instance.phoneNumber,
      if (instance.alternatePhone case final value?) 'alternate_phone': value,
      if (instance.email case final value?) 'email': value,
      'profile_photo_url': instance.profilePhotoUrl,
      if (instance.emergencyContactName case final value?)
        'emergency_contact_name': value,
      if (instance.emergencyContactPhone case final value?)
        'emergency_contact_phone': value,
      if (instance.primaryAddress case final value?) 'primary_address': value,
      if (instance.city case final value?) 'city': value,
      if (instance.state case final value?) 'state': value,
      if (instance.dateOfBirth case final value?) 'date_of_birth': value,
      'gender': instance.gender,
      'email_verified': instance.emailVerified,
      'phone_verified': instance.phoneVerified,
    };

UserCreate _$UserCreateFromJson(Map<String, dynamic> json) => UserCreate(
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String?,
      passwordHash: json['password_hash'] as String?,
      userType: json['user_type'] as String,
      emailVerified: json['email_verified'] as bool? ?? false,
      phoneVerified: json['phone_verified'] as bool? ?? true,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$UserCreateToJson(UserCreate instance) =>
    <String, dynamic>{
      'phone_number': instance.phoneNumber,
      if (instance.email case final value?) 'email': value,
      if (instance.passwordHash case final value?) 'password_hash': value,
      'user_type': instance.userType,
      'email_verified': instance.emailVerified,
      'phone_verified': instance.phoneVerified,
      'is_active': instance.isActive,
    };

ServiceProviderCreate _$ServiceProviderCreateFromJson(
        Map<String, dynamic> json) =>
    ServiceProviderCreate(
      businessName: json['business_name'] as String?,
      businessLicense: json['business_license'] as String?,
      serviceArea: json['service_area'] as String?,
      yearsOfExperience: (json['years_of_experience'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ServiceProviderCreateToJson(
        ServiceProviderCreate instance) =>
    <String, dynamic>{
      if (instance.businessName case final value?) 'business_name': value,
      if (instance.businessLicense case final value?) 'business_license': value,
      if (instance.serviceArea case final value?) 'service_area': value,
      if (instance.yearsOfExperience case final value?)
        'years_of_experience': value,
    };

ProfileWithUserRequest _$ProfileWithUserRequestFromJson(
        Map<String, dynamic> json) =>
    ProfileWithUserRequest(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      middleName: json['middle_name'] as String?,
      userType: json['user_type'] as String,
      phoneNumber: json['phone_number'] as String,
      alternatePhone: json['alternate_phone'] as String?,
      email: json['email'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String,
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
      primaryAddress: json['primary_address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      gender: json['gender'] as String,
      emailVerified: json['email_verified'] as bool? ?? false,
      phoneVerified: json['phone_verified'] as bool? ?? true,
      profile: ProfileCreate.fromJson(json['profile'] as Map<String, dynamic>),
      user: UserCreate.fromJson(json['user'] as Map<String, dynamic>),
      serviceProvider: json['service_provider'] == null
          ? null
          : ServiceProviderCreate.fromJson(
              json['service_provider'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileWithUserRequestToJson(
        ProfileWithUserRequest instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      if (instance.middleName case final value?) 'middle_name': value,
      'user_type': instance.userType,
      'phone_number': instance.phoneNumber,
      if (instance.alternatePhone case final value?) 'alternate_phone': value,
      if (instance.email case final value?) 'email': value,
      'profile_photo_url': instance.profilePhotoUrl,
      if (instance.emergencyContactName case final value?)
        'emergency_contact_name': value,
      if (instance.emergencyContactPhone case final value?)
        'emergency_contact_phone': value,
      if (instance.primaryAddress case final value?) 'primary_address': value,
      if (instance.city case final value?) 'city': value,
      if (instance.state case final value?) 'state': value,
      if (instance.dateOfBirth case final value?) 'date_of_birth': value,
      'gender': instance.gender,
      'email_verified': instance.emailVerified,
      'phone_verified': instance.phoneVerified,
      'profile': instance.profile,
      'user': instance.user,
      if (instance.serviceProvider case final value?) 'service_provider': value,
    };
