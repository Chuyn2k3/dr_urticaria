import 'package:dr_urticaria/models/doctor/doctor_model.dart';
import 'package:dr_urticaria/models/patient/patient_model.dart';
import 'package:dr_urticaria/utils/enum/appointment_enum.dart';
import 'package:json_annotation/json_annotation.dart';
part 'appointment_model.g.dart';

@JsonSerializable()
class AppointmentModel {
  final int id;
  final String reason;
  final DateTime appointmentDate;
  final AppointmentStatus status; // 🔥 đổi sang enum
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PatientModel patient;
  final DoctorModel? doctor;

  AppointmentModel({
    required this.id,
    required this.reason,
    required this.appointmentDate,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.patient,
    this.doctor,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentModelToJson(this);
}
