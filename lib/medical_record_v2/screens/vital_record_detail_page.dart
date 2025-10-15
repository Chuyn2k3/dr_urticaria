// import 'package:dr_urticaria/core/repositories/vital_record_repository.dart';
// import 'package:dr_urticaria/cubits/appointment/appointment_update_status_cubit.dart';
// import 'package:dr_urticaria/cubits/vital_record_detail_cubit.dart';
// import 'package:dr_urticaria/cubits/vital_record_detail_state.dart';
// import 'package:dr_urticaria/medical_record_v2/widgets/vital_field_editor.dart';
// import 'package:dr_urticaria/core/repositories/appointments_repository.dart';
// import 'package:dr_urticaria/utils/enum/appointment_enum.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class VitalRecordDetailPage extends StatelessWidget {
//   final int medicalRecordId;
//   final int appointmentId;
//   final AppointmentStatus selectedStatus;
//   const VitalRecordDetailPage({
//     super.key,
//     required this.medicalRecordId,
//     required this.selectedStatus,
//     required this.appointmentId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (_) =>
//               VitalRecordDetailCubit(medicalRecordId: medicalRecordId)..load(),
//         ),
//         BlocProvider(
//           create: (ctx) => AppointmentUpdateStatusCubit(),
//         ),
//       ],
//       child: _VitalRecordDetailView(
//         appointmentId: appointmentId,
//         medicalRecordId: medicalRecordId,
//         selectedStatus: selectedStatus,
//       ),
//     );
//   }
// }

// class _VitalRecordDetailView extends StatelessWidget {
//   final int appointmentId;
//   final int medicalRecordId;
//   final AppointmentStatus selectedStatus;
//   const _VitalRecordDetailView(
//       {required this.appointmentId,
//       required this.selectedStatus,
//       required this.medicalRecordId});

//   @override
//   Widget build(BuildContext context) {
//     final color = Theme.of(context).colorScheme.primary;
//     return MultiBlocListener(
//       listeners: [
//         BlocListener<VitalRecordDetailCubit, VitalRecordDetailState>(
//           listener: (context, state) {
//             if (state.success) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: const Text('Cập nhật thành công!'),
//                   backgroundColor: color,
//                   duration: const Duration(seconds: 2),
//                 ),
//               );
//             }
//           },
//         ),
//         BlocListener<AppointmentUpdateStatusCubit,
//             AppointmentUpdateStatusState>(
//           listener: (context, state) {
//             if (state is AppointmentUpdateStatusSuccess) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content:
//                       Text('Trạng thái đổi thành: ${state.appointment.status}'),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//             } else if (state is AppointmentUpdateStatusFailure) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('Lỗi: ${state.message}'),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             }
//           },
//         ),
//       ],
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Chi tiết bệnh án'),
//           backgroundColor: color,
//           foregroundColor: Colors.white,
//         ),
//         body: BlocBuilder<VitalRecordDetailCubit, VitalRecordDetailState>(
//           builder: (context, state) {
//             if (state.loading && state.groups.isEmpty) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (state.error != null) {
//               return Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('Lỗi: ${state.error}', textAlign: TextAlign.center),
//                       const SizedBox(height: 12),
//                       FilledButton.icon(
//                         onPressed: () =>
//                             context.read<VitalRecordDetailCubit>().load(),
//                         icon: const Icon(Icons.refresh),
//                         label: const Text('Thử lại'),
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             }

