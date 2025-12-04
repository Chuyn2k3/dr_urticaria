// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_record_template_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalRecordTemplate _$MedicalRecordTemplateFromJson(
        Map<String, dynamic> json) =>
    MedicalRecordTemplate(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      notes: json['notes'] as String?,
      vitalGroupIds: (json['vitalGroupIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$MedicalRecordTemplateToJson(
        MedicalRecordTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'notes': instance.notes,
      'vitalGroupIds': instance.vitalGroupIds,
    };
