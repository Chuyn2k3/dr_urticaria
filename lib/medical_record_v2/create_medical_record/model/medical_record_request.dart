import 'package:json_annotation/json_annotation.dart';

part 'medical_record_request.g.dart';

@JsonSerializable(explicitToJson: true)
class MedicalRecordRequest {
  final int templateId;
  final int patientId; // NEW

  // các trường tùy chọn, nếu API có dùng
  @JsonKey(includeIfNull: false)
  final int? doctorId;

  @JsonKey(includeIfNull: false)
  final int? appointmentId;

  @JsonKey(includeIfNull: false)
  final String? diagnosis;

  @JsonKey(includeIfNull: false)
  final String? symptoms;

  @JsonKey(includeIfNull: false)
  final String? notes;

  final List<VitalValueRequest> vitalValues;

  MedicalRecordRequest({
    required this.templateId,
    required this.patientId,
    required this.vitalValues,
    this.doctorId,
    this.appointmentId,
    this.diagnosis,
    this.symptoms,
    this.notes,
  });

  factory MedicalRecordRequest.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalRecordRequestToJson(this);
}

@JsonSerializable(explicitToJson: true)
class VitalValueRequest {
  final int vitalIndicatorId;
  final int groupId;

  /// API yêu cầu value là object { "value": ... } hoặc map phức tạp cho custom fields.
  final dynamic value;

  final String? note;

  VitalValueRequest({
    required this.vitalIndicatorId,
    required this.groupId,
    required this.value,
    this.note,
  });

  factory VitalValueRequest.fromJson(Map<String, dynamic> json) =>
      _$VitalValueRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VitalValueRequestToJson(this);
}
