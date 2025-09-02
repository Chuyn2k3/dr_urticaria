// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vital_value_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VitalValueModel _$VitalValueModelFromJson(Map<String, dynamic> json) =>
    VitalValueModel(
      id: (json['id'] as num).toInt(),
      medicalRecordId: (json['medicalRecordId'] as num).toInt(),
      vitalIndicatorId: (json['vitalIndicatorId'] as num).toInt(),
      value: json['value'] == null
          ? null
          : VitalValueWrapper.fromJson(json['value'] as Map<String, dynamic>),
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$VitalValueModelToJson(VitalValueModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'medicalRecordId': instance.medicalRecordId,
      'vitalIndicatorId': instance.vitalIndicatorId,
      'value': instance.value?.toJson(),
      'note': instance.note,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

VitalValueWrapper _$VitalValueWrapperFromJson(Map<String, dynamic> json) =>
    VitalValueWrapper(
      value: json['value'],
    );

Map<String, dynamic> _$VitalValueWrapperToJson(VitalValueWrapper instance) =>
    <String, dynamic>{
      'value': instance.value,
    };