//             return RefreshIndicator(
//               onRefresh: () => context.read<VitalRecordDetailCubit>().load(),
//               child: ListView.separated(
//                 padding: const EdgeInsets.all(12),
//                 separatorBuilder: (_, __) => const SizedBox(height: 12),
//                 itemCount: state.groups.length,
//                 itemBuilder: (context, index) {
//                   final g = state.groups[index];
//                   return Card(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16)),
//                     elevation: 2,
//                     child: ExpansionTile(
//                       title: Text(g.group.name,
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                       childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//                       children: [
//                         ...g.items.map((item) {
//                           print("huhu ${item.indicator.toJson()}");
//                           final vitalId = item.value.vitalIndicatorId;
//                           final current = state.editedValues[vitalId] ??
//                               item.value.value ??
//                               "";
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         item.indicator.name,
//                                         style: const TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     ),
//                                     if (item.indicator.unit != null)
//                                       Text(item.indicator.unit!,
//                                           style: TextStyle(
//                                               color: Colors.grey[600])),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 8),
//                                 VitalFieldEditor(
//                                   indicator: item.indicator,
//                                   value: current,
//                                   unit: item.indicator.unit,
//                                   onChanged: (val) => context
//                                       .read<VitalRecordDetailCubit>()
//                                       .editValue(
//                                         vitalValueId: vitalId,
//                                         newValue: val,
//                                       ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 TextField(
//                                   decoration: InputDecoration(
//                                     hintText: 'Ghi chú',
//                                     prefixIcon:
//                                         const Icon(Icons.note_alt_outlined),
//                                     border: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(12)),
//                                   ),
//                                   controller: TextEditingController(
//                                       text: state.editedNotes[vitalId] ??
//                                           item.value.note ??
//                                           ''),
//                                   onChanged: (v) => context
//                                       .read<VitalRecordDetailCubit>()
//                                       .editNote(
//                                         vitalValueId: vitalId,
//                                         note: v,
//                                       ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Align(
//                                   alignment: Alignment.centerRight,
//                                   child: Text(
//                                     item.indicator.code,
//                                     style: TextStyle(
//                                         fontSize: 12, color: Colors.grey[600]),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           );
//                         }).toList(),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//         bottomNavigationBar: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 FilledButton.icon(
//                   onPressed: () =>
//                       context.read<VitalRecordDetailCubit>().saveAll(),
//                   icon: const Icon(Icons.save_outlined),
//                   label: const Text('Lưu tất cả thay đổi'),
//                 ),
//                 const SizedBox(height: 8),
//                 if (selectedStatus != AppointmentStatus.cancelled)
//                   BlocBuilder<AppointmentUpdateStatusCubit,
//                       AppointmentUpdateStatusState>(
//                     builder: (context, state) {
//                       final loading = state is AppointmentUpdateStatusLoading;
//                       return FilledButton.icon(
//                         onPressed: loading
//                             ? null
//                             : () => context
//                                 .read<AppointmentUpdateStatusCubit>()
//                                 .updateStatus(
//                                   appointmentId,
//                                   getNextStatus(selectedStatus),
//                                 ),
//                         icon: const Icon(Icons.check_circle_outline),
//                         label: loading
//                             ? const Text("Đang cập nhật...")
//                             : const Text("Xác nhận lịch hẹn"),
//                       );
//                     },
//                   ),
//                 if (selectedStatus == AppointmentStatus.pending)
//                   BlocBuilder<AppointmentUpdateStatusCubit,
//                       AppointmentUpdateStatusState>(
//                     builder: (context, state) {
//                       final loading = state is AppointmentUpdateStatusLoading;

//                       return FilledButton.icon(
//                         style: FilledButton.styleFrom(
//                           backgroundColor:
//                               Colors.red, // 🔴 màu cảnh báo khi hủy
//                         ),
//                         onPressed: loading
//                             ? null
//                             : () => context
//                                 .read<AppointmentUpdateStatusCubit>()
//                                 .updateStatus(
//                                   appointmentId,
//                                   AppointmentStatus.cancelled,
//                                 ),
//                         icon: const Icon(Icons.cancel_outlined), // ❌ icon hủy
//                         label: loading
//                             ? const Text("Đang hủy lịch...")
//                             : const Text("Hủy lịch hẹn"),
//                       );
//                     },
//                   )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   AppointmentStatus getNextStatus(AppointmentStatus selectedStatus) {
//     if (selectedStatus == AppointmentStatus.pending)
//       return AppointmentStatus.confirmed;

