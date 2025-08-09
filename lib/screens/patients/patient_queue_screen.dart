import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/medical_record_cubit.dart';
import '../../models/medical_record_model.dart';
import '../medical_records/medical_record_detail_screen.dart';

class PatientQueueScreen extends StatefulWidget {
  final String doctorId;
  final String roomNumber;

  const PatientQueueScreen({
    super.key,
    required this.doctorId,
    required this.roomNumber,
  });

  @override
  State<PatientQueueScreen> createState() => _PatientQueueScreenState();
}

class _PatientQueueScreenState extends State<PatientQueueScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hàng đợi - ${widget.roomNumber}'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<MedicalRecordCubit, MedicalRecordState>(
        builder: (context, state) {
          // Get patients in queue for this room
          final queuePatients = state.records
              .where((r) => 
                r.roomNumber == widget.roomNumber &&
                (r.status == MedicalRecordStatus.pendingApproval ||
                 r.status == MedicalRecordStatus.inProgress))
              .toList();

          // Sort by queue time
          queuePatients.sort((a, b) => 
            (a.queueTime ?? DateTime.now()).compareTo(b.queueTime ?? DateTime.now()));

          final currentPatient = queuePatients
              .where((p) => p.status == MedicalRecordStatus.inProgress)
              .firstOrNull;
          
          final waitingPatients = queuePatients
              .where((p) => p.status == MedicalRecordStatus.pendingApproval)
              .toList();

          return Column(
            children: [
              // Current Patient
              if (currentPatient != null)
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple, Colors.purple.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.medical_services,
                              color: Colors.purple,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'ĐANG KHÁM',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildPatientCard(currentPatient, isCurrentPatient: true),
                    ],
                  ),
                ),

              // Waiting Queue Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.blue.withOpacity(0.1),
                child: Row(
                  children: [
                    const Icon(Icons.schedule, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'HÀNG ĐỢI (${waitingPatients.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),

              // Waiting Queue
              Expanded(
                child: waitingPatients.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Không có bệnh nhân chờ khám',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: waitingPatients.length,
                        itemBuilder: (context, index) {
                          final patient = waitingPatients[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: _buildPatientCard(
                              patient,
                              queueNumber: index + 1,
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPatientCard(
    MedicalRecordModel patient, {
    bool isCurrentPatient = false,
    int? queueNumber,
  }) {
    return Card(
      elevation: isCurrentPatient ? 0 : 2,
      color: isCurrentPatient ? Colors.transparent : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Queue Number or Status
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isCurrentPatient ? Colors.white : Colors.blue,
                borderRadius: BorderRadius.circular(25),
                border: isCurrentPatient 
                    ? Border.all(color: Colors.white, width: 2)
                    : null,
              ),
              child: Center(
                child: isCurrentPatient
                    ? const Icon(
                        Icons.medical_services,
                        color: Colors.purple,
                        size: 24,
                      )
                    : Text(
                        '$queueNumber',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Patient Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.patientName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCurrentPatient ? Colors.white : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'SĐT: ${patient.patientPhone}',
                    style: TextStyle(
                      color: isCurrentPatient ? Colors.white70 : Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Loại: ${patient.typeDisplayName}',
                    style: TextStyle(
                      color: isCurrentPatient ? Colors.white70 : Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Thời gian: ${_formatTime(patient.queueTime ?? DateTime.now())}',
                    style: TextStyle(
                      color: isCurrentPatient ? Colors.white70 : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // Action Button
            if (!isCurrentPatient)
              ElevatedButton.icon(
                onPressed: () => _startExamination(patient),
                icon: const Icon(Icons.play_arrow, size: 18),
                label: const Text('Bắt đầu'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              )
            else
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _viewMedicalRecord(patient),
                    icon: const Icon(Icons.folder_open, size: 18),
                    label: const Text('Xem BA'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _completeExamination(patient),
                    icon: const Icon(Icons.check_circle, size: 18),
                    label: const Text('Hoàn thành'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _startExamination(MedicalRecordModel patient) {
    final updatedPatient = patient.copyWith(
      status: MedicalRecordStatus.inProgress,
      updatedAt: DateTime.now(),
    );

    context.read<MedicalRecordCubit>().updateRecord(updatedPatient);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bắt đầu khám bệnh nhân ${patient.patientName}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _viewMedicalRecord(MedicalRecordModel patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MedicalRecordDetailScreen(record: patient),
      ),
    );
  }

  void _completeExamination(MedicalRecordModel patient) {
    // Navigate to medical record detail to complete the examination
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MedicalRecordDetailScreen(record: patient),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
