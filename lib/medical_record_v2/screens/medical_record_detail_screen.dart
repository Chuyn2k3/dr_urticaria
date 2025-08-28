// import 'package:dr_urticaria/medical_record_v2/screens/medical_records_list_screen.dart';
// import 'package:dr_urticaria/widget/appbar/custom_app_bar.dart';
// import 'package:dr_urticaria/widget/base_scaffold.dart';
// import 'package:flutter/material.dart';

// class MedicalRecordDetailScreen extends StatelessWidget {
//   final MedicalRecordItem record;

//   const MedicalRecordDetailScreen({
//     super.key,
//     required this.record,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final typeInfo = _getTypeInfo(record.type);
//     final statusInfo = _getStatusInfo(record.status);

//     return BaseScaffold(
//       appBar: CustomAppbar.basic(
//         title: 'Chi tiết bệnh án',
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () {
//               // Navigate to edit form
//               _navigateToEditForm(context);
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.share),
//             onPressed: () {
//               // Share functionality
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Status Header Card
//             _buildStatusCard(typeInfo, statusInfo),
//             const SizedBox(height: 16),

//             // Patient Information
//             _buildInfoCard(
//               'Thông tin bệnh nhân',
//               Icons.person,
//               const Color(0xFF3B82F6),
//               [
//                 _buildInfoRow('Họ và tên', record.patientName),
//                 _buildInfoRow('Mã bệnh nhân', record.patientId),
//                 _buildInfoRow('Ngày tạo', _formatDateTime(record.createdDate)),
//                 _buildInfoRow('Loại bệnh án', typeInfo['label']),
//                 _buildInfoRow('Bác sĩ điều trị', record.doctorName),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // Symptoms
//             if (record.symptoms.isNotEmpty)
//               _buildInfoCard(
//                 'Triệu chứng',
//                 Icons.medical_services,
//                 const Color(0xFFEF4444),
//                 [
//                   _buildInfoText(record.symptoms),
//                 ],
//               ),
//             const SizedBox(height: 16),

//             // Diagnosis
//             if (record.diagnosis.isNotEmpty)
//               _buildInfoCard(
//                 'Chẩn đoán',
//                 Icons.medical_information,
//                 const Color(0xFF10B981),
//                 [
//                   _buildInfoText(record.diagnosis),
//                 ],
//               ),
//             const SizedBox(height: 16),

//             // Mock detailed information based on type
//             ..._buildDetailedInfo(),