//     if (selectedStatus == AppointmentStatus.confirmed)
//       return AppointmentStatus.completed;
//     return AppointmentStatus.confirmed;
//   }
// }

// import 'package:dr_urticaria/core/repositories/vital_record_repository.dart';
// import 'package:dr_urticaria/cubits/appointment/appointment_update_status_cubit.dart';
// import 'package:dr_urticaria/cubits/vital_record_detail_cubit.dart';
// import 'package:dr_urticaria/cubits/vital_record_detail_state.dart';
// import 'package:dr_urticaria/medical_record_v2/widgets/vital_field_editor.dart';
// import 'package:dr_urticaria/core/repositories/appointments_repository.dart';
// import 'package:dr_urticaria/utils/enum/appointment_enum.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class VitalRecordDetailPage extends StatelessWidget {
//   final int medicalRecordId;
//   final int appointmentId;
//   final AppointmentStatus selectedStatus;
//   const VitalRecordDetailPage({
//     super.key,
//     required this.medicalRecordId,
//     required this.selectedStatus,
//     required this.appointmentId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (_) =>
//               VitalRecordDetailCubit(medicalRecordId: medicalRecordId)..load(),
//         ),
//         BlocProvider(
//           create: (ctx) => AppointmentUpdateStatusCubit(),
//         ),
//       ],
//       child: _VitalRecordDetailView(
//         appointmentId: appointmentId,
//         medicalRecordId: medicalRecordId,
//         selectedStatus: selectedStatus,
//       ),
//     );
//   }
// }

// class _VitalRecordDetailView extends StatelessWidget {
//   final int appointmentId;
//   final int medicalRecordId;
//   final AppointmentStatus selectedStatus;
//   const _VitalRecordDetailView({
//     required this.appointmentId,
//     required this.selectedStatus,
//     required this.medicalRecordId,
//   });

//   // ===== NHÓM TÁCH RIÊNG =====
//   static const Set<int> _diagnosisIds = {25, 22, 35, 32}; // Chuẩn đoán
//   static const Set<int> _labIds = {24}; // Xét nghiệm
//   static const Set<int> _treatmentIds = {41}; // Điều trị
//   static const Set<int> _followUpIds = {49, 37}; // Hẹn

//   @override
//   Widget build(BuildContext context) {
//     final color = Theme.of(context).colorScheme.primary;

//     return MultiBlocListener(
//       listeners: [
//         BlocListener<VitalRecordDetailCubit, VitalRecordDetailState>(
//           listener: (context, state) {
//             if (state.success) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: const Text('Cập nhật thành công!'),
//                   backgroundColor: color,
//                   duration: const Duration(seconds: 2),
//                 ),
//               );
//             }
//           },
//         ),
//         BlocListener<AppointmentUpdateStatusCubit,
//             AppointmentUpdateStatusState>(
//           listener: (context, state) {
//             if (state is AppointmentUpdateStatusSuccess) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content:
//                       Text('Trạng thái đổi thành: ${state.appointment.status}'),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//             } else if (state is AppointmentUpdateStatusFailure) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('Lỗi: ${state.message}'),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             }
//           },
//         ),
//       ],
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Chi tiết bệnh án'),
//           backgroundColor: color,
//           foregroundColor: Colors.white,
//         ),
//         body: BlocBuilder<VitalRecordDetailCubit, VitalRecordDetailState>(
//           builder: (context, state) {
//             if (state.loading && state.groups.isEmpty) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (state.error != null) {
//               return Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('Lỗi: ${state.error}', textAlign: TextAlign.center),
//                       const SizedBox(height: 12),
//                       FilledButton.icon(
//                         onPressed: () =>
//                             context.read<VitalRecordDetailCubit>().load(),
//                         icon: const Icon(Icons.refresh),
//                         label: const Text('Thử lại'),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }

