// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_record_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalRecordListItem _$MedicalRecordListItemFromJson(
        Map<String, dynamic> json) =>
    MedicalRecordListItem(
      id: (json['id'] as num).toInt(),
      patientId: (json['patientId'] as num).toInt(),
      doctorId: (json['doctorId'] as num?)?.toInt(),
      diagnosis: json['diagnosis'] as String?,
      symptoms: json['symptoms'] as String?,
      notes: json['notes'] as String?,
      templateId: (json['templateId'] as num).toInt(),
      appointmentId: (json['appointmentId'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      patient: MedicalRecordPatient.fromJson(
          json['patient'] as Map<String, dynamic>),
      doctor: json['doctor'] == null
          ? null
          : MedicalRecordDoctor.fromJson(
              json['doctor'] as Map<String, dynamic>),
      template: MedicalRecordTemplate.fromJson(
          json['template'] as Map<String, dynamic>),
      appointment: json['appointment'] == null
          ? null
          : MedicalRecordAppointmentPreview.fromJson(
              json['appointment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MedicalRecordListItemToJson(
        MedicalRecordListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'doctorId': instance.doctorId,
      'diagnosis': instance.diagnosis,
      'symptoms': instance.symptoms,
      'notes': instance.notes,
      'templateId': instance.templateId,
      'appointmentId': instance.appointmentId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'patient': instance.patient,
      'doctor': instance.doctor,
      'template': instance.template,
      'appointment': instance.appointment,
    };

MedicalRecordPatient _$MedicalRecordPatientFromJson(
        Map<String, dynamic> json) =>
    MedicalRecordPatient(
      id: (json['id'] as num).toInt(),
      fullname: json['fullname'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$MedicalRecordPatientToJson(
        MedicalRecordPatient instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullname,
      'phone': instance.phone,
      'email': instance.email,
    };

MedicalRecordDoctor _$MedicalRecordDoctorFromJson(Map<String, dynamic> json) =>
    MedicalRecordDoctor(
      id: (json['id'] as num).toInt(),
      fullname: json['fullname'] as String,
      role: (json['role'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MedicalRecordDoctorToJson(
        MedicalRecordDoctor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullname,
      'role': instance.role,
    };

MedicalRecordTemplate _$MedicalRecordTemplateFromJson(
        Map<String, dynamic> json) =>
    MedicalRecordTemplate(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$MedicalRecordTemplateToJson(
        MedicalRecordTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'notes': instance.notes,
    };

MedicalRecordAppointmentPreview _$MedicalRecordAppointmentPreviewFromJson(
        Map<String, dynamic> json) =>
    MedicalRecordAppointmentPreview(
      id: (json['id'] as num).toInt(),
      reason: json['reason'] as String?,
      appointmentDate: DateTime.parse(json['appointmentDate'] as String),
      status: json['status'] as String,
    );

Map<String, dynamic> _$MedicalRecordAppointmentPreviewToJson(
        MedicalRecordAppointmentPreview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reason': instance.reason,
      'appointmentDate': instance.appointmentDate.toIso8601String(),
      'status': instance.status,
    };
