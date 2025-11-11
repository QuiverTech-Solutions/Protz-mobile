import 'package:json_annotation/json_annotation.dart';

part 'service_provider.g.dart';

/// Model representing a service provider (towing or water delivery)
/// 
/// This model encapsulates all information about service providers
/// including their details, pricing, availability, and ratings.
@JsonSerializable()
class ServiceProvider {
  /// Unique identifier for the service provider
  final String id;
  
  /// Name of the service provider
  final String name;
  
  /// Type of service (towing, water_delivery)
  final String serviceType;
  
  /// Provider's phone number
  final String phoneNumber;
  
  /// Provider's email address
  final String? email;
  
  /// Provider's physical address
  final String address;
  
  /// Current location coordinates
  final LocationCoordinates? currentLocation;
  
  /// Service area coverage
  final List<String> serviceAreas;
  
  /// Base price for the service
  final double basePrice;
  
  /// Price per kilometer/unit
  final double pricePerUnit;
  
  /// Currency code (e.g., GHS, USD)
  final String currency;
  
  /// Provider's rating (0.0 to 5.0)
  final double rating;
  
  /// Number of reviews
  final int reviewCount;
  
  /// Estimated time of arrival in minutes
  final int? estimatedArrival;
  
  /// Whether the provider is currently available
  final bool isAvailable;
  
  /// Provider's profile image URL
  final String? profileImageUrl;
  
  /// Vehicle/equipment details
  final List<VehicleInfo>? vehicles;
  
  /// Operating hours
  final OperatingHours? operatingHours;

  const ServiceProvider({
    required this.id,
    required this.name,
    required this.serviceType,
    required this.phoneNumber,
    this.email,
    required this.address,
    this.currentLocation,
    required this.serviceAreas,
    required this.basePrice,
    required this.pricePerUnit,
    required this.currency,
    required this.rating,
    required this.reviewCount,
    this.estimatedArrival,
    required this.isAvailable,
    this.profileImageUrl,
    this.vehicles,
    this.operatingHours,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) =>
      _$ServiceProviderFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceProviderToJson(this);
}

/// Location coordinates model
@JsonSerializable()
class LocationCoordinates {
  final double latitude;
  final double longitude;

  const LocationCoordinates({
    required this.latitude,
    required this.longitude,
  });

  factory LocationCoordinates.fromJson(Map<String, dynamic> json) =>
      _$LocationCoordinatesFromJson(json);

  Map<String, dynamic> toJson() => _$LocationCoordinatesToJson(this);
}

/// Vehicle information model
@JsonSerializable()
class VehicleInfo {
  final String id;
  final String type;
  final String model;
  final String licensePlate;
  final int capacity;
  final String? imageUrl;

  const VehicleInfo({
    required this.id,
    required this.type,
    required this.model,
    required this.licensePlate,
    required this.capacity,
    this.imageUrl,
  });

  factory VehicleInfo.fromJson(Map<String, dynamic> json) =>
      _$VehicleInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleInfoToJson(this);
}

/// Operating hours model
@JsonSerializable()
class OperatingHours {
  final String openTime;
  final String closeTime;
  final List<String> workingDays;
  final bool is24Hours;

  const OperatingHours({
    required this.openTime,
    required this.closeTime,
    required this.workingDays,
    required this.is24Hours,
  });

  factory OperatingHours.fromJson(Map<String, dynamic> json) =>
      _$OperatingHoursFromJson(json);

  Map<String, dynamic> toJson() => _$OperatingHoursToJson(this);
}