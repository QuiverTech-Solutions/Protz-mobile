import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum UserRole { 
  @JsonValue('customer')
  customer, 
  @JsonValue('service_provider')
  serviceProvider, 
  @JsonValue('administrator')
  administrator 
}

@JsonSerializable()
class User {
  final String id;
  
  @JsonKey(name: 'first_name')
  final String? firstName;
  
  @JsonKey(name: 'last_name')
  final String? lastName;
  
  final String name;
  final String email;
  
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  
  @JsonKey(name: 'user_type')
  final UserRole role;
  
  @JsonKey(name: 'profile_image_url')
  final String? profileImageUrl;
  
  @JsonKey(name: 'date_of_birth')
  final String? dateOfBirth;
  
  final String? gender;
  final String? address;
  
  @JsonKey(name: 'emergency_contact_name')
  final String? emergencyContactName;
  
  @JsonKey(name: 'emergency_contact_phone')
  final String? emergencyContactPhone;
  
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  
  @JsonKey(name: 'is_active')
  final bool isActive;
  
  @JsonKey(name: 'is_available')
  final bool? isAvailable;
  
  @JsonKey(name: 'is_online')
  final bool? isOnline;

  const User({
    required this.id,
    this.firstName,
    this.lastName,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.profileImageUrl,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.emergencyContactName,
    this.emergencyContactPhone,
    required this.createdAt,
    required this.updatedAt,
    this.isVerified = false,
    this.isActive = true,
    this.isAvailable,
    this.isOnline,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? name,
    String? email,
    String? phoneNumber,
    UserRole? role,
    String? profileImageUrl,
    String? dateOfBirth,
    String? gender,
    String? address,
    String? emergencyContactName,
    String? emergencyContactPhone,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    bool? isActive,
    bool? isAvailable,
    bool? isOnline,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      isAvailable: isAvailable ?? this.isAvailable,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.name == name &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.role == role &&
        other.profileImageUrl == profileImageUrl &&
        other.dateOfBirth == dateOfBirth &&
        other.gender == gender &&
        other.address == address &&
        other.emergencyContactName == emergencyContactName &&
        other.emergencyContactPhone == emergencyContactPhone &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isVerified == isVerified &&
        other.isActive == isActive &&
        other.isAvailable == isAvailable &&
        other.isOnline == isOnline;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        role.hashCode ^
        profileImageUrl.hashCode ^
        dateOfBirth.hashCode ^
        gender.hashCode ^
        address.hashCode ^
        emergencyContactName.hashCode ^
        emergencyContactPhone.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        isVerified.hashCode ^
        isActive.hashCode ^
        isAvailable.hashCode ^
        isOnline.hashCode;
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, phoneNumber: $phoneNumber, role: $role, isVerified: $isVerified, isActive: $isActive)';
  }
}