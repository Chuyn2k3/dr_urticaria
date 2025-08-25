// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_submission_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormSubmissionResponse _$FormSubmissionResponseFromJson(
        Map<String, dynamic> json) =>
    FormSubmissionResponse(
      id: json['id'] as String,
      formType: json['formType'] as String,
      status: json['status'] as String,
      patientId: json['patientId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      doctorId: json['doctorId'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$FormSubmissionResponseToJson(
        FormSubmissionResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'formType': instance.formType,
      'status': instance.status,
      'patientId': instance.patientId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'doctorId': instance.doctorId,
      'notes': instance.notes,
    };
