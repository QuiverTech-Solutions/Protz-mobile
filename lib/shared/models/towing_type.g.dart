// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'towing_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TowingTypePublic _$TowingTypePublicFromJson(Map<String, dynamic> json) =>
    TowingTypePublic(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$TowingTypePublicToJson(TowingTypePublic instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'isActive': instance.isActive,
    };
