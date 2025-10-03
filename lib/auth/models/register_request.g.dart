// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      userType: json['user_type'] as String,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      dateOfBirth: json['date_of_birth'] as String?,
      gender: json['gender'] as String?,
      primaryAddress: json['primary_address'] as String?,
      emergencyContactName: json['emergency_contact_name'] as String?,
      emergencyContactPhone: json['emergency_contact_phone'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      alternatePhone: json['alternate_phone'] as String?,
      middleName: json['middle_name'] as String?,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'user_type': instance.userType,
      'phone_number': instance.phoneNumber,
      'email': instance.email,
      'password': instance.password,
      if (instance.dateOfBirth case final value?) 'date_of_birth': value,
      if (instance.gender case final value?) 'gender': value,
      if (instance.primaryAddress case final value?) 'primary_address': value,
      if (instance.emergencyContactName case final value?)
        'emergency_contact_name': value,
      if (instance.emergencyContactPhone case final value?)
        'emergency_contact_phone': value,
      if (instance.profilePhotoUrl case final value?)
        'profile_photo_url': value,
      if (instance.city case final value?) 'city': value,
      if (instance.state case final value?) 'state': value,
      if (instance.alternatePhone case final value?) 'alternate_phone': value,
      if (instance.middleName case final value?) 'middle_name': value,
    };
