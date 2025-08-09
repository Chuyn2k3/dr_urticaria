import 'package:flutter/material.dart';

enum AppointmentStatus {
  scheduled,
  waiting,
  inProgress,
  completed,
  cancelled,
}

class AppointmentModel {
  final String id;
  final String patientId;
  final String patientName;
  final String patientPhone;
  final String doctorId;
  final String doctorName;
  final String roomNumber;
  final DateTime appointmentTime;
  final DateTime appointmentDate; // Thêm field này
  final AppointmentStatus status;
  final String? notes;
  final bool isWalkIn;
  final DateTime createdAt;
  final DateTime? updatedAt; // Thêm field này

  AppointmentModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.patientPhone,
    required this.doctorId,
    required this.doctorName,
    required this.roomNumber,
    required this.appointmentTime,
    DateTime? appointmentDate, // Thêm parameter này
    required this.status,
    this.notes,
    this.isWalkIn = false,
    required this.createdAt,
    this.updatedAt, // Thêm parameter này
  }) : appointmentDate = appointmentDate ?? DateTime(appointmentTime.year, appointmentTime.month, appointmentTime.day);

  String get statusDisplayName {
    switch (status) {
      case AppointmentStatus.scheduled:
        return 'Đã đặt lịch';
      case AppointmentStatus.waiting:
        return 'Chờ khám';
      case AppointmentStatus.inProgress:
        return 'Đang khám';
      case AppointmentStatus.completed:
        return 'Hoàn thành';
      case AppointmentStatus.cancelled:
        return 'Đã hủy';
    }
  }

  Color get statusColor {
    switch (status) {
      case AppointmentStatus.scheduled:
        return Colors.blue;
      case AppointmentStatus.waiting:
        return Colors.orange;
      case AppointmentStatus.inProgress:
        return Colors.purple;
      case AppointmentStatus.completed:
        return Colors.green;
      case AppointmentStatus.cancelled:
        return Colors.red;
    }
  }

  AppointmentModel copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? patientPhone,
    String? doctorId,
    String? doctorName,
    String? roomNumber,
    DateTime? appointmentTime,
    DateTime? appointmentDate,
    AppointmentStatus? status,
    String? notes,
    bool? isWalkIn,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      patientPhone: patientPhone ?? this.patientPhone,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      roomNumber: roomNumber ?? this.roomNumber,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      isWalkIn: isWalkIn ?? this.isWalkIn,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
