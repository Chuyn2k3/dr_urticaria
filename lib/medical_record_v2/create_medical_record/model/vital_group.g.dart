// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vital_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VitalGroup _$VitalGroupFromJson(Map<String, dynamic> json) => VitalGroup(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      indicators: (json['indicators'] as List<dynamic>)
          .map((e) => VitalIndicator.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$VitalGroupToJson(VitalGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'indicators': instance.indicators.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
