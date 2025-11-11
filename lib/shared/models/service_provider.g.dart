// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceProvider _$ServiceProviderFromJson(Map<String, dynamic> json) =>
    ServiceProvider(
      id: json['id'] as String,
      name: json['name'] as String,
      serviceType: json['serviceType'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String?,
      address: json['address'] as String,
      currentLocation: json['currentLocation'] == null
          ? null
          : LocationCoordinates.fromJson(
              json['currentLocation'] as Map<String, dynamic>),
      serviceAreas: (json['serviceAreas'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      basePrice: (json['basePrice'] as num).toDouble(),
      pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
      currency: json['currency'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      estimatedArrival: (json['estimatedArrival'] as num?)?.toInt(),
      isAvailable: json['isAvailable'] as bool,
      profileImageUrl: json['profileImageUrl'] as String?,
      vehicles: (json['vehicles'] as List<dynamic>?)
          ?.map((e) => VehicleInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      operatingHours: json['operatingHours'] == null
          ? null
          : OperatingHours.fromJson(
              json['operatingHours'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ServiceProviderToJson(ServiceProvider instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'serviceType': instance.serviceType,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'address': instance.address,
      'currentLocation': instance.currentLocation,
      'serviceAreas': instance.serviceAreas,
      'basePrice': instance.basePrice,
      'pricePerUnit': instance.pricePerUnit,
      'currency': instance.currency,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'estimatedArrival': instance.estimatedArrival,
      'isAvailable': instance.isAvailable,
      'profileImageUrl': instance.profileImageUrl,
      'vehicles': instance.vehicles,
      'operatingHours': instance.operatingHours,
    };

LocationCoordinates _$LocationCoordinatesFromJson(Map<String, dynamic> json) =>
    LocationCoordinates(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationCoordinatesToJson(
        LocationCoordinates instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

VehicleInfo _$VehicleInfoFromJson(Map<String, dynamic> json) => VehicleInfo(
      id: json['id'] as String,
      type: json['type'] as String,
      model: json['model'] as String,
      licensePlate: json['licensePlate'] as String,
      capacity: (json['capacity'] as num).toInt(),
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$VehicleInfoToJson(VehicleInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'model': instance.model,
      'licensePlate': instance.licensePlate,
      'capacity': instance.capacity,
      'imageUrl': instance.imageUrl,
    };

OperatingHours _$OperatingHoursFromJson(Map<String, dynamic> json) =>
    OperatingHours(
      openTime: json['openTime'] as String,
      closeTime: json['closeTime'] as String,
      workingDays: (json['workingDays'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      is24Hours: json['is24Hours'] as bool,
    );

Map<String, dynamic> _$OperatingHoursToJson(OperatingHours instance) =>
    <String, dynamic>{
      'openTime': instance.openTime,
      'closeTime': instance.closeTime,
      'workingDays': instance.workingDays,
      'is24Hours': instance.is24Hours,
    };
