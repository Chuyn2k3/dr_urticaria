import 'package:json_annotation/json_annotation.dart';

part 'form_submission_response.g.dart';

@JsonSerializable()
class FormSubmissionResponse {
  final String id;
  final String formType;
  final String status;
  final String patientId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? doctorId;
  final String? notes;

  const FormSubmissionResponse({
    required this.id,
    required this.formType,
    required this.status,
    required this.patientId,
    required this.createdAt,
    this.updatedAt,
    this.doctorId,
    this.notes,
  });

  factory FormSubmissionResponse.fromJson(Map<String, dynamic> json) =>
      _$FormSubmissionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FormSubmissionResponseToJson(this);
}
