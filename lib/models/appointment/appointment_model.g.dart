// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentModel _$AppointmentModelFromJson(Map<String, dynamic> json) =>
    AppointmentModel(
      id: (json['id'] as num).toInt(),
      reason: json['reason'] as String,
      appointmentDate: DateTime.parse(json['appointmentDate'] as String),
      status: $enumDecode(_$AppointmentStatusEnumMap, json['status']),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      patient: PatientModel.fromJson(json['patient'] as Map<String, dynamic>),
      doctor: json['doctor'] == null
          ? null
          : DoctorModel.fromJson(json['doctor'] as Map<String, dynamic>),
      medicalRecords: (json['medicalRecords'] as List<dynamic>?)
          ?.map((e) => MedicalRecordModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AppointmentModelToJson(AppointmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reason': instance.reason,
      'appointmentDate': instance.appointmentDate.toIso8601String(),
      'status': _$AppointmentStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'patient': instance.patient,
      'doctor': instance.doctor,
      'medicalRecords': instance.medicalRecords,
    };

const _$AppointmentStatusEnumMap = {
  AppointmentStatus.pending: 'PENDING',
  AppointmentStatus.confirmed: 'CONFIRMED',
  AppointmentStatus.cancelled: 'CANCELLED',
  AppointmentStatus.completed: 'COMPLETED',
};

MedicalRecordModel _$MedicalRecordModelFromJson(Map<String, dynamic> json) =>
    MedicalRecordModel(
      id: (json['id'] as num).toInt(),
      patientId: (json['patientId'] as num?)?.toInt(),
      doctorId: (json['doctorId'] as num?)?.toInt(),
      diagnosis: json['diagnosis'] as String?,
      symptoms: json['symptoms'] as String?,
      notes: json['notes'] as String?,
      templateId: (json['templateId'] as num?)?.toInt(),
      appointmentId: (json['appointmentId'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      patient: json['patient'] == null
          ? null
          : PatientModel.fromJson(json['patient'] as Map<String, dynamic>),
      doctor: json['doctor'] == null
          ? null
          : DoctorModel.fromJson(json['doctor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MedicalRecordModelToJson(MedicalRecordModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'doctorId': instance.doctorId,
      'diagnosis': instance.diagnosis,
      'symptoms': instance.symptoms,
      'notes': instance.notes,
      'templateId': instance.templateId,
      'appointmentId': instance.appointmentId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'patient': instance.patient,
      'doctor': instance.doctor,
    };
