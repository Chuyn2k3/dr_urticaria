import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/auth_cubit.dart';
import '../../cubits/medical_record_cubit.dart';
import '../../cubits/notification_cubit.dart';
import '../../models/medical_record_model.dart';
import '../patients/patient_queue_screen.dart';
import '../medical_records/medical_record_list_screen.dart';
import '../medical_records/create_medical_record_screen.dart';
import '../profile/profile_screen.dart';
import '../../utils/app_theme.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user!;

    return Scaffold(
      appBar: AppBar(
        title: Text('BS. ${user.name}'),
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.doctorColor,
        foregroundColor: Colors.white,
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              final unreadCount =
                  context.read<NotificationCubit>().getUnreadCount(user.id);

              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      // Navigate to notifications
                    },
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(user),
          PatientQueueScreen(
            doctorId: user.id,
            roomNumber: user.roomNumber ?? 'P101',
          ),
          MedicalRecordListScreen(doctorId: user.id),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: AppTheme.doctorColor,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Tổng quan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: 'Hàng đợi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Bệnh án',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Cá nhân',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 2
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateMedicalRecordScreen(
                      createdBy: 'doctor',
                      doctorId: user.id,
                      doctorName: user.name,
                      roomNumber: user.roomNumber ?? 'P101',
                    ),
                  ),
                );
              },
              backgroundColor: AppTheme.doctorColor,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildHomeTab(user) {
    return BlocBuilder<MedicalRecordCubit, MedicalRecordState>(
      builder: (context, state) {
        final myRecords =
            context.read<MedicalRecordCubit>().getRecordsByDoctorId(user.id);

        final waitingApproval = myRecords
            .where((r) => r.status == MedicalRecordStatus.pendingApproval)
            .toList();

        final inProgress = myRecords
            .where((r) => r.status == MedicalRecordStatus.inProgress)
            .toList();

        final waitingTests = myRecords
            .where((r) => r.status == MedicalRecordStatus.waitingTests)
            .toList();

        final testsComplete = myRecords
            .where((r) => r.status == MedicalRecordStatus.testsComplete)
            .toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.doctorColor,
                      AppTheme.doctorColor.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.doctorColor.withOpacity(0.3),
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
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Text(
                            user.name.split(' ').last[0],
                            style: TextStyle(
                              color: AppTheme.doctorColor,
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
                                'BS. ${user.name}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${user.specialization} • ${user.roomNumber}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Hôm nay: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Statistics Cards
              const Text(
                'Tình trạng bệnh án',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // First row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Chờ duyệt',
                      '${waitingApproval.length}',
                      Icons.pending_actions,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Đang xử lý',
                      '${inProgress.length}',
                      Icons.medical_services,
                      Colors.blue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Chờ XN',
                      '${waitingTests.length}',
                      Icons.science,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Đủ KQ XN',
                      '${testsComplete.length}',
                      Icons.check_circle,
                      Colors.green,
                      onTap: () => setState(() => _currentIndex = 2),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Quick Actions
              const Text(
                'Thao tác nhanh',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  _buildQuickActionCard(
                    'Hàng đợi bệnh nhân',
                    Icons.people_alt,
                    Colors.blue,
                    () => setState(() => _currentIndex = 1),
                  ),
                  _buildQuickActionCard(
                    'Tạo bệnh án',
                    Icons.add_circle,
                    Colors.green,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateMedicalRecordScreen(
                            createdBy: 'doctor',
                            doctorId: user.id,
                            doctorName: user.name,
                            roomNumber: user.roomNumber ?? 'P101',
                          ),
                        ),
                      );
                    },
                  ),
                  _buildQuickActionCard(
                    'Quản lý bệnh án',
                    Icons.folder_open,
                    Colors.orange,
                    () => setState(() => _currentIndex = 2),
                  ),
                  _buildQuickActionCard(
                    'Chỉ định XN',
                    Icons.science,
                    Colors.purple,
                    () => setState(() => _currentIndex = 2),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Patients needing attention
              if (testsComplete.isNotEmpty) ...[
                Row(
                  children: [
                    const Text(
                      'Bệnh nhân cần xử lý',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => setState(() => _currentIndex = 2),
                      child: const Text('Xem tất cả'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: testsComplete.take(3).length,
                  itemBuilder: (context, index) {
                    final record = testsComplete[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
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
                        title: Text(record.patientName),
                        subtitle: Text(
                          '${record.medicalRecordNumber} • ${record.statusDisplayName}',
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Đã đủ KQ XN',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/medical-record-detail',
                            arguments: record,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