//             const SizedBox(height: 32),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusCard(
//       Map<String, dynamic> typeInfo, Map<String, dynamic> statusInfo) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             statusInfo['color'],
//             statusInfo['color'].withOpacity(0.8),
//           ],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: statusInfo['color'].withOpacity(0.3),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(typeInfo['icon'], color: Colors.white, size: 32),
//               const SizedBox(width: 12),
//               Icon(statusInfo['icon'], color: Colors.white, size: 32),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             '${typeInfo['label']} - ${statusInfo['label']}',
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             'Cập nhật: ${_formatDateTime(record.createdDate)}',
//             style: const TextStyle(
//               color: Colors.white70,
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoCard(
//     String title,
//     IconData icon,
//     Color color,
//     List<Widget> children,
//   ) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(icon, color: color, size: 20),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1F2937),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           ...children,
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey.shade600,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           const Text(': ', style: TextStyle(fontSize: 14)),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Color(0xFF1F2937),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoText(String text) {
//     return Text(
//       text,
//       style: const TextStyle(
//         fontSize: 14,
//         color: Color(0xFF1F2937),
//         height: 1.5,
//       ),
//     );
//   }

//   List<Widget> _buildDetailedInfo() {
//     // Mock detailed information based on record type
//     switch (record.type) {
//       case 'acute':
//         return [
//           _buildInfoCard(
//             'Thông tin cấp tính',
//             Icons.flash_on,
//             const Color(0xFFEF4444),
//             [
//               _buildInfoRow('Thời gian khởi phát', '< 6 tuần'),
//               _buildInfoRow('Loại tổn thương', 'Sẩn phù + Phù mạch'),
//               _buildInfoRow('Yếu tố kích thích', 'Thức ăn, thuốc'),
//               _buildInfoRow('Điều trị', 'Antihistamine H1'),
//             ],
//           ),
//         ];
//       case 'chronic_initial':
//         return [
//           _buildInfoCard(
//             'Thông tin mãn tính lần 1',
//             Icons.schedule,
//             const Color(0xFF3B82F6),
//             [
//               _buildInfoRow('Thời gian khởi phát', '≥ 6 tuần'),
//               _buildInfoRow('Số đợt bệnh', '≥ 2 lần/tuần'),
//               _buildInfoRow('Test da vẽ nổi', 'Dương tính'),
//               _buildInfoRow('Điểm UCT', '8/16'),
//             ],
//           ),
//           const SizedBox(height: 16),
//           _buildInfoCard(
//             'Xét nghiệm',
//             Icons.science,
//             const Color(0xFF8B5CF6),
//             [
//               _buildInfoRow('WBC', '8.5 x10³/μL'),
//               _buildInfoRow('CRP', '< 3 mg/L'),
//               _buildInfoRow('Total IgE', '150 IU/mL'),
//               _buildInfoRow('TSH', '2.1 mIU/L'),
//             ],
//           ),
//         ];
//       case 'chronic_followup':
//         return [
//           _buildInfoCard(
//             'Theo dõi tái khám',
//             Icons.refresh,
//             const Color(0xFF10B981),
//             [
//               _buildInfoRow('Điểm UAS7', '12/42'),
//               _buildInfoRow('Điểm UCT', '12/16'),
//               _buildInfoRow('Đáp ứng điều trị', 'Tốt'),
//               _buildInfoRow('Tác dụng phụ', 'Không'),
//             ],
//           ),
//         ];
//       default:
//         return [];
//     }
//   }

//   void _navigateToEditForm(BuildContext context) {
//     // Navigate to appropriate edit form based on record type
//     switch (record.type) {
//       case 'acute':
//         // Navigator.push to AcuteUrticariaFormScreen with edit mode
//         break;
//       case 'chronic_initial':
//         // Navigator.push to ChronicUrticariaInitialFormScreen with edit mode
//         break;
//       case 'chronic_followup':
//         // Navigator.push to ChronicUrticariaFollowupFormScreen with edit mode
//         break;
//     }
//   }

//   Map<String, dynamic> _getTypeInfo(String type) {
//     switch (type) {
//       case 'acute':
//         return {
//           'label': 'Cấp tính',
//           'color': const Color(0xFFEF4444),
//           'icon': Icons.flash_on,
//         };
//       case 'chronic_initial':
//         return {
//           'label': 'Mãn tính L1',
//           'color': const Color(0xFF3B82F6),
//           'icon': Icons.schedule,
//         };
//       case 'chronic_followup':
//         return {
//           'label': 'Tái khám',
//           'color': const Color(0xFF10B981),
//           'icon': Icons.refresh,
//         };
//       default:
//         return {
//           'label': 'Khác',
//           'color': Colors.grey,
//           'icon': Icons.help,
//         };
//     }
//   }

//   Map<String, dynamic> _getStatusInfo(String status) {
//     switch (status) {
//       case 'completed':
//         return {
//           'label': 'Hoàn thành',
//           'color': const Color(0xFF10B981),
//           'icon': Icons.check_circle,
//         };
//       case 'pending':
//         return {
//           'label': 'Chờ xử lý',
//           'color': const Color(0xFFF59E0B),
//           'icon': Icons.schedule,
//         };
//       case 'in_progress':
//         return {
//           'label': 'Đang xử lý',
//           'color': const Color(0xFF3B82F6),
//           'icon': Icons.hourglass_empty,
//         };
//       default:
//         return {
//           'label': 'Không xác định',
//           'color': Colors.grey,
//           'icon': Icons.help,
//         };
//     }
//   }

//   String _formatDateTime(DateTime date) {
//     return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
//   }
// }
