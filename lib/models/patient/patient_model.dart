import 'package:json_annotation/json_annotation.dart';

part 'patient_model.g.dart';

@JsonSerializable()
class PatientModel {
  final int id;
  final String fullname;
  final String? phone;
  final String? email;

  PatientModel({
    required this.id,
    required this.fullname,
    this.phone,
    this.email,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) =>
      _$PatientModelFromJson(json);
  Map<String, dynamic> toJson() => _$PatientModelToJson(this);
}
