// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceRequest _$ServiceRequestFromJson(Map<String, dynamic> json) =>
    ServiceRequest(
      id: json['id'] as String,
      serviceType: json['serviceType'] as String,
      status: $enumDecode(_$ServiceRequestStatusEnumMap, json['status']),
      customerId: json['customerId'] as String,
      assignedProvider: json['assignedProvider'] == null
          ? null
          : ServiceProvider.fromJson(
              json['assignedProvider'] as Map<String, dynamic>),
      pickupLocation: LocationDetails.fromJson(
          json['pickupLocation'] as Map<String, dynamic>),
      destinationLocation: json['destinationLocation'] == null
          ? null
          : LocationDetails.fromJson(
              json['destinationLocation'] as Map<String, dynamic>),
      serviceDetails: json['serviceDetails'] as Map<String, dynamic>,
      estimatedCost: (json['estimatedCost'] as num?)?.toDouble(),
      finalCost: (json['finalCost'] as num?)?.toDouble(),
      currency: json['currency'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      estimatedCompletionTime: json['estimatedCompletionTime'] == null
          ? null
          : DateTime.parse(json['estimatedCompletionTime'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      notes: json['notes'] as String?,
      urgencyLevel: json['urgencyLevel'] as String,
      paymentStatus: $enumDecode(_$PaymentStatusEnumMap, json['paymentStatus']),
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ServiceRequestToJson(ServiceRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'serviceType': instance.serviceType,
      'status': _$ServiceRequestStatusEnumMap[instance.status]!,
      'customerId': instance.customerId,
      'assignedProvider': instance.assignedProvider,
      'pickupLocation': instance.pickupLocation,
      'destinationLocation': instance.destinationLocation,
      'serviceDetails': instance.serviceDetails,
      'estimatedCost': instance.estimatedCost,
      'finalCost': instance.finalCost,
      'currency': instance.currency,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'estimatedCompletionTime':
          instance.estimatedCompletionTime?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'notes': instance.notes,
      'urgencyLevel': instance.urgencyLevel,
      'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'imageUrls': instance.imageUrls,
    };

const _$ServiceRequestStatusEnumMap = {
  ServiceRequestStatus.pending: 'pending',
  ServiceRequestStatus.confirmed: 'confirmed',
  ServiceRequestStatus.assigned: 'assigned',
  ServiceRequestStatus.inProgress: 'in_progress',
  ServiceRequestStatus.completed: 'completed',
  ServiceRequestStatus.cancelled: 'cancelled',
  ServiceRequestStatus.failed: 'failed',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.paid: 'paid',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
};

LocationDetails _$LocationDetailsFromJson(Map<String, dynamic> json) =>
    LocationDetails(
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      notes: json['notes'] as String?,
      contactPerson: json['contactPerson'] as String?,
      contactPhone: json['contactPhone'] as String?,
    );

Map<String, dynamic> _$LocationDetailsToJson(LocationDetails instance) =>
    <String, dynamic>{
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'notes': instance.notes,
      'contactPerson': instance.contactPerson,
      'contactPhone': instance.contactPhone,
    };
