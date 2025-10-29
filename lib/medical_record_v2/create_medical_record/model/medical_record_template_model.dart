import 'package:json_annotation/json_annotation.dart';

part 'medical_record_template_model.g.dart';

@JsonSerializable()
class MedicalRecordTemplate {
  final int id;
  final String name;
  final String? notes;
  final List<int> vitalGroupIds;

  MedicalRecordTemplate({
    required this.id,
    required this.name,
    this.notes,
    required this.vitalGroupIds,
  });

  factory MedicalRecordTemplate.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordTemplateFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalRecordTemplateToJson(this);
}
