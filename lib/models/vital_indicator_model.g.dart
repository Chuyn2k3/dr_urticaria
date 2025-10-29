// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vital_indicator_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VitalIndicator _$VitalIndicatorFromJson(Map<String, dynamic> json) =>
    VitalIndicator(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      unit: json['unit'] as String?,
      description: json['description'] as String?,
      valueType: json['valueType'] as String,
      valueOptions: VitalIndicator._fromDynamic(json['valueOptions']),
      visibility: (json['visibility'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      minValue: json['minValue'] as String?,
      maxValue: json['maxValue'] as String?,
      isActive: json['isActive'] as bool,
      groupId: (json['groupId'] as num?)?.toInt(),
      group: json['group'] == null
          ? null
          : VitalGroupInfo.fromJson(json['group'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$VitalIndicatorToJson(VitalIndicator instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'unit': instance.unit,
      'description': instance.description,
      'valueType': instance.valueType,
      'valueOptions': VitalIndicator._toDynamic(instance.valueOptions),
      'visibility': instance.visibility,
      'minValue': instance.minValue,
      'maxValue': instance.maxValue,
      'isActive': instance.isActive,
      'groupId': instance.groupId,
      'group': instance.group?.toJson(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

VitalGroupInfo _$VitalGroupInfoFromJson(Map<String, dynamic> json) =>
    VitalGroupInfo(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$VitalGroupInfoToJson(VitalGroupInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
