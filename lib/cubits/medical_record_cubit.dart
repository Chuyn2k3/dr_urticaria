import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/medical_record_model.dart';

class MedicalRecordState {
  final List<MedicalRecordModel> records;
  final bool isLoading;
  final String? error;

  MedicalRecordState({
    this.records = const [],
    this.isLoading = false,
    this.error,
  });

  MedicalRecordState copyWith({
    List<MedicalRecordModel>? records,
    bool? isLoading,
    String? error,
  }) {
    return MedicalRecordState(
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class MedicalRecordCubit extends Cubit<MedicalRecordState> {
  MedicalRecordCubit() : super(MedicalRecordState()) {
    _loadDemoData();
  }

  void _loadDemoData() {
    final demoRecords = [
      MedicalRecordModel(
        id: 'record1',
        patientId: 'patient1',
        patientName: 'Nguyễn Thị Lan',
        patientPhone: '0123456789',
        patientAddress: '123 Đường ABC, Quận 1, TP.HCM',
        medicalRecordNumber: 'BN001',
        type: MedicalRecordType.acute,
        status: MedicalRecordStatus.pendingApproval,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        createdBy: 'patient',
        hasUrticariaHistory: true,
        hasPhotos: false,
        symptomDuration: '< 6 tuần',
        symptoms: 'Nổi mề đay toàn thân, ngứa nhiều, xuất hiện sau khi ăn tôm',
      ),
      MedicalRecordModel(
        id: 'record2',
        patientId: 'patient2',
        patientName: 'Trần Văn Minh',
        patientPhone: '0987654321',
        patientAddress: '456 Đường XYZ, Quận 3, TP.HCM',
        medicalRecordNumber: 'BN002',
        type: MedicalRecordType.chronicFirst,
        status: MedicalRecordStatus.pendingApproval,
        doctorId: 'doctor1',
        doctorName: 'BS. Nguyễn Văn A',
        roomNumber: 'Phòng khám mề đay 001',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        createdBy: 'patient',
        hasUrticariaHistory: false,
        hasPhotos: true,
        symptomDuration: '≥ 6 tuần',
        symptoms: 'Mề đay mạn tính, tái phát nhiều lần trong 3 tháng qua',
        queueNumber: 1,
        queueTime: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      MedicalRecordModel(
        id: 'record3',
        patientId: 'patient3',
        patientName: 'Lê Thị Hoa',
        patientPhone: '0555666777',
        patientAddress: '789 Đường DEF, Quận 7, TP.HCM',
        medicalRecordNumber: 'BN003',
        type: MedicalRecordType.chronicReexam,
        status: MedicalRecordStatus.inProgress,
        doctorId: 'doctor1',
        doctorName: 'BS. Nguyễn Văn A',
        roomNumber: 'Phòng khám mề đay 001',
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
        createdBy: 'doctor',
        hasUrticariaHistory: true,
        hasPhotos: true,
        symptomDuration: '≥ 6 tuần',
        symptoms: 'Tái khám mề đay mạn tính, đã điều trị 2 tháng',
        diagnosis: 'Mề đay mạn tính tự phát',
        treatment: 'Antihistamine, tránh tác nhân gây dị ứng',
      ),
    ];

    emit(state.copyWith(records: demoRecords));
  }

  List<MedicalRecordModel> getRecordsByDoctorId(String doctorId) {
    return state.records.where((r) => r.doctorId == doctorId).toList();
  }

  List<MedicalRecordModel> getPendingApprovalRecords() {
    return state.records
        .where((r) => r.status == MedicalRecordStatus.pendingApproval)
        .toList();
  }

  List<MedicalRecordModel> getRecordsByStatus(MedicalRecordStatus status) {
    return state.records.where((r) => r.status == status).toList();
  }

  void addRecord(MedicalRecordModel record) {
    final updatedRecords = [...state.records, record];
    emit(state.copyWith(records: updatedRecords));
  }

  void updateRecord(MedicalRecordModel updatedRecord) {
    final updatedRecords = state.records.map((r) {
      return r.id == updatedRecord.id ? updatedRecord : r;
    }).toList();
    emit(state.copyWith(records: updatedRecords));
  }

  void updateRecordStatus(String recordId, MedicalRecordStatus status) {
    final record = state.records.firstWhere((r) => r.id == recordId);
    final updatedRecord = record.copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );
    updateRecord(updatedRecord);
  }

  void approveRecord(
      String recordId, String doctorId, String doctorName, String roomNumber) {
    final record = state.records.firstWhere((r) => r.id == recordId);
    final updatedRecord = record.copyWith(
      status: MedicalRecordStatus.pendingApproval,
      doctorId: doctorId,
      doctorName: doctorName,
      roomNumber: roomNumber,
      queueNumber: DateTime.now().millisecondsSinceEpoch % 100,
      queueTime: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    updateRecord(updatedRecord);
  }

  void startExamination(String recordId) {
    updateRecordStatus(recordId, MedicalRecordStatus.inProgress);
  }

  void orderTests(String recordId, List<TestOrder> testOrders) {
    final record = state.records.firstWhere((r) => r.id == recordId);
    final updatedRecord = record.copyWith(
      status: MedicalRecordStatus.waitingTests,
      testOrders: [...record.testOrders, ...testOrders],
      updatedAt: DateTime.now(),
    );
    updateRecord(updatedRecord);
  }

  void updateTestResult(String recordId, String testId, String result) {
    final record = state.records.firstWhere((r) => r.id == recordId);
    final updatedTestOrders = record.testOrders.map((test) {
      if (test.id == testId) {
        return test.copyWith(
          result: result,
          resultDate: DateTime.now(),
          isCompleted: true,
        );
      }
      return test;
    }).toList();

    // Check if all tests are completed
    final allTestsCompleted =
        updatedTestOrders.every((test) => test.isCompleted);

    final updatedRecord = record.copyWith(
      testOrders: updatedTestOrders,
      hasCompleteTestResults: allTestsCompleted,
      status: allTestsCompleted
          ? MedicalRecordStatus.testsComplete
          : MedicalRecordStatus.waitingTests,
      updatedAt: DateTime.now(),
    );
    updateRecord(updatedRecord);
  }

  void completeRecord(String recordId) {
    updateRecordStatus(recordId, MedicalRecordStatus.completed);
  }
}