//             // ====== HELPER: Lấy groupId an toàn từ object g ======
//             int _groupIdOf(dynamic g) {
//               try {
//                 final dynamic gg = g.group; // thường là object {id, name}
//                 final dynamic id = (gg?.id) ??
//                     (gg?.groupId) ??
//                     (gg?.group_id) ??
//                     (g.groupId) ??
//                     (g.id);
//                 if (id is int) return id;
//                 if (id is String) return int.tryParse(id) ?? -1;
//               } catch (_) {}
//               return -1;
//             }

//             // ====== HELPER: Card render 1 group ======
//             Widget _buildGroupCard(dynamic g) {
//               return Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 elevation: 2,
//                 child: ExpansionTile(
//                   title: Text(
//                     g.group.name,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//                   children: [
//                     ...g.items.map<Widget>((item) {
//                       // print("debug ${item.indicator.toJson()}");
//                       final vitalId = item.value.vitalIndicatorId;
//                       final current =
//                           state.editedValues[vitalId] ?? item.value.value ?? "";

//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     item.indicator.name,
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                                 if (item.indicator.unit != null)
//                                   Text(
//                                     item.indicator.unit!,
//                                     style: TextStyle(color: Colors.grey[600]),
//                                   ),
//                               ],
//                             ),
//                             const SizedBox(height: 8),
//                             VitalFieldEditor(
//                               indicator: item.indicator,
//                               value: current,
//                               unit: item.indicator.unit,
//                               onChanged: (val) => context
//                                   .read<VitalRecordDetailCubit>()
//                                   .editValue(
//                                     vitalValueId: vitalId,
//                                     newValue: val,
//                                   ),
//                             ),
//                             const SizedBox(height: 8),
//                             TextField(
//                               decoration: InputDecoration(
//                                 hintText: 'Ghi chú',
//                                 prefixIcon: const Icon(Icons.note_alt_outlined),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               controller: TextEditingController(
//                                 text: state.editedNotes[vitalId] ??
//                                     item.value.note ??
//                                     '',
//                               ),
//                               onChanged: (v) => context
//                                   .read<VitalRecordDetailCubit>()
//                                   .editNote(
//                                     vitalValueId: vitalId,
//                                     note: v,
//                                   ),
//                             ),
//                             const SizedBox(height: 4),
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: Text(
//                                 item.indicator.code,
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ],
//                 ),
//               );
//             }

//             // ====== HELPER: Header của từng khối ======
//             Widget _sectionHeader(String text, IconData icon) {
//               return Padding(
//                 padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
//                 child: Row(
//                   children: [
//                     Icon(icon,
//                         size: 18, color: Theme.of(context).colorScheme.primary),
//                     const SizedBox(width: 6),
//                     Text(
//                       text,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             void _addSection({
//               required String title,
//               required IconData icon,
//               required List<dynamic> groups,
//               required List<Widget> into,
//             }) {
//               if (groups.isEmpty) return;
//               into.add(_sectionHeader(title, icon));
//               for (final g in groups) {
//                 into.add(_buildGroupCard(g));
//               }
//             }

//             // ====== PHÂN NHÓM ======
//             final all = state.groups;
//             final diagnosis = <dynamic>[];
//             final lab = <dynamic>[];
//             final treatment = <dynamic>[];
//             final followUp = <dynamic>[];
//             final acute = <dynamic>[]; // còn lại

//             for (final g in all) {
//               final id = _groupIdOf(g);
//               if (_diagnosisIds.contains(id)) {
//                 diagnosis.add(g);
//               } else if (_labIds.contains(id)) {
//                 lab.add(g);
//               } else if (_treatmentIds.contains(id)) {
//                 treatment.add(g);
//               } else if (_followUpIds.contains(id)) {
//                 followUp.add(g);
//               } else {
//                 acute.add(g);
//               }
//             }

