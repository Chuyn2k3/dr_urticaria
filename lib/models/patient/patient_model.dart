import 'package:json_annotation/json_annotation.dart';

part 'patient_model.g.dart';

@JsonSerializable()
class PatientModel {
  final int id;
  final String fullname;
  final String? phone;
  final String? email;
  final DateTime? birthday;
  final String? gender;
  final String? address;
  final String? identityNumber;

  // nếu cần thêm createdAt, updatedAt, isActive... thì bổ sung tiếp
  PatientModel({
    required this.id,
    required this.fullname,
    this.phone,
    this.email,
    this.birthday,
    this.gender,
    this.address,
    this.identityNumber,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) =>
      _$PatientModelFromJson(json);

  Map<String, dynamic> toJson() => _$PatientModelToJson(this);
}
