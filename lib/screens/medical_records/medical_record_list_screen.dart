import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/medical_record_cubit.dart';
import '../../models/medical_record_model.dart';
import 'medical_record_detail_screen.dart';

class MedicalRecordListScreen extends StatefulWidget {
  final String doctorId;

  const MedicalRecordListScreen({
    super.key,
    required this.doctorId,
  });

  @override
  State<MedicalRecordListScreen> createState() =>
      _MedicalRecordListScreenState();
}

class _MedicalRecordListScreenState extends State<MedicalRecordListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bệnh án mề đay'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Tất cả'),
            Tab(text: 'Chờ duyệt'),
            Tab(text: 'Đang xử lý'),
            Tab(text: 'Hoàn thành'),
          ],
        ),
      ),
      body: BlocBuilder<MedicalRecordCubit, MedicalRecordState>(
        builder: (context, state) {
          final myRecords = context
              .read<MedicalRecordCubit>()
              .getRecordsByDoctorId(widget.doctorId);

          return TabBarView(
            controller: _tabController,
            children: [
              _buildRecordList(myRecords),
              _buildRecordList(myRecords
                  .where((r) => r.status == MedicalRecordStatus.pendingApproval)
                  .toList()),
              _buildRecordList(myRecords
                  .where((r) => r.status == MedicalRecordStatus.inProgress)
                  .toList()),
              _buildRecordList(myRecords
                  .where((r) => r.status == MedicalRecordStatus.completed)
                  .toList()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRecordList(List<MedicalRecordModel> records) {
    if (records.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Không có bệnh án',
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
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: record.statusColor,
              child: Text(
                record.patientName[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              record.patientName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${record.medicalRecordNumber} • ${record.typeDisplayName}'),
                Text(
                  'Ngày tạo: ${record.createdAt.day}/${record.createdAt.month}/${record.createdAt.year}',
                  style: const TextStyle(fontSize: 12),
                ),
                if (record.hasCompleteTestResults)
                  const Text(
                    '✓ Đã đủ kết quả xét nghiệm',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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
                    color: record.statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    record.statusDisplayName,
                    style: TextStyle(
                      color: record.statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (record.createdBy == 'patient')
                  const Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.blue,
                  ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MedicalRecordDetailScreen(record: record),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