//             // ====== RENDER THEO 5 KHỐI ======
//             final items = <Widget>[];
//             _addSection(
//               title: 'Bệnh án cấp tính',
//               icon: Icons.local_hospital_outlined,
//               groups: acute,
//               into: items,
//             );
//             _addSection(
//               title: 'Chuẩn đoán',
//               icon: Icons.fact_check_outlined,
//               groups: diagnosis,
//               into: items,
//             );
//             _addSection(
//               title: 'Xét nghiệm',
//               icon: Icons.science_outlined,
//               groups: lab,
//               into: items,
//             );
//             _addSection(
//               title: 'Điều trị',
//               icon: Icons.medication_outlined,
//               groups: treatment,
//               into: items,
//             );
//             _addSection(
//               title: 'Hẹn',
//               icon: Icons.event_available_outlined,
//               groups: followUp,
//               into: items,
//             );

//             if (items.isEmpty) {
//               return const Center(
//                 child: Text('Không có dữ liệu hiển thị.'),
//               );
//             }

//             return RefreshIndicator(
//               onRefresh: () => context.read<VitalRecordDetailCubit>().load(),
//               child: ListView.separated(
//                 padding: const EdgeInsets.all(12),
//                 itemCount: items.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: 12),
//                 itemBuilder: (_, i) => items[i],
//               ),
//             );
//           },
//         ),
//         bottomNavigationBar: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 FilledButton.icon(
//                   onPressed: () =>
//                       context.read<VitalRecordDetailCubit>().saveAll(),
//                   icon: const Icon(Icons.save_outlined),
//                   label: const Text('Lưu tất cả thay đổi'),
//                 ),
//                 const SizedBox(height: 8),
//                 if (selectedStatus != AppointmentStatus.cancelled)
//                   BlocBuilder<AppointmentUpdateStatusCubit,
//                       AppointmentUpdateStatusState>(
//                     builder: (context, state) {
//                       final loading = state is AppointmentUpdateStatusLoading;
//                       return FilledButton.icon(
//                         onPressed: loading
//                             ? null
//                             : () => context
//                                 .read<AppointmentUpdateStatusCubit>()
//                                 .updateStatus(
//                                   appointmentId,
//                                   getNextStatus(selectedStatus),
//                                 ),
//                         icon: const Icon(Icons.check_circle_outline),
//                         label: loading
//                             ? const Text("Đang cập nhật...")
//                             : const Text("Xác nhận lịch hẹn"),
//                       );
//                     },
//                   ),
//                 if (selectedStatus == AppointmentStatus.pending)
//                   BlocBuilder<AppointmentUpdateStatusCubit,
//                       AppointmentUpdateStatusState>(
//                     builder: (context, state) {
//                       final loading = state is AppointmentUpdateStatusLoading;
//                       return FilledButton.icon(
//                         style: FilledButton.styleFrom(
//                           backgroundColor: Colors.red,
//                         ),
//                         onPressed: loading
//                             ? null
//                             : () => context
//                                 .read<AppointmentUpdateStatusCubit>()
//                                 .updateStatus(
//                                   appointmentId,
//                                   AppointmentStatus.cancelled,
//                                 ),
//                         icon: const Icon(Icons.cancel_outlined),
//                         label: loading
//                             ? const Text("Đang hủy lịch...")
//                             : const Text("Hủy lịch hẹn"),
//                       );
//                     },
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   AppointmentStatus getNextStatus(AppointmentStatus selectedStatus) {
//     if (selectedStatus == AppointmentStatus.pending) {
//       return AppointmentStatus.confirmed;
//     }
//     if (selectedStatus == AppointmentStatus.confirmed) {
//       return AppointmentStatus.completed;
//     }
//     return AppointmentStatus.confirmed;
//   }
// }
import 'package:dr_urticaria/cubits/appointment/appointment_update_status_cubit.dart';
import 'package:dr_urticaria/cubits/vital_record_detail_cubit.dart';
import 'package:dr_urticaria/cubits/vital_record_detail_state.dart';
import 'package:dr_urticaria/medical_record_v2/widgets/vital_field_editor.dart';
import 'package:dr_urticaria/utils/enum/appointment_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VitalRecordDetailPage extends StatelessWidget {
  final int medicalRecordId;
  final int appointmentId;
  final AppointmentStatus selectedStatus;
  const VitalRecordDetailPage({
    super.key,
    required this.medicalRecordId,
    required this.selectedStatus,
    required this.appointmentId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              VitalRecordDetailCubit(medicalRecordId: medicalRecordId)..load(),
        ),
        BlocProvider(create: (_) => AppointmentUpdateStatusCubit()),
      ],
      child: _VitalRecordDetailView(
        appointmentId: appointmentId,
        medicalRecordId: medicalRecordId,
        selectedStatus: selectedStatus,
      ),
    );
  }
}

