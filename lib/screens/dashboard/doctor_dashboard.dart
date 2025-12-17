import 'package:dr_urticaria/medical_record_v2/screens/appointment_list_screen.dart';
import 'package:dr_urticaria/medical_record_v2/screens/medical_record_list_screen.dart';
import 'package:dr_urticaria/screens/home_tab_screen.dart';
//import 'package:dr_urticaria/screens/medical_records/medical_records_list_screen.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('BS. ${user.name}'),
      //   automaticallyImplyLeading: false,
      //   backgroundColor: AppTheme.doctorColor,
      //   foregroundColor: Colors.white,
      //   actions: [
      //     BlocBuilder<NotificationCubit, NotificationState>(
      //       builder: (context, state) {
      //         final unreadCount =
      //             context.read<NotificationCubit>().getUnreadCount(user.id);

      //         return Stack(
      //           children: [
      //             IconButton(
      //               icon: const Icon(Icons.notifications),
      //               onPressed: () {
      //                 // Navigate to notifications
      //               },
      //             ),
      //             if (unreadCount > 0)
      //               Positioned(
      //                 right: 8,
      //                 top: 8,
      //                 child: Container(
      //                   padding: const EdgeInsets.all(2),
      //                   decoration: BoxDecoration(
      //                     color: Colors.red,
      //                     borderRadius: BorderRadius.circular(10),
      //                   ),
      //                   constraints: const BoxConstraints(
      //                     minWidth: 16,
      //                     minHeight: 16,
      //                   ),
      //                   child: Text(
      //                     '$unreadCount',
      //                     style: const TextStyle(
      //                       color: Colors.white,
      //                       fontSize: 12,
      //                     ),
      //                     textAlign: TextAlign.center,
      //                   ),
      //                 ),
      //               ),
      //           ],
      //         );
      //       },
      //     ),
      //   ],
      // ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeTabScreen(), AppointmentsListScreen(),
          MedicalRecordListScreen(),
          // PatientQueueScreen(
          //   doctorId: user.id,
          //   roomNumber: user.roomNumber ?? 'P101',
          // ),
          // MedicalRecordsListScreen(),
          //MedicalRecordListScreen(doctorId: user.id),

          ProfileScreen(),
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
            icon: Icon(Icons.calendar_today), // Change the icon here
            label: 'Danh sách lịch hẹn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            label: 'Quản lý bệnh án',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Cá nhân',
          ),
        ],
      ),
      // floatingActionButton: _currentIndex == 2
      //     ? FloatingActionButton(
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (_) => const AppointmentsListScreen(),
      //             ),
      //           );
      //         },
      //         backgroundColor: AppTheme.doctorColor,
      //         child: const Icon(Icons.add, color: Colors.white),
      //       )
      //     : null,
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
