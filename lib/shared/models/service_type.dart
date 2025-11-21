import 'package:json_annotation/json_annotation.dart';

part 'service_type.g.dart';

@JsonSerializable()
class ServiceTypePublic {
  final String id;
  final String name;
  final String code;
  final String? icon;
  final bool isActive;

  const ServiceTypePublic({
    required this.id,
    required this.name,
    required this.code,
    this.icon,
    required this.isActive,
  });

  factory ServiceTypePublic.fromJson(Map<String, dynamic> json) => _$ServiceTypePublicFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceTypePublicToJson(this);
}