class _VitalRecordDetailView extends StatefulWidget {
  final int appointmentId;
  final int medicalRecordId;
  final AppointmentStatus selectedStatus;
  const _VitalRecordDetailView({
    required this.appointmentId,
    required this.selectedStatus,
    required this.medicalRecordId,
  });

  @override
  State<_VitalRecordDetailView> createState() => _VitalRecordDetailViewState();
}

class _VitalRecordDetailViewState extends State<_VitalRecordDetailView> {
  // ===== PHÂN KHỐI NHÓM =====
  static const Set<int> _diagnosisIds = {25, 22, 35, 32}; // Chuẩn đoán
  static const Set<int> _labIds = {24}; // Xét nghiệm
  static const Set<int> _treatmentIds = {41}; // Điều trị
  static const Set<int> _followUpIds = {49, 37}; // Hẹn

  final PageController _pageController = PageController();
  final ScrollController _stepScroll = ScrollController();
  int _currentStep = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _stepScroll.dispose();
    super.dispose();
  }

  // -------------------- Helpers: ORDERING + KEYS --------------------

  int _safeInt(dynamic v, {int fallback = 1 << 30}) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }

  String _safeStr(dynamic v) => (v ?? '').toString();

  // Lấy groupId an toàn
  int _groupIdOf(dynamic g) {
    try {
      final gg = g.group;
      final id =
          (gg?.id) ?? (gg?.groupId) ?? (gg?.group_id) ?? (g.groupId) ?? (g.id);
      return _safeInt(id, fallback: -1);
    } catch (_) {
      return -1;
    }
  }

  // Lấy thứ tự group (order/sortOrder/position), fallback id, name
  int _groupOrderOf(dynamic g) {
    try {
      final gg = g.group;
      final order =
          (gg?.order) ?? (gg?.sortOrder) ?? (gg?.position) ?? (g.order);
      if (order != null) return _safeInt(order);
    } catch (_) {}
    final id = _groupIdOf(g);
    return id >= 0 ? id : _safeInt(_safeStr(g.group?.name).hashCode);
  }

  // So sánh mảng số
  int _cmpIntList(List<int> a, List<int> b) {
    final len = a.length > b.length ? a.length : b.length;
    for (int i = 0; i < len; i++) {
      final ai = i < a.length ? a[i] : -1;
      final bi = i < b.length ? b[i] : -1;
      if (ai != bi) return ai.compareTo(bi);
    }
    return 0;
  }

  // Parse "indicator.code" thành list số: "6.3.1" -> [6,3,1]
  List<int> _numsFromCode(String? code) {
    if (code == null || code.trim().isEmpty) return const [];
    final re = RegExp(r'\d+');
    return re.allMatches(code).map((m) => int.parse(m.group(0)!)).toList();
  }

  ({List<int> codeNums, String name, int id}) _itemOrderTuple(dynamic item) {
    final ind = item.indicator;
    final codeNums = _numsFromCode(ind.code);
    final name = _safeStr(ind.name);
    final id = _safeInt(item.value?.vitalIndicatorId ?? ind.id ?? -1,
        fallback: 1 << 29);
    return (codeNums: codeNums, name: name, id: id);
  }

  int _compareItems(dynamic a, dynamic b) {
    final ta = _itemOrderTuple(a);
    final tb = _itemOrderTuple(b);
    final c1 = _cmpIntList(ta.codeNums, tb.codeNums);
    if (c1 != 0) return c1;
    final c2 = ta.name.compareTo(tb.name);
    if (c2 != 0) return c2;
    return ta.id.compareTo(tb.id);
  }

  int _compareGroups(dynamic a, dynamic b) {
    final oa = _groupOrderOf(a);
    final ob = _groupOrderOf(b);
    if (oa != ob) return oa.compareTo(ob);
    final na = _safeStr(a.group?.name);
    final nb = _safeStr(b.group?.name);
    return na.compareTo(nb);
  }

  // Auto scroll step chips cho step hiện tại
  void _ensureStepVisible(int index, List<dynamic> ordered) {
    if (!_stepScroll.hasClients) return;
    // 100px/step ước lượng – đủ để canh giữa list
    final target = (index * 100.0) - 100;
    _stepScroll.animateTo(
      target.clamp(0, _stepScroll.position.maxScrollExtent),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _goTo(int index, int total, List<dynamic> ordered) {
    if (index < 0 || index >= total) return;
    setState(() => _currentStep = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _ensureStepVisible(index, ordered);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return MultiBlocListener(
      listeners: [
        BlocListener<VitalRecordDetailCubit, VitalRecordDetailState>(
          listener: (context, state) {
            if (state.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Cập nhật thành công!'),
                  backgroundColor: color,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
        ),
        BlocListener<AppointmentUpdateStatusCubit,
            AppointmentUpdateStatusState>(
          listener: (context, state) {
            if (state is AppointmentUpdateStatusSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Trạng thái đổi thành: ${state.appointment.status}'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is AppointmentUpdateStatusFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Lỗi: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chi tiết bệnh án'),
          backgroundColor: color,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<VitalRecordDetailCubit, VitalRecordDetailState>(
          builder: (context, state) {
            if (state.loading && state.groups.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Lỗi: ${state.error}', textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () =>
                            context.read<VitalRecordDetailCubit>().load(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // ----- Chuẩn hoá & sort group ổn định -----
            final all = List.of(state.groups);
            all.sort(_compareGroups);
            final totalSteps = all.length;

            // Fix currentStep khi data thay đổi
            if (_currentStep >= totalSteps) {
              _currentStep = (totalSteps - 1).clamp(0, totalSteps);
            }

            // Thanh step header (tap để nhảy)
            Widget _stepHeader() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiến độ
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: totalSteps == 0
                                  ? 0
                                  : (_currentStep + 1) / totalSteps,
                              minHeight: 8,
                              backgroundColor:
                                  Theme.of(context).colorScheme.surfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text('Bước ${_currentStep + 1}/$totalSteps',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13)),
                      ],
                    ),
                  ),
                  // Chips nhóm
                  SizedBox(
                    height: 48,
                    child: ListView.builder(
                      key: const PageStorageKey('step_header'),
                      controller: _stepScroll,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: all.length,
                      itemBuilder: (_, i) {
                        final g = all[i];
                        final isActive = i == _currentStep;
                        final name = _safeStr(g.group?.name);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor:
                                      isActive ? Colors.white : Colors.black26,
                                  child: Text(
                                    '${i + 1}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isActive ? color : Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            selected: isActive,
                            selectedColor: color,
                            backgroundColor:
                                Theme.of(context).colorScheme.surfaceVariant,
                            labelStyle: TextStyle(
                              color: isActive ? Colors.white : null,
                              fontWeight:
                                  isActive ? FontWeight.w700 : FontWeight.w500,
                            ),
                            onSelected: (_) => _goTo(i, totalSteps, all),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            // Nội dung 1 group (items được sort ổn định)
            Widget _groupBody(dynamic g) {
              final items = List.of(g.items)..sort(_compareItems);

              return ListView.builder(
                key: PageStorageKey('grp_${_groupIdOf(g)}'),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                itemCount: items.length,
                itemBuilder: (_, idx) {
                  final item = items[idx];
                  final vitalId = item.value.vitalIndicatorId;
                  final current =
                      state.editedValues[vitalId] ?? item.value.value ?? "";

                  return KeyedSubtree(
                    key: ValueKey('item_$vitalId'),
                    child: Card(
                      elevation: 1.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header item
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.indicator.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                if (item.indicator.unit != null)
                                  Text(
                                    item.indicator.unit!,
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 13),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Editor
                            VitalFieldEditor(
                              indicator: item.indicator,
                              value: current,
                              unit: item.indicator.unit,
                              onChanged: (val) => context
                                  .read<VitalRecordDetailCubit>()
                                  .editValue(
                                      vitalValueId: vitalId, newValue: val),
                            ),
                            const SizedBox(height: 8),
                            // Note
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Ghi chú',
                                prefixIcon: const Icon(Icons.note_alt_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              controller: TextEditingController(
                                text: state.editedNotes[vitalId] ??
                                    item.value.note ??
                                    '',
                              ),
                              onChanged: (v) => context
                                  .read<VitalRecordDetailCubit>()
                                  .editNote(vitalValueId: vitalId, note: v),
                            ),
                            const SizedBox(height: 6),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                item.indicator.code ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            // Main layout: header + PageView + step nav
            return Column(
              children: [
                _stepHeader(),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (i) {
                      setState(() => _currentStep = i);
                      _ensureStepVisible(i, all);
                    },
                    itemCount: all.length,
                    itemBuilder: (_, i) => _groupBody(all[i]),
                  ),
                ),
                // Nút điều hướng step
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _currentStep > 0
                              ? () => _goTo(_currentStep - 1, totalSteps, all)
                              : null,
                          icon: const Icon(Icons.chevron_left),
                          label: const Text('Quay lại'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _currentStep < totalSteps - 1
                              ? () => _goTo(_currentStep + 1, totalSteps, all)
                              : null,
                          icon: const Icon(Icons.chevron_right),
                          label: const Text('Tiếp theo'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        // Footer giữ nguyên: Save + đổi trạng thái
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilledButton.icon(
                  onPressed: () =>
                      context.read<VitalRecordDetailCubit>().saveAll(),
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Lưu tất cả thay đổi'),
                ),
                const SizedBox(height: 8),
                if (widget.selectedStatus != AppointmentStatus.cancelled)
                  BlocBuilder<AppointmentUpdateStatusCubit,
                      AppointmentUpdateStatusState>(
                    builder: (context, state) {
                      final loading = state is AppointmentUpdateStatusLoading;
                      return FilledButton.icon(
                        onPressed: loading
                            ? null
                            : () => context
                                .read<AppointmentUpdateStatusCubit>()
                                .updateStatus(
                                  widget.appointmentId,
                                  getNextStatus(widget.selectedStatus),
                                ),
                        icon: const Icon(Icons.check_circle_outline),
                        label: loading
                            ? const Text("Đang cập nhật...")
                            : const Text("Xác nhận lịch hẹn"),
                      );
                    },
                  ),
                if (widget.selectedStatus == AppointmentStatus.pending)
                  BlocBuilder<AppointmentUpdateStatusCubit,
                      AppointmentUpdateStatusState>(
                    builder: (context, state) {
                      final loading = state is AppointmentUpdateStatusLoading;
                      return FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: loading
                            ? null
                            : () => context
                                .read<AppointmentUpdateStatusCubit>()
                                .updateStatus(
                                  widget.appointmentId,
                                  AppointmentStatus.cancelled,
                                ),
                        icon: const Icon(Icons.cancel_outlined),
                        label: loading
                            ? const Text("Đang hủy lịch...")
                            : const Text("Hủy lịch hẹn"),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppointmentStatus getNextStatus(AppointmentStatus selectedStatus) {
    if (selectedStatus == AppointmentStatus.pending) {
      return AppointmentStatus.confirmed;
    }
    if (selectedStatus == AppointmentStatus.confirmed) {
      return AppointmentStatus.completed;
    }
    return AppointmentStatus.confirmed;
  }
}
