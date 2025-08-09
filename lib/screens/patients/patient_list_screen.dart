import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/medical_record_cubit.dart';
import '../../models/medical_record_model.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách bệnh nhân'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Tìm kiếm bệnh nhân...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          
          // Patient List
          Expanded(
            child: BlocBuilder<MedicalRecordCubit, MedicalRecordState>(
              builder: (context, state) {
                // Get unique patients from medical records
                final uniquePatients = <String, MedicalRecordModel>{};
                for (final record in state.records) {
                  if (!uniquePatients.containsKey(record.patientId) ||
                      record.createdAt.isAfter(uniquePatients[record.patientId]!.createdAt)) {
                    uniquePatients[record.patientId] = record;
                  }
                }

                var patients = uniquePatients.values.toList();

                // Filter by search query
                if (_searchQuery.isNotEmpty) {
                  patients = patients.where((patient) {
                    return patient.patientName.toLowerCase().contains(_searchQuery) ||
                           patient.patientPhone.contains(_searchQuery) ||
                           patient.medicalRecordNumber.toLowerCase().contains(_searchQuery);
                  }).toList();
                }

                // Sort by most recent
                patients.sort((a, b) => b.createdAt.compareTo(a.createdAt));

                if (patients.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchQuery.isNotEmpty ? Icons.search_off : Icons.people_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty 
                              ? 'Không tìm thấy bệnh nhân'
                              : 'Chưa có bệnh nhân nào',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    final patient = patients[index];
                    final patientRecords = state.records
                        .where((r) => r.patientId == patient.patientId)
                        .toList();

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getPatientStatusColor(patientRecords),
                          child: Text(
                            patient.patientName[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          patient.patientName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('SĐT: ${patient.patientPhone}'),
                            Text('Địa chỉ: ${patient.patientAddress}'),
                            Text(
                              'Số bệnh án: ${patientRecords.length}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getPatientStatusColor(patientRecords).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getPatientStatusText(patientRecords),
                                style: TextStyle(
                                  color: _getPatientStatusColor(patientRecords),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${patient.createdAt.day}/${patient.createdAt.month}/${patient.createdAt.year}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        onTap: () => _viewPatientDetails(patient, patientRecords),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getPatientStatusColor(List<MedicalRecordModel> records) {
    if (records.isEmpty) return Colors.grey;
    
    final latestRecord = records.reduce((a, b) => 
        a.createdAt.isAfter(b.createdAt) ? a : b);
    
    return latestRecord.statusColor;
  }

  String _getPatientStatusText(List<MedicalRecordModel> records) {
    if (records.isEmpty) return 'Không có bệnh án';
    
    final latestRecord = records.reduce((a, b) => 
        a.createdAt.isAfter(b.createdAt) ? a : b);
    
    return latestRecord.statusDisplayName;
  }

  void _viewPatientDetails(MedicalRecordModel patient, List<MedicalRecordModel> records) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: _getPatientStatusColor(records),
                    child: Text(
                      patient.patientName[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.patientName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('SĐT: ${patient.patientPhone}'),
                        Text('Địa chỉ: ${patient.patientAddress}'),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),

              // Examination History
              Text(
                'Lịch sử khám bệnh (${records.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ngày khám: ${record.createdAt.day}/${record.createdAt.month}/${record.createdAt.year}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text('Chẩn đoán: ${record.diagnosis ?? 'N/A'}'),
                            const SizedBox(height: 4),
                            Text('Điều trị: ${record.treatment ?? 'N/A'}'),
                            const SizedBox(height: 4),
                            Text('Kết quả: ${record.outcome ?? 'N/A'}'),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(
                                      context,
                                      '/medical-record-detail',
                                      arguments: record,
                                    );
                                  },
                                  child: const Text('Xem chi tiết'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement navigation to create new medical record
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        '/create-medical-record',
                        arguments: patient,
                      );
                    },
                    child: const Text('Tạo bệnh án mới'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement navigation to view all medical records
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        '/patient-medical-records',
                        arguments: patient,
                      );
                    },
                    child: const Text('Xem tất cả bệnh án'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
