// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../cubits/auth_cubit.dart';
// import '../../cubits/medical_record_cubit.dart';
// import '../../cubits/notification_cubit.dart';
// import '../../models/medical_record_model.dart';
// import '../../models/notification_model.dart';
// import '../medical_records/pending_records_screen.dart';
// import '../patients/patient_direction_screen.dart';
// import '../profile/profile_screen.dart';
// import '../../utils/app_theme.dart';
//
// class ReceptionistDashboard extends StatefulWidget {
//   const ReceptionistDashboard({super.key});
//
//   @override
//   State<ReceptionistDashboard> createState() => _ReceptionistDashboardState();
// }
//
// class _ReceptionistDashboardState extends State<ReceptionistDashboard> {
//   int _currentIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     final user = context.read<AuthCubit>().state.user!;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Lễ tân ${user.name}'),
//         automaticallyImplyLeading: false,
//         backgroundColor: AppTheme.receptionistColor,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {
//               // Navigate to notifications
//             },
//           ),
//         ],
//       ),
//       body: IndexedStack(
//         index: _currentIndex,
//         children: [
//           _buildHomeTab(user),
//           const PendingRecordsScreen(),
//           const PatientDirectionScreen(),
//           const ProfileScreen(),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _currentIndex,
//         selectedItemColor: AppTheme.receptionistColor,
//         onTap: (index) => setState(() => _currentIndex = index),
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard),
//             label: 'Tổng quan',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.approval),
//             label: 'Duyệt bệnh án',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.directions),
//             label: 'Điều hướng',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Cá nhân',
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHomeTab(user) {
//     return BlocBuilder<MedicalRecordCubit, MedicalRecordState>(
//       builder: (context, state) {
//         final pendingRecords = state.records
//             .where((r) => r.status == MedicalRecordStatus.pendingApproval)
//             .toList();
//
//         final approvedRecords = state.records
//             .where((r) => r.status == MedicalRecordStatus.pendingApproval)
//             .toList();
//
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Welcome Card
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       AppTheme.receptionistColor,
//                       AppTheme.receptionistColor.withOpacity(0.8),
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppTheme.receptionistColor.withOpacity(0.3),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 30,
//                           backgroundColor: Colors.white,
//                           child: Text(
//                             user.name.split(' ').last[0],
//                             style: TextStyle(
//                               color: AppTheme.receptionistColor,
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Lễ tân ${user.name}',
//                                 style: const TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Text(
//                                 user.department ?? 'Phòng tiếp đón',
//                                 style: const TextStyle(
//                                   color: Colors.white70,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Icon(
//                             Icons.calendar_today,
//                             color: Colors.white,
//                             size: 14,
//                           ),
//                           const SizedBox(width: 6),
//                           Text(
//                             'Hôm nay: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 24),
//
//               // Statistics
//               const Text(
//                 'Thống kê công việc',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildStatCard(
//                       'Chờ duyệt',
//                       '${pendingRecords.length}',
//                       Icons.pending_actions,
//                       Colors.orange,
//                       onTap: () => setState(() => _currentIndex = 1),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _buildStatCard(
//                       'Đã duyệt',
//                       '${approvedRecords.length}',
//                       Icons.check_circle,
//                       Colors.green,
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 32),
//
//               // Quick Actions
//               const Text(
//                 'Chức năng chính',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               GridView.count(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//                 childAspectRatio: 1.2,
//                 children: [
//                   _buildQuickActionCard(
//                     'Duyệt bệnh án',
//                     Icons.approval,
//                     Colors.orange,
//                     () => setState(() => _currentIndex = 1),
//                   ),
//                   _buildQuickActionCard(
//                     'Điều hướng BN',
//                     Icons.directions,
//                     Colors.blue,
//                     () => setState(() => _currentIndex = 2),
//                   ),
//                   _buildQuickActionCard(
//                     'Đăng ký khám',
//                     Icons.person_add,
//                     Colors.green,
//                     () {
//                       // Navigate to registration
//                     },
//                   ),
//                   _buildQuickActionCard(
//                     'Thống kê',
//                     Icons.analytics,
//                     Colors.purple,
//                     () {
//                       // Navigate to statistics
//                     },
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 32),
//
//               // Pending Records
//               if (pendingRecords.isNotEmpty) ...[
//                 Row(
//                   children: [
//                     const Text(
//                       'Bệnh án chờ duyệt',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const Spacer(),
//                     TextButton(
//                       onPressed: () => setState(() => _currentIndex = 1),
//                       child: const Text('Xem tất cả'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: pendingRecords.take(3).length,
//                   itemBuilder: (context, index) {
//                     final record = pendingRecords[index];
//                     return Card(
//                       margin: const EdgeInsets.only(bottom: 8),
//                       child: ListTile(
//                         leading: CircleAvatar(
//                           backgroundColor: Colors.orange,
//                           child: Text(
//                             record.patientName[0],
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         title: Text(record.patientName),
//                         subtitle: Text(
//                           '${record.medicalRecordNumber} • ${record.typeDisplayName}',
//                         ),
//                         trailing: ElevatedButton(
//                           onPressed: () => _approveRecord(record),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             foregroundColor: Colors.white,
//                             minimumSize: const Size(60, 32),
//                           ),
//                           child: const Text('Duyệt'),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildStatCard(
//     String title,
//     String value,
//     IconData icon,
//     Color color, {
//     VoidCallback? onTap,
//   }) {
//     return Card(
//       elevation: 2,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(8),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Icon(icon, size: 32, color: color),
//               const SizedBox(height: 8),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: color,
//                 ),
//               ),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQuickActionCard(
//     String title,
//     IconData icon,
//     Color color,
//     VoidCallback onTap,
//   ) {
//     return Card(
//       elevation: 2,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(8),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(icon, size: 28, color: color),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: color,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _approveRecord(MedicalRecordModel record) {
//     // Show room selection dialog
//     _showRoomSelectionDialog(record);
//   }
//
//   void _showRoomSelectionDialog(MedicalRecordModel record) {
//     final rooms = [
//       {'name': 'Phòng khám mề đay 001', 'doctor': 'BS. Nguyễn Văn A'},
//       {'name': 'Phòng khám mề đay 002', 'doctor': 'BS. Trần Thị B'},
//       {'name': 'Phòng khám mề đay 003', 'doctor': 'BS. Lê Văn C'},
//     ];
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Chọn phòng khám'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Bệnh nhân: ${record.patientName}'),
//             Text('Loại: ${record.typeDisplayName}'),
//             const SizedBox(height: 16),
//             ...rooms.map((room) => ListTile(
//                   title: Text(room['name']!),
//                   subtitle: Text(room['doctor']!),
//                   onTap: () {
//                     Navigator.pop(context);
//                     _approveAndDirectPatient(
//                         record, room['name']!, room['doctor']!);
//                   },
//                 )),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Hủy'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _approveAndDirectPatient(
//     MedicalRecordModel record,
//     String roomName,
//     String doctorName,
//   ) {
//     // Update record status and assign doctor/room
//     final updatedRecord = record.copyWith(
//       status: MedicalRecordStatus.pendingApproval,
//       doctorName: doctorName,
//       roomNumber: roomName,
//       queueNumber: DateTime.now().millisecondsSinceEpoch % 100,
//       queueTime: DateTime.now(),
//       updatedAt: DateTime.now(),
//     );
//
//     context.read<MedicalRecordCubit>().updateRecord(updatedRecord);
//
//     // Send notification to patient
//     context.read<NotificationCubit>().sendRoomAssignmentNotification(
//           record.patientId,
//           roomName,
//         );
//
//     // Send notification to doctor
//     context.read<NotificationCubit>().addNotification(
//           NotificationModel(
//             id: DateTime.now().millisecondsSinceEpoch.toString(),
//             userId: 'doctor1', // Should be actual doctor ID
//             title: 'Bệnh nhân mới được điều hướng',
//             message:
//                 'Bệnh nhân ${record.patientName} đã được điều hướng đến $roomName',
//             type: NotificationType.patientDirected,
//             createdAt: DateTime.now(),
//           ),
//         );
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//             'Đã duyệt và điều hướng bệnh nhân ${record.patientName} đến $roomName'),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }
// }
