import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/medical_record_cubit.dart';
import '../../cubits/notification_cubit.dart';
import '../../models/medical_record_model.dart';
import '../../models/notification_model.dart';

class PatientDirectionScreen extends StatefulWidget {
  const PatientDirectionScreen({super.key});

  @override
  State<PatientDirectionScreen> createState() => _PatientDirectionScreenState();
}

class _PatientDirectionScreenState extends State<PatientDirectionScreen> {
  final Map<String, List<MedicalRecordModel>> _roomQueues = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Điều hướng bệnh nhân'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<MedicalRecordCubit, MedicalRecordState>(
        builder: (context, state) {
          final approvedRecords = state.records
              .where((r) => r.status == MedicalRecordStatus.pendingApproval)
              .toList();

          // Group by room
          _roomQueues.clear();
          for (final record in approvedRecords) {
            final room = record.roomNumber ?? 'Chưa phân phòng';
            _roomQueues.putIfAbsent(room, () => []).add(record);
          }

          // Sort each room queue by queue time
          _roomQueues.forEach((room, records) {
            records.sort((a, b) => (a.queueTime ?? DateTime.now())
                .compareTo(b.queueTime ?? DateTime.now()));
          });

          if (_roomQueues.isEmpty) {
            return const Center(
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
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _roomQueues.length,
            itemBuilder: (context, index) {
              final room = _roomQueues.keys.elementAt(index);
              final patients = _roomQueues[room]!;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  title: Text(
                    room,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text('${patients.length} bệnh nhân chờ khám'),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      '${patients.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: patients.length,
                      itemBuilder: (context, patientIndex) {
                        final patient = patients[patientIndex];
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.orange,
                            child: Text(
                              '${patientIndex + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(patient.patientName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('SĐT: ${patient.patientPhone}'),
                              Text('Loại: ${patient.typeDisplayName}'),
                              Text(
                                'Thời gian: ${_formatTime(patient.queueTime ?? DateTime.now())}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              switch (value) {
                                case 'move':
                                  _showMovePatientDialog(patient);
                                  break;
                                case 'priority':
                                  _setPriority(patient);
                                  break;
                                case 'cancel':
                                  _cancelPatient(patient);
                                  break;
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'move',
                                child: Row(
                                  children: [
                                    Icon(Icons.swap_horiz, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text('Chuyển phòng'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'priority',
                                child: Row(
                                  children: [
                                    Icon(Icons.priority_high,
                                        color: Colors.orange),
                                    SizedBox(width: 8),
                                    Text('Ưu tiên'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'cancel',
                                child: Row(
                                  children: [
                                    Icon(Icons.cancel, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Hủy khám'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showMovePatientDialog(MedicalRecordModel patient) {
    final availableRooms = [
      'Phòng khám mề đay 001',
      'Phòng khám mề đay 002',
      'Phòng khám mề đay 003',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chuyển phòng khám'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Bệnh nhân: ${patient.patientName}'),
            Text('Phòng hiện tại: ${patient.roomNumber}'),
            const SizedBox(height: 16),
            const Text('Chọn phòng mới:'),
            ...availableRooms
                .where((room) => room != patient.roomNumber)
                .map((room) => ListTile(
                      title: Text(room),
                      onTap: () {
                        Navigator.pop(context);
                        _movePatient(patient, room);
                      },
                    )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
        ],
      ),
    );
  }

  void _movePatient(MedicalRecordModel patient, String newRoom) {
    final updatedPatient = patient.copyWith(
      roomNumber: newRoom,
      queueTime: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    context.read<MedicalRecordCubit>().updateRecord(updatedPatient);

    // Send notification to patient
    context.read<NotificationCubit>().sendRoomAssignmentNotification(
          patient.patientId,
          newRoom,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã chuyển ${patient.patientName} đến $newRoom'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _setPriority(MedicalRecordModel patient) {
    final updatedPatient = patient.copyWith(
      queueTime: DateTime.now().subtract(const Duration(hours: 1)),
      updatedAt: DateTime.now(),
    );

    context.read<MedicalRecordCubit>().updateRecord(updatedPatient);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã đặt ưu tiên cho ${patient.patientName}'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _cancelPatient(MedicalRecordModel patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hủy khám'),
        content:
            Text('Bạn có chắc chắn muốn hủy khám cho ${patient.patientName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Không'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);

              // Remove from queue (you might want to change status instead)
              context.read<MedicalRecordCubit>().updateRecord(
                    patient.copyWith(
                      status: MedicalRecordStatus.pendingApproval,
                      roomNumber: null,
                      queueNumber: null,
                      queueTime: null,
                      updatedAt: DateTime.now(),
                    ),
                  );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã hủy khám cho ${patient.patientName}'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hủy khám'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
