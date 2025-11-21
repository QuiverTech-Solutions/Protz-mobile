import 'package:json_annotation/json_annotation.dart';

part 'towing_type.g.dart';

@JsonSerializable()
class TowingTypePublic {
  final String id;
  final String name;
  final String code;
  final bool isActive;

  const TowingTypePublic({
    required this.id,
    required this.name,
    required this.code,
    required this.isActive,
  });

  factory TowingTypePublic.fromJson(Map<String, dynamic> json) => _$TowingTypePublicFromJson(json);
  Map<String, dynamic> toJson() => _$TowingTypePublicToJson(this);
}