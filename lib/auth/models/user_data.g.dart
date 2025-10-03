// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      password: json['password'] as String,
      dateOfBirth: json['date_of_birth'] as String,
      gender: json['gender'] as String,
      address: json['address'] as String,
      emergencyContactName: json['emergency_contact_name'] as String,
      emergencyContactPhone: json['emergency_contact_phone'] as String,
      userType: json['user_type'] as String,
      serviceType: json['service_type'] as String?,
      vehicleType: json['vehicle_type'] as String?,
      licenseNumber: json['license_number'] as String?,
      yearsOfExperience: (json['years_of_experience'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'password': instance.password,
      'date_of_birth': instance.dateOfBirth,
      'gender': instance.gender,
      'address': instance.address,
      'emergency_contact_name': instance.emergencyContactName,
      'emergency_contact_phone': instance.emergencyContactPhone,
      'user_type': instance.userType,
      'service_type': instance.serviceType,
      'vehicle_type': instance.vehicleType,
      'license_number': instance.licenseNumber,
      'years_of_experience': instance.yearsOfExperience,
    };
