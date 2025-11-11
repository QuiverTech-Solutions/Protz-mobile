import 'package:json_annotation/json_annotation.dart';
import 'service_provider.dart';

part 'service_request.g.dart';

/// Model representing a service request (towing or water delivery)
/// 
/// This model encapsulates all information about service requests
/// including pickup/delivery details, status, and provider information.
@JsonSerializable()
class ServiceRequest {
  /// Unique identifier for the service request
  final String id;
  
  /// Type of service requested (towing, water_delivery)
  final String serviceType;
  
  /// Current status of the request
  final ServiceRequestStatus status;
  
  /// Customer ID who made the request
  final String customerId;
  
  /// Assigned service provider (if any)
  final ServiceProvider? assignedProvider;
  
  /// Pickup location details
  final LocationDetails pickupLocation;
  
  /// Destination location details (for towing)
  final LocationDetails? destinationLocation;
  
  /// Service-specific details
  final Map<String, dynamic> serviceDetails;
  
  /// Estimated cost
  final double? estimatedCost;
  
  /// Final cost (after service completion)
  final double? finalCost;
  
  /// Currency code
  final String currency;
  
  /// Request creation timestamp
  final DateTime createdAt;
  
  /// Last update timestamp
  final DateTime updatedAt;
  
  /// Estimated completion time
  final DateTime? estimatedCompletionTime;
  
  /// Actual completion time
  final DateTime? completedAt;
  
  /// Special instructions or notes
  final String? notes;
  
  /// Urgency level (low, medium, high, emergency)
  final String urgencyLevel;
  
  /// Payment status
  final PaymentStatus paymentStatus;
  
  /// Images related to the request
  final List<String>? imageUrls;

  const ServiceRequest({
    required this.id,
    required this.serviceType,
    required this.status,
    required this.customerId,
    this.assignedProvider,
    required this.pickupLocation,
    this.destinationLocation,
    required this.serviceDetails,
    this.estimatedCost,
    this.finalCost,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
    this.estimatedCompletionTime,
    this.completedAt,
    this.notes,
    required this.urgencyLevel,
    required this.paymentStatus,
    this.imageUrls,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) =>
      _$ServiceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceRequestToJson(this);
}

/// Location details model
@JsonSerializable()
class LocationDetails {
  /// Human-readable address
  final String address;
  
  /// Latitude coordinate
  final double latitude;
  
  /// Longitude coordinate
  final double longitude;
  
  /// Additional location notes
  final String? notes;
  
  /// Contact person at this location
  final String? contactPerson;
  
  /// Contact phone number
  final String? contactPhone;

  const LocationDetails({
    required this.address,
    required this.latitude,
    required this.longitude,
    this.notes,
    this.contactPerson,
    this.contactPhone,
  });

  factory LocationDetails.fromJson(Map<String, dynamic> json) =>
      _$LocationDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$LocationDetailsToJson(this);
}

/// Service request status enumeration
enum ServiceRequestStatus {
  @JsonValue('pending')
  pending,
  
  @JsonValue('confirmed')
  confirmed,
  
  @JsonValue('assigned')
  assigned,
  
  @JsonValue('in_progress')
  inProgress,
  
  @JsonValue('completed')
  completed,
  
  @JsonValue('cancelled')
  cancelled,
  
  @JsonValue('failed')
  failed,
}

/// Payment status enumeration
enum PaymentStatus {
  @JsonValue('pending')
  pending,
  
  @JsonValue('paid')
  paid,
  
  @JsonValue('failed')
  failed,
  
  @JsonValue('refunded')
  refunded,
}