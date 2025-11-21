class LocationTracking {
  final String id;
  final String requestId;
  final String providerId;
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? speed;
  final double? heading;
  final double? altitude;
  final DateTime trackedAt;

  const LocationTracking({
    required this.id,
    required this.requestId,
    required this.providerId,
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.speed,
    this.heading,
    this.altitude,
    required this.trackedAt,
  });

  factory LocationTracking.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }
    return LocationTracking(
      id: (json['id'] ?? '').toString(),
      requestId: (json['request_id'] ?? '').toString(),
      providerId: (json['provider_id'] ?? '').toString(),
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      accuracy: json['accuracy'] == null ? null : _toDouble(json['accuracy']),
      speed: json['speed'] == null ? null : _toDouble(json['speed']),
      heading: json['heading'] == null ? null : _toDouble(json['heading']),
      altitude: json['altitude'] == null ? null : _toDouble(json['altitude']),
      trackedAt: DateTime.tryParse((json['tracked_at'] ?? '').toString()) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_id': requestId,
      'provider_id': providerId,
      'latitude': latitude,
      'longitude': longitude,
      if (accuracy != null) 'accuracy': accuracy,
      if (speed != null) 'speed': speed,
      if (heading != null) 'heading': heading,
      if (altitude != null) 'altitude': altitude,
      'tracked_at': trackedAt.toIso8601String(),
    };
  }
}