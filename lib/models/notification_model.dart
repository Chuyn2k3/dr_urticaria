import 'package:flutter/material.dart';

enum NotificationType {
  medicalRecordApproved, // bệnh án được duyệt
  patientDirected, // bệnh nhân được điều hướng
  testResultReady, // kết quả xét nghiệm
  appointmentReminder, // nhắc nhở lịch hẹn
  roomAssignment,
  testOrder,
  testResult,
  prescription,
  general, // thông báo chung
}

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.isRead = false,
    required this.createdAt,
    this.data,
  });

  IconData get icon {
    switch (type) {
      case NotificationType.medicalRecordApproved:
        return Icons.check_circle;
      case NotificationType.patientDirected:
        return Icons.directions;
      case NotificationType.testResultReady:
        return Icons.science;
      case NotificationType.appointmentReminder:
        return Icons.schedule;
      case NotificationType.roomAssignment:
        return Icons.meeting_room;
      case NotificationType.testOrder:
        return Icons.request_quote;
      case NotificationType.testResult:
        return Icons.science_outlined;
      case NotificationType.prescription:
        return Icons.medication;
      case NotificationType.general:
        return Icons.info;
    }
  }

  Color get color {
    switch (type) {
      case NotificationType.medicalRecordApproved:
        return Colors.green;
      case NotificationType.patientDirected:
        return Colors.blue;
      case NotificationType.testResultReady:
        return Colors.orange;
      case NotificationType.appointmentReminder:
        return Colors.purple;
      case NotificationType.roomAssignment:
        return Colors.brown;
      case NotificationType.testOrder:
        return Colors.amber;
      case NotificationType.testResult:
        return Colors.red;
      case NotificationType.prescription:
        return Colors.pink;
      case NotificationType.general:
        return Colors.grey;
    }
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? message,
    NotificationType? type,
    bool? isRead,
    DateTime? createdAt,
    Map<String, dynamic>? data,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
    );
  }
}
