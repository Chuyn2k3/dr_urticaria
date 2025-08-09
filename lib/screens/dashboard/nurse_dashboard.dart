import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/auth_cubit.dart';
import '../../cubits/medical_record_cubit.dart';
import '../../cubits/appointment_cubit.dart';
import '../../models/medical_record_model.dart';
import '../../models/appointment_model.dart';
import '../patients/patient_list_screen.dart';
import '../medical_records/medical_record_list_screen.dart';
import '../medical_records/create_medical_record_screen.dart';
import '../profile/profile_screen.dart';
import '../../utils/app_theme.dart';
import '../medical_records/pending_approval_screen.dart';

class NurseDashboard extends StatefulWidget {
  const NurseDashboard({super.key});

  @override
  State<NurseDashboard> createState() => _NurseDashboardState();
}

class _NurseDashboardState extends State<NurseDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Y tá ${user.name}'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          // IconButton(
          //   icon: const Icon(Icons.logout),
          //   onPressed: () {
          //     context.read<AuthCubit>().logout();
          //     Navigator.pushReplacementNamed(context, '/login');
          //   },
          // ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(user),
          const PendingApprovalScreen(),
          const PatientListScreen(),
          MedicalRecordListScreen(doctorId: user.id),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: AppTheme.nurseColor,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.approval),
            label: 'Duyệt BA',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Bệnh nhân',
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
      floatingActionButton: _currentIndex == 3
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateMedicalRecordScreen(
                      createdBy: 'nurse',
                      doctorId: user.id,
                      doctorName: user.name,
                      roomNumber: 'P101', // Default room for nurse
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildHomeTab(user) {
    return BlocBuilder<MedicalRecordCubit, MedicalRecordState>(
      builder: (context, medicalRecordState) {
        return BlocBuilder<AppointmentCubit, AppointmentState>(
          builder: (context, appointmentState) {
            final allRecords = medicalRecordState.records;
            final todayAppointments = appointmentState.appointments
                .where((a) => _isToday(a.appointmentTime))
                .toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.nurseColor,
                            AppTheme.nurseColor.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: Colors.white,
                            child: Text(
                              user.name.split(' ').last[0],
                              style: TextStyle(
                                color: AppTheme.nurseColor,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Chào mừng, Y tá ${user.name}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${user.department}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.white70,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Hôm nay: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Statistics
                  const Text(
                    'Thống kê hôm nay',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Tổng bệnh án',
                          '${allRecords.length}',
                          Icons.medical_services_rounded,
                          AppTheme.nurseColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Lịch hẹn hôm nay',
                          '${todayAppointments.length}',
                          Icons.calendar_today_rounded,
                          AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Đang xử lý',
                          '${allRecords.where((r) => r.status == MedicalRecordStatus.inProgress).length}',
                          Icons.schedule_rounded,
                          AppTheme.warningColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Hoàn thành',
                          '${allRecords.where((r) => r.status == MedicalRecordStatus.completed).length}',
                          Icons.check_circle_rounded,
                          AppTheme.successColor,
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
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    children: [
                      _buildQuickAction(
                        'Danh sách bệnh nhân',
                        Icons.people_rounded,
                        AppTheme.nurseColor.withOpacity(0.1),
                        AppTheme.nurseColor,
                        () => setState(() => _currentIndex = 2),
                      ),
                      _buildQuickAction(
                        'Quản lý bệnh án',
                        Icons.medical_services_rounded,
                        AppTheme.primaryColor.withOpacity(0.1),
                        AppTheme.primaryColor,
                        () => setState(() => _currentIndex = 3),
                      ),
                      _buildQuickAction(
                        'Tạo bệnh án mới',
                        Icons.add_circle_rounded,
                        AppTheme.secondaryColor.withOpacity(0.1),
                        AppTheme.secondaryColor,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CreateMedicalRecordScreen(
                                createdBy: 'nurse',
                                doctorId: user.id,
                                doctorName: user.name,
                                roomNumber: 'P101',
                              ),
                            ),
                          );
                        },
                      ),
                      _buildQuickAction(
                        'Hỗ trợ bác sĩ',
                        Icons.support_agent_rounded,
                        AppTheme.accentColor.withOpacity(0.1),
                        AppTheme.accentColor,
                        () {
                          // Navigate to doctor support
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Recent Medical Records
                  if (allRecords.isNotEmpty) ...[
                    Row(
                      children: [
                        const Text(
                          'Bệnh án gần đây',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () => setState(() => _currentIndex = 3),
                          icon:
                              const Icon(Icons.arrow_forward_rounded, size: 16),
                          label: const Text('Xem tất cả'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: allRecords.take(3).length,
                      itemBuilder: (context, index) {
                        final record = allRecords[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor:
                                  record.statusColor.withOpacity(0.2),
                              radius: 24,
                              child: Text(
                                record.patientName[0],
                                style: TextStyle(
                                  color: record.statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            title: Text(
                              record.patientName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.folder_rounded,
                                      size: 14,
                                      color: AppTheme.textSecondaryColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${record.medicalRecordNumber} • ${record.typeDisplayName}',
                                      style: const TextStyle(
                                        color: AppTheme.textSecondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_rounded,
                                      size: 14,
                                      color: AppTheme.textSecondaryColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Ngày tạo: ${record.createdAt.day}/${record.createdAt.month}/${record.createdAt.year}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textSecondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: record.statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
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
                          ),
                        );
                      },
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    String title,
    IconData icon,
    Color bgColor,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, size: 28, color: iconColor),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: iconColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
