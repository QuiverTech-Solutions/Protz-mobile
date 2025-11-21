// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceTypePublic _$ServiceTypePublicFromJson(Map<String, dynamic> json) =>
    ServiceTypePublic(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      icon: json['icon'] as String?,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$ServiceTypePublicToJson(ServiceTypePublic instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'icon': instance.icon,
      'isActive': instance.isActive,
    };
