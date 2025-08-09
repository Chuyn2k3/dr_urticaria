import 'package:flutter/material.dart';

enum MedicalRecordType {
  acute,
  chronicFirst,
  chronicReexam,
}

enum MedicalRecordStatus {
  pendingApproval, // Chờ duyệt (bệnh nhân tạo)
  inProgress, // Đang xử lý (y tá đã duyệt, chưa có kết quả xét nghiệm)
  waitingTests, // Chờ xét nghiệm (bác sĩ đã chỉ định xét nghiệm)
  testsComplete, // Đang xử lý (đủ kết quả xét nghiệm)
  completed, // Đã hoàn thành (bác sĩ đã đóng bệnh án)
}

class MedicalRecordModel {
  final String id;
  final String patientId;
  final String patientName;
  final String patientPhone;
  final String patientAddress;
  final String medicalRecordNumber;
  final MedicalRecordType type;
  final MedicalRecordStatus status;
  final String? doctorId;
  final String? doctorName;
  final String? roomNumber;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String createdBy; // 'patient' or 'doctor'

  // Medical information
  final bool hasUrticariaHistory;
  final bool hasPhotos;
  final List<String> photoUrls;
  final String? symptomDuration;
  final String? symptoms;
  final String? medicalHistory;
  final String? allergies;
  final String? currentMedications;

  // Test results
  final List<TestOrder> testOrders;
  final bool hasCompleteTestResults;

  // Prescription
  final String? prescription;
  final String? diagnosis;
  final String? notes;
  final String? treatment;
  final String? outcome;

  // Queue management
  final int? queueNumber;
  final DateTime? queueTime;

  MedicalRecordModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.patientPhone,
    required this.patientAddress,
    required this.medicalRecordNumber,
    required this.type,
    required this.status,
    this.doctorId,
    this.doctorName,
    this.roomNumber,
    required this.createdAt,
    this.updatedAt,
    required this.createdBy,
    this.hasUrticariaHistory = false,
    this.hasPhotos = false,
    this.photoUrls = const [],
    this.symptomDuration,
    this.symptoms,
    this.medicalHistory,
    this.allergies,
    this.currentMedications,
    this.testOrders = const [],
    this.hasCompleteTestResults = false,
    this.prescription,
    this.diagnosis,
    this.notes,
    this.treatment,
    this.outcome,
    this.queueNumber,
    this.queueTime,
  });

  String get typeDisplayName {
    switch (type) {
      case MedicalRecordType.acute:
        return 'Mề đay cấp tính';
      case MedicalRecordType.chronicFirst:
        return 'Mề đay mạn tính lần 1';
      case MedicalRecordType.chronicReexam:
        return 'Mề đay mạn tính tái khám';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case MedicalRecordStatus.pendingApproval:
        return 'Chờ duyệt';
      case MedicalRecordStatus.inProgress:
        return 'Đang xử lý (chưa có KQ XN)';
      case MedicalRecordStatus.waitingTests:
        return 'Chờ xét nghiệm';
      case MedicalRecordStatus.testsComplete:
        return 'Đang xử lý (đủ KQ XN)';
      case MedicalRecordStatus.completed:
        return 'Đã hoàn thành';
    }
  }

  Color get statusColor {
    switch (status) {
      case MedicalRecordStatus.pendingApproval:
        return Colors.orange;
      case MedicalRecordStatus.inProgress:
        return Colors.purple;
      case MedicalRecordStatus.waitingTests:
        return Colors.amber;
      case MedicalRecordStatus.testsComplete:
        return Colors.green;
      case MedicalRecordStatus.completed:
        return Colors.teal;
    }
  }

  MedicalRecordModel copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? patientPhone,
    String? patientAddress,
    String? medicalRecordNumber,
    MedicalRecordType? type,
    MedicalRecordStatus? status,
    String? doctorId,
    String? doctorName,
    String? roomNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    bool? hasUrticariaHistory,
    bool? hasPhotos,
    List<String>? photoUrls,
    String? symptomDuration,
    String? symptoms,
    String? medicalHistory,
    String? allergies,
    String? currentMedications,
    List<TestOrder>? testOrders,
    bool? hasCompleteTestResults,
    String? prescription,
    String? diagnosis,
    String? notes,
    String? treatment,
    String? outcome,
    int? queueNumber,
    DateTime? queueTime,
  }) {
    return MedicalRecordModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      patientPhone: patientPhone ?? this.patientPhone,
      patientAddress: patientAddress ?? this.patientAddress,
      medicalRecordNumber: medicalRecordNumber ?? this.medicalRecordNumber,
      type: type ?? this.type,
      status: status ?? this.status,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      roomNumber: roomNumber ?? this.roomNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      hasUrticariaHistory: hasUrticariaHistory ?? this.hasUrticariaHistory,
      hasPhotos: hasPhotos ?? this.hasPhotos,
      photoUrls: photoUrls ?? this.photoUrls,
      symptomDuration: symptomDuration ?? this.symptomDuration,
      symptoms: symptoms ?? this.symptoms,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      allergies: allergies ?? this.allergies,
      currentMedications: currentMedications ?? this.currentMedications,
      testOrders: testOrders ?? this.testOrders,
      hasCompleteTestResults:
          hasCompleteTestResults ?? this.hasCompleteTestResults,
      prescription: prescription ?? this.prescription,
      diagnosis: diagnosis ?? this.diagnosis,
      notes: notes ?? this.notes,
      treatment: treatment ?? this.treatment,
      outcome: outcome ?? this.outcome,
      queueNumber: queueNumber ?? this.queueNumber,
      queueTime: queueTime ?? this.queueTime,
    );
  }
}

class TestOrder {
  final String id;
  final String testName;
  final String roomNumber;
  final DateTime orderedAt;
  final String? result;
  final DateTime? resultDate;
  final bool isCompleted;

  TestOrder({
    required this.id,
    required this.testName,
    required this.roomNumber,
    required this.orderedAt,
    this.result,
    this.resultDate,
    this.isCompleted = false,
  });

  TestOrder copyWith({
    String? id,
    String? testName,
    String? roomNumber,
    DateTime? orderedAt,
    String? result,
    DateTime? resultDate,
    bool? isCompleted,
  }) {
    return TestOrder(
      id: id ?? this.id,
      testName: testName ?? this.testName,
      roomNumber: roomNumber ?? this.roomNumber,
      orderedAt: orderedAt ?? this.orderedAt,
      result: result ?? this.result,
      resultDate: resultDate ?? this.resultDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
