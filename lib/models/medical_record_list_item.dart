import 'package:json_annotation/json_annotation.dart';

part 'medical_record_list_item.g.dart';

@JsonSerializable()
class MedicalRecordListItem {
  final int id;
  final int patientId;
  final int? doctorId;
  final String? diagnosis;
  final String? symptoms;
  final String? notes;
  final int templateId;
  final int? appointmentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MedicalRecordPatient patient;
  final MedicalRecordDoctor? doctor;
  final MedicalRecordTemplate template;
  final MedicalRecordAppointmentPreview? appointment;

  MedicalRecordListItem({
    required this.id,
    required this.patientId,
    this.doctorId,
    this.diagnosis,
    this.symptoms,
    this.notes,
    required this.templateId,
    this.appointmentId,
    required this.createdAt,
    required this.updatedAt,
    required this.patient,
    this.doctor,
    required this.template,
    this.appointment,
  });

  factory MedicalRecordListItem.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordListItemFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalRecordListItemToJson(this);
}

@JsonSerializable()
class MedicalRecordPatient {
  final int id;
  final String fullname;
  final String? phone;
  final String? email;

  MedicalRecordPatient({
    required this.id,
    required this.fullname,
    this.phone,
    this.email,
  });

  factory MedicalRecordPatient.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordPatientFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalRecordPatientToJson(this);
}

@JsonSerializable()
class MedicalRecordDoctor {
  final int id;
  final String fullname;
  final int? role;

  MedicalRecordDoctor({
    required this.id,
    required this.fullname,
    this.role,
  });

  factory MedicalRecordDoctor.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordDoctorFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalRecordDoctorToJson(this);
}

@JsonSerializable()
class MedicalRecordTemplate {
  final int id;
  final String name;
  final String? notes;

  MedicalRecordTemplate({
    required this.id,
    required this.name,
    this.notes,
  });

  factory MedicalRecordTemplate.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordTemplateFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalRecordTemplateToJson(this);
}

@JsonSerializable()
class MedicalRecordAppointmentPreview {
  final int id;
  final String? reason;
  final DateTime appointmentDate;
  final String status;

  MedicalRecordAppointmentPreview({
    required this.id,
    this.reason,
    required this.appointmentDate,
    required this.status,
  });

  factory MedicalRecordAppointmentPreview.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordAppointmentPreviewFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MedicalRecordAppointmentPreviewToJson(this);
}
