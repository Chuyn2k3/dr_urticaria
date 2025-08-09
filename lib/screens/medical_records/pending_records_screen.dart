import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/medical_record_cubit.dart';
import '../../cubits/notification_cubit.dart';
import '../../models/medical_record_model.dart';
import '../../models/notification_model.dart';

class PendingRecordsScreen extends StatelessWidget {
  const PendingRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bệnh án chờ duyệt'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<MedicalRecordCubit, MedicalRecordState>(
        builder: (context, state) {
          final pendingRecords = state.records
              .where((r) => r.status == MedicalRecordStatus.pendingApproval)
              .toList();

          // Sort by creation time (newest first)
          pendingRecords.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (pendingRecords.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Không có bệnh án chờ duyệt',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tất cả bệnh án đã được xử lý',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pendingRecords.length,
            itemBuilder: (context, index) {
              final record = pendingRecords[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.pending_actions,
                              color: Colors.orange,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  record.patientName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  record.medicalRecordNumber,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'CHỜ DUYỆT',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Patient Information
                      _buildInfoSection('Thông tin bệnh nhân', [
                        _buildInfoRow('Loại bệnh án', record.typeDisplayName),
                        _buildInfoRow('Số điện thoại', record.patientPhone),
                        _buildInfoRow('Địa chỉ', record.patientAddress),
                        _buildInfoRow(
                            'Ngày tạo', _formatDateTime(record.createdAt)),
                        _buildInfoRow(
                            'Người tạo',
                            record.createdBy == 'patient'
                                ? 'Bệnh nhân'
                                : 'Bác sĩ'),
                      ]),

                      const SizedBox(height: 16),

                      // Medical Information
                      _buildInfoSection('Thông tin y tế', [
                        _buildInfoRow('Tiền sử mề đay',
                            record.hasUrticariaHistory ? 'Có' : 'Không'),
                        _buildInfoRow('Thời gian triệu chứng',
                            record.symptomDuration ?? 'Chưa cập nhật'),
                        _buildInfoRow('Có ảnh minh chứng',
                            record.hasPhotos ? 'Có' : 'Không'),
                        if (record.symptoms != null &&
                            record.symptoms!.isNotEmpty)
                          _buildInfoRow('Triệu chứng', record.symptoms!,
                              isMultiline: true),
                      ]),

                      const SizedBox(height: 20),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _viewDetails(context, record),
                              icon: const Icon(Icons.visibility),
                              label: const Text('Xem chi tiết'),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  _showApprovalDialog(context, record),
                              icon: const Icon(Icons.check_circle),
                              label: const Text('Duyệt'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _viewDetails(BuildContext context, MedicalRecordModel record) {
    Navigator.pushNamed(
      context,
      '/medical-record-detail',
      arguments: record,
    );
  }

  void _showApprovalDialog(BuildContext context, MedicalRecordModel record) {
    final rooms = [
      {
        'id': 'room001',
        'name': 'Phòng khám mề đay 001',
        'doctor': 'BS. Nguyễn Văn A',
        'doctorId': 'doctor1'
      },
      {
        'id': 'room002',
        'name': 'Phòng khám mề đay 002',
        'doctor': 'BS. Trần Thị B',
        'doctorId': 'doctor2'
      },
      {
        'id': 'room003',
        'name': 'Phòng khám mề đay 003',
        'doctor': 'BS. Lê Văn C',
        'doctorId': 'doctor3'
      },
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Duyệt bệnh án và điều hướng'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bệnh nhân: ${record.patientName}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Loại: ${record.typeDisplayName}'),
                  Text('SĐT: ${record.patientPhone}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Chọn phòng khám:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...rooms.map((room) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        room['id']!.substring(4),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(room['name']!),
                    subtitle: Text(room['doctor']!),
                    onTap: () {
                      Navigator.pop(context);
                      _approveAndDirectPatient(
                        context,
                        record,
                        room['name']!,
                        room['doctor']!,
                        room['doctorId']!,
                      );
                    },
                  ),
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

  void _approveAndDirectPatient(
    BuildContext context,
    MedicalRecordModel record,
    String roomName,
    String doctorName,
    String doctorId,
  ) {
    // Update record status and assign doctor/room
    final updatedRecord = record.copyWith(
      status: MedicalRecordStatus.pendingApproval,
      doctorId: doctorId,
      doctorName: doctorName,
      roomNumber: roomName,
      queueNumber: DateTime.now().millisecondsSinceEpoch % 100,
      queueTime: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    context.read<MedicalRecordCubit>().updateRecord(updatedRecord);

    // Send notification to patient
    context.read<NotificationCubit>().sendRoomAssignmentNotification(
          record.patientId,
          roomName,
        );

    // Send notification to doctor
    context.read<NotificationCubit>().addNotification(
          NotificationModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            userId: doctorId,
            title: 'Bệnh nhân mới được điều hướng',
            message:
                'Bệnh nhân ${record.patientName} đã được điều hướng đến $roomName',
            type: NotificationType.patientDirected,
            createdAt: DateTime.now(),
          ),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Đã duyệt và điều hướng bệnh nhân ${record.patientName} đến $roomName'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
