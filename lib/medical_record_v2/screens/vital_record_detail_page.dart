// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:dr_urticaria/cubits/appointment/appointment_update_status_cubit.dart';
// // import 'package:dr_urticaria/cubits/vital_record_detail_cubit.dart';
// // import 'package:dr_urticaria/cubits/vital_record_detail_state.dart';
// // import 'package:dr_urticaria/medical_record_v2/widgets/vital_field_editor.dart';
// // import 'package:dr_urticaria/utils/enum/appointment_enum.dart';

// // class VitalRecordDetailPage extends StatelessWidget {
// //   final int medicalRecordId;
// //   final int appointmentId;
// //   final AppointmentStatus selectedStatus;
// //   const VitalRecordDetailPage({
// //     super.key,
// //     required this.medicalRecordId,
// //     required this.selectedStatus,
// //     required this.appointmentId,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return MultiBlocProvider(
// //       providers: [
// //         BlocProvider(
// //           create: (_) =>
// //               VitalRecordDetailCubit(medicalRecordId: medicalRecordId)..load(),
// //         ),
// //         BlocProvider(create: (_) => AppointmentUpdateStatusCubit()),
// //       ],
// //       child: _VitalRecordDetailView(
// //         appointmentId: appointmentId,
// //         medicalRecordId: medicalRecordId,
// //         selectedStatus: selectedStatus,
// //       ),
// //     );
// //   }
// // }

// // class _VitalRecordDetailView extends StatefulWidget {
// //   final int appointmentId;
// //   final int medicalRecordId;
// //   final AppointmentStatus selectedStatus;
// //   const _VitalRecordDetailView({
// //     required this.appointmentId,
// //     required this.selectedStatus,
// //     required this.medicalRecordId,
// //   });

// //   @override
// //   State<_VitalRecordDetailView> createState() => _VitalRecordDetailViewState();
// // }

// // class _VitalRecordDetailViewState extends State<_VitalRecordDetailView>
// //     with TickerProviderStateMixin {
// //   // ===== PHÂN LOẠI GROUP ID =====
// //   static const Set<int> _diagnosisIds = {25, 22, 35, 32}; // Chuẩn đoán
// //   static const Set<int> _labIds = {24}; // Xét nghiệm
// //   static const Set<int> _treatmentIds = {41}; // Điều trị
// //   static const Set<int> _followUpIds = {49, 37}; // Hẹn

// //   late final TabController _tabController;

// //   // Giữ controller ghi chú bền vững
// //   final Map<int, TextEditingController> _noteControllers = {};

// //   TextEditingController _noteCtrl(int vitalId, String initialText) {
// //     final exist = _noteControllers[vitalId];
// //     if (exist != null) {
// //       if (exist.text != initialText) {
// //         exist.value = TextEditingValue(
// //           text: initialText,
// //           selection: TextSelection.collapsed(offset: initialText.length),
// //         );
// //       }
// //       return exist;
// //     }
// //     final c = TextEditingController(text: initialText);
// //     _noteControllers[vitalId] = c;
// //     return c;
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     _tabController = TabController(length: 5, vsync: this);
// //   }

// //   @override
// //   void dispose() {
// //     _tabController.dispose();
// //     for (final c in _noteControllers.values) c.dispose();
// //     super.dispose();
// //   }

// //   // ===== HELPER: Lấy groupId an toàn =====
// //   int _groupIdOf(dynamic g) {
// //     try {
// //       final gg = g.group;
// //       final id =
// //           (gg?.id) ?? (gg?.groupId) ?? (gg?.group_id) ?? (g.groupId) ?? (g.id);
// //       if (id is int) return id;
// //       if (id is String) return int.tryParse(id) ?? -1;
// //     } catch (_) {}
// //     return -1;
// //   }

// //   // ===== PHÂN NHÓM =====
// //   List<dynamic> _filterGroups(List<dynamic> all, Set<int> ids) {
// //     return all.where((g) => ids.contains(_groupIdOf(g))).toList();
// //   }

// //   List<dynamic> _normalGroups(List<dynamic> all) {
// //     final special = {
// //       ..._diagnosisIds,
// //       ..._labIds,
// //       ..._treatmentIds,
// //       ..._followUpIds
// //     };
// //     return all.where((g) => !special.contains(_groupIdOf(g))).toList();
// //   }

// //   // ===== RENDER 1 GROUP DẠNG EXPANSION TILE ĐẸP =====
// //   Widget _buildGroupCard(dynamic g, VitalRecordDetailState state) {
// //     final items = List.of(g.items);
// //     // Sort items theo code (6.1.1 > 6.1.2 ...)
// //     items.sort((a, b) {
// //       final codeA = a.indicator.code ?? '';
// //       final codeB = b.indicator.code ?? '';
// //       return codeA.compareTo(codeB);
// //     });

// //     return Card(
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //       elevation: 2,
// //       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //       child: ExpansionTile(
// //         title: Text(
// //           g.group?.name ?? 'Nhóm không tên',
// //           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //         ),
// //         childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
// //         children: items.map<Widget>((item) {
// //           final vitalId = item.value?.vitalIndicatorId ?? 0;
// //           final current =
// //               state.editedValues[vitalId] ?? item.value?.value ?? "";
// //           final noteText = state.editedNotes[vitalId] ?? item.value?.note ?? '';
// //           final noteController = _noteCtrl(vitalId, noteText);

// //           return Padding(
// //             padding: const EdgeInsets.symmetric(vertical: 8.0),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Expanded(
// //                       child: Text(
// //                         item.indicator?.name ?? '',
// //                         style: const TextStyle(
// //                             fontSize: 16, fontWeight: FontWeight.w600),
// //                       ),
// //                     ),
// //                     if (item.indicator?.unit != null)
// //                       Text(
// //                         item.indicator!.unit!,
// //                         style: TextStyle(color: Colors.grey[600]),
// //                       ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 8),
// //                 VitalFieldEditor(
// //                   indicator: item.indicator,
// //                   value: current,
// //                   unit: item.indicator?.unit,
// //                   onChanged: (val) => context
// //                       .read<VitalRecordDetailCubit>()
// //                       .editValue(vitalValueId: vitalId, newValue: val),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 TextField(
// //                   decoration: InputDecoration(
// //                     hintText: 'Ghi chú',
// //                     prefixIcon: const Icon(Icons.note_alt_outlined),
// //                     border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.circular(12)),
// //                   ),
// //                   controller: noteController,
// //                   minLines: 1,
// //                   maxLines: 4,
// //                   onChanged: (v) => context
// //                       .read<VitalRecordDetailCubit>()
// //                       .editNote(vitalValueId: vitalId, note: v),
// //                 ),
// //                 const SizedBox(height: 4),
// //                 Align(
// //                   alignment: Alignment.centerRight,
// //                   child: Text(
// //                     item.indicator?.code ?? '',
// //                     style: TextStyle(fontSize: 12, color: Colors.grey[600]),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           );
// //         }).toList(),
// //       ),
// //     );
// //   }

// //   // ===== RENDER TOÀN BỘ TAB =====
// //   Widget _buildTabContent(List<dynamic> groups, VitalRecordDetailState state,
// //       {String emptyText = 'Không có dữ liệu'}) {
// //     if (groups.isEmpty) {
// //       return Center(
// //           child: Text(emptyText, style: const TextStyle(fontSize: 16)));
// //     }

// //     return ListView.separated(
// //       padding: const EdgeInsets.all(12),
// //       itemCount: groups.length,
// //       separatorBuilder: (_, __) => const SizedBox(height: 8),
// //       itemBuilder: (_, i) => _buildGroupCard(groups[i], state),
// //     );
// //   }

// //   // ===== TAB XÉT NGHIỆM RIÊNG (UI như ảnh) =====
// //   Widget _buildLabTab(VitalRecordDetailState state, List<dynamic> all) {
// //     final labGroups = _filterGroups(all, _labIds);
// //     if (labGroups.isEmpty) {
// //       return const Center(child: Text('Không có dữ liệu xét nghiệm'));
// //     }

// //     return SingleChildScrollView(
// //       padding: const EdgeInsets.all(16),
// //       child: Column(
// //         children: [
// //           _buildLabSection('Yêu cầu', labGroups, state),
// //           _buildLabSection('Kết quả', labGroups, state),
// //           _buildLabSection('Đính kèm', labGroups, state),
// //           _buildLabSection('Hẹn', labGroups, state),
// //           const SizedBox(height: 100),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildLabSection(
// //       String title, List<dynamic> groups, VitalRecordDetailState state) {
// //     return Card(
// //       margin: const EdgeInsets.only(bottom: 12),
// //       child: ExpansionTile(
// //         title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
// //         children: groups.expand((g) {
// //           final items = List.of(g.items);
// //           items.sort((a, b) =>
// //               (a.indicator.code ?? '').compareTo(b.indicator.code ?? ''));
// //           return items.map((item) {
// //             final vitalId = item.value?.vitalIndicatorId ?? 0;
// //             final current =
// //                 state.editedValues[vitalId] ?? item.value?.value ?? "";
// //             final noteText =
// //                 state.editedNotes[vitalId] ?? item.value?.note ?? '';
// //             final noteController = _noteCtrl(vitalId, noteText);

// //             return Padding(
// //               padding: const EdgeInsets.all(12),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(item.indicator?.name ?? '',
// //                       style: const TextStyle(fontWeight: FontWeight.w500)),
// //                   const SizedBox(height: 8),
// //                   VitalFieldEditor(
// //                     indicator: item.indicator,
// //                     value: current,
// //                     unit: item.indicator?.unit,
// //                     onChanged: (val) => context
// //                         .read<VitalRecordDetailCubit>()
// //                         .editValue(vitalValueId: vitalId, newValue: val),
// //                   ),
// //                   const SizedBox(height: 8),
// //                   TextField(
// //                     decoration: InputDecoration(
// //                       hintText: 'Ghi chú',
// //                       border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(8)),
// //                     ),
// //                     controller: noteController,
// //                     minLines: 1,
// //                     maxLines: 3,
// //                     onChanged: (v) => context
// //                         .read<VitalRecordDetailCubit>()
// //                         .editNote(vitalValueId: vitalId, note: v),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           });
// //         }).toList(),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final color = Theme.of(context).colorScheme.primary;

// //     return MultiBlocListener(
// //       listeners: [
// //         BlocListener<VitalRecordDetailCubit, VitalRecordDetailState>(
// //           listener: (context, state) {
// //             if (state.success) {
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 SnackBar(
// //                     content: const Text('Cập nhật thành công!'),
// //                     backgroundColor: color),
// //               );
// //             }
// //           },
// //         ),
// //         BlocListener<AppointmentUpdateStatusCubit,
// //             AppointmentUpdateStatusState>(
// //           listener: (context, state) {
// //             if (state is AppointmentUpdateStatusSuccess) {
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 SnackBar(
// //                     content: Text('Trạng thái: ${state.appointment.status}'),
// //                     backgroundColor: Colors.green),
// //               );
// //             } else if (state is AppointmentUpdateStatusFailure) {
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 SnackBar(
// //                     content: Text('Lỗi: ${state.message}'),
// //                     backgroundColor: Colors.red),
// //               );
// //             }
// //           },
// //         ),
// //       ],
// //       child: Scaffold(
// //         appBar: AppBar(
// //           title: const Text('Chi tiết bệnh án'),
// //           backgroundColor: color,
// //           foregroundColor: Colors.white,
// //           bottom: TabBar(
// //             controller: _tabController,
// //             isScrollable: true,
// //             tabAlignment: TabAlignment.start,
// //             tabs: const [
// //               Tab(text: 'Thông tin bệnh án'),
// //               Tab(text: 'Chuẩn đoán'),
// //               Tab(text: 'Xét nghiệm'),
// //               Tab(text: 'Điều trị'),
// //               Tab(text: 'Hẹn'),
// //             ],
// //           ),
// //         ),
// //         body: BlocBuilder<VitalRecordDetailCubit, VitalRecordDetailState>(
// //           builder: (context, state) {
// //             if (state.loading && state.groups.isEmpty) {
// //               return const Center(child: CircularProgressIndicator());
// //             }
// //             if (state.error != null) {
// //               return Center(
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Text('Lỗi: ${state.error}'),
// //                     const SizedBox(height: 12),
// //                     FilledButton.icon(
// //                       onPressed: () =>
// //                           context.read<VitalRecordDetailCubit>().load(),
// //                       icon: const Icon(Icons.refresh),
// //                       label: const Text('Thử lại'),
// //                     ),
// //                   ],
// //                 ),
// //               );
// //             }

// //             final all = List.of(state.groups);
// //             final normal = _normalGroups(all);
// //             final diagnosis = _filterGroups(all, _diagnosisIds);
// //             final treatment = _filterGroups(all, _treatmentIds);
// //             final followUp = _filterGroups(all, _followUpIds);

// //             return TabBarView(
// //               controller: _tabController,
// //               children: [
// //                 // Tab 1: Thông tin bệnh án
// //                 _buildTabContent(normal, state,
// //                     emptyText: 'Không có thông tin bệnh án'),

// //                 // Tab 2: Chuẩn đoán
// //                 _buildTabContent(diagnosis, state,
// //                     emptyText: 'Chưa có chuẩn đoán'),

// //                 // Tab 3: Xét nghiệm (UI riêng)
// //                 _buildLabTab(state, all),

// //                 // Tab 4: Điều trị
// //                 _buildTabContent(treatment, state,
// //                     emptyText: 'Chưa có điều trị'),

// //                 // Tab 5: Hẹn
// //                 _buildTabContent(followUp, state,
// //                     emptyText: 'Chưa có lịch hẹn'),
// //               ],
// //             );
// //           },
// //         ),
// //         bottomNavigationBar: SafeArea(
// //           child: Padding(
// //             padding: const EdgeInsets.all(12),
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 FilledButton.icon(
// //                   onPressed: () =>
// //                       context.read<VitalRecordDetailCubit>().saveAll(),
// //                   icon: const Icon(Icons.save_outlined),
// //                   label: const Text('Lưu tất cả thay đổi'),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 if (widget.selectedStatus != AppointmentStatus.cancelled)
// //                   BlocBuilder<AppointmentUpdateStatusCubit,
// //                       AppointmentUpdateStatusState>(
// //                     builder: (context, state) {
// //                       final loading = state is AppointmentUpdateStatusLoading;
// //                       return FilledButton.icon(
// //                         onPressed: loading
// //                             ? null
// //                             : () => context
// //                                 .read<AppointmentUpdateStatusCubit>()
// //                                 .updateStatus(
// //                                   widget.appointmentId,
// //                                   getNextStatus(widget.selectedStatus),
// //                                 ),
// //                         icon: const Icon(Icons.check_circle_outline),
// //                         label: loading
// //                             ? const Text("Đang cập nhật...")
// //                             : const Text("Xác nhận lịch hẹn"),
// //                       );
// //                     },
// //                   ),
// //                 if (widget.selectedStatus == AppointmentStatus.pending)
// //                   BlocBuilder<AppointmentUpdateStatusCubit,
// //                       AppointmentUpdateStatusState>(
// //                     builder: (context, state) {
// //                       final loading = state is AppointmentUpdateStatusLoading;
// //                       return FilledButton.icon(
// //                         style:
// //                             FilledButton.styleFrom(backgroundColor: Colors.red),
// //                         onPressed: loading
// //                             ? null
// //                             : () => context
// //                                 .read<AppointmentUpdateStatusCubit>()
// //                                 .updateStatus(
// //                                   widget.appointmentId,
// //                                   AppointmentStatus.cancelled,
// //                                 ),
// //                         icon: const Icon(Icons.cancel_outlined),
// //                         label: loading
// //                             ? const Text("Đang hủy...")
// //                             : const Text("Hủy lịch hẹn"),
// //                       );
// //                     },
// //                   ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   AppointmentStatus getNextStatus(AppointmentStatus selectedStatus) {
// //     if (selectedStatus == AppointmentStatus.pending)
// //       return AppointmentStatus.confirmed;
// //     if (selectedStatus == AppointmentStatus.confirmed)
// //       return AppointmentStatus.completed;
// //     return AppointmentStatus.confirmed;
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dr_urticaria/cubits/vital_record_detail_cubit.dart';
// import 'package:dr_urticaria/cubits/vital_record_detail_state.dart';
// import 'package:dr_urticaria/medical_record_v2/widgets/vital_field_editor.dart';

// class VitalRecordDetailPage extends StatelessWidget {
//   final int medicalRecordId;

//   const VitalRecordDetailPage({
//     super.key,
//     required this.medicalRecordId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) =>
//           VitalRecordDetailCubit(medicalRecordId: medicalRecordId)..load(),
//       child: _VitalRecordDetailView(
//         medicalRecordId: medicalRecordId,
//       ),
//     );
//   }
// }

// class _VitalRecordDetailView extends StatefulWidget {
//   final int medicalRecordId;

//   const _VitalRecordDetailView({
//     required this.medicalRecordId,
//   });

//   @override
//   State<_VitalRecordDetailView> createState() => _VitalRecordDetailViewState();
// }

// class _VitalRecordDetailViewState extends State<_VitalRecordDetailView>
//     with TickerProviderStateMixin {
//   // giống code cũ
//   static const Set<int> _diagnosisIds = {25, 22, 35, 32};
//   static const Set<int> _labIds = {24};
//   static const Set<int> _treatmentIds = {41};
//   static const Set<int> _followUpIds = {49, 37};

//   late final TabController _tabController;
//   final Map<int, TextEditingController> _noteControllers = {};

//   TextEditingController _noteCtrl(int vitalId, String initialText) {
//     final exist = _noteControllers[vitalId];
//     if (exist != null) {
//       if (exist.text != initialText) {
//         exist.value = TextEditingValue(
//           text: initialText,
//           selection: TextSelection.collapsed(offset: initialText.length),
//         );
//       }
//       return exist;
//     }
//     final c = TextEditingController(text: initialText);
//     _noteControllers[vitalId] = c;
//     return c;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 5, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     for (final c in _noteControllers.values) c.dispose();
//     super.dispose();
//   }

//   int _groupIdOf(dynamic g) {
//     try {
//       final gg = g.group;
//       final id =
//           (gg?.id) ?? (gg?.groupId) ?? (gg?.group_id) ?? (g.groupId) ?? (g.id);
//       if (id is int) return id;
//       if (id is String) return int.tryParse(id) ?? -1;
//     } catch (_) {}
//     return -1;
//   }

//   List<dynamic> _filterGroups(List<dynamic> all, Set<int> ids) {
//     return all.where((g) => ids.contains(_groupIdOf(g))).toList();
//   }

//   List<dynamic> _normalGroups(List<dynamic> all) {
//     final special = {
//       ..._diagnosisIds,
//       ..._labIds,
//       ..._treatmentIds,
//       ..._followUpIds
//     };
//     return all.where((g) => !special.contains(_groupIdOf(g))).toList();
//   }

//   Widget _buildGroupCard(dynamic g, VitalRecordDetailState state) {
//     final items = List.of(g.items);
//     items.sort((a, b) {
//       final codeA = a.indicator.code ?? '';
//       final codeB = b.indicator.code ?? '';
//       return codeA.compareTo(codeB);
//     });

//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 2,
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       child: ExpansionTile(
//         title: Text(
//           g.group?.name ?? 'Nhóm không tên',
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//         children: items.map<Widget>((item) {
//           final vitalId = item.value?.vitalIndicatorId ?? 0;
//           final current =
//               state.editedValues[vitalId] ?? item.value?.value ?? "";
//           final noteText = state.editedNotes[vitalId] ?? item.value?.note ?? '';
//           final noteController = _noteCtrl(vitalId, noteText);

//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         item.indicator?.name ?? '',
//                         style: const TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                     if (item.indicator?.unit != null)
//                       Text(
//                         item.indicator!.unit!,
//                         style: TextStyle(color: Colors.grey[600]),
//                       ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 VitalFieldEditor(
//                   indicator: item.indicator,
//                   value: current,
//                   unit: item.indicator?.unit,
//                   onChanged: (val) => context
//                       .read<VitalRecordDetailCubit>()
//                       .editValue(vitalValueId: vitalId, newValue: val),
//                 ),
//                 const SizedBox(height: 8),
//                 TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Ghi chú',
//                     prefixIcon: const Icon(Icons.note_alt_outlined),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                   ),
//                   controller: noteController,
//                   minLines: 1,
//                   maxLines: 4,
//                   onChanged: (v) => context
//                       .read<VitalRecordDetailCubit>()
//                       .editNote(vitalValueId: vitalId, note: v),
//                 ),
//                 const SizedBox(height: 4),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: Text(
//                     item.indicator?.code ?? '',
//                     style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildTabContent(List<dynamic> groups, VitalRecordDetailState state,
//       {String emptyText = 'Không có dữ liệu'}) {
//     if (groups.isEmpty) {
//       return Center(
//           child: Text(emptyText, style: const TextStyle(fontSize: 16)));
//     }

//     return ListView.separated(
//       padding: const EdgeInsets.all(12),
//       itemCount: groups.length,
//       separatorBuilder: (_, __) => const SizedBox(height: 8),
//       itemBuilder: (_, i) => _buildGroupCard(groups[i], state),
//     );
//   }

//   Widget _buildLabTab(VitalRecordDetailState state, List<dynamic> all) {
//     final labGroups = _filterGroups(all, _labIds);
//     if (labGroups.isEmpty) {
//       return const Center(child: Text('Không có dữ liệu xét nghiệm'));
//     }

//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           _buildLabSection('Yêu cầu', labGroups, state),
//           _buildLabSection('Kết quả', labGroups, state),
//           _buildLabSection('Đính kèm', labGroups, state),
//           _buildLabSection('Hẹn', labGroups, state),
//           const SizedBox(height: 100),
//         ],
//       ),
//     );
//   }

//   Widget _buildLabSection(
//       String title, List<dynamic> groups, VitalRecordDetailState state) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ExpansionTile(
//         title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
//         children: groups.expand((g) {
//           final items = List.of(g.items);
//           items.sort((a, b) =>
//               (a.indicator.code ?? '').compareTo(b.indicator.code ?? ''));
//           return items.map((item) {
//             final vitalId = item.value?.vitalIndicatorId ?? 0;
//             final current =
//                 state.editedValues[vitalId] ?? item.value?.value ?? "";
//             final noteText =
//                 state.editedNotes[vitalId] ?? item.value?.note ?? '';
//             final noteController = _noteCtrl(vitalId, noteText);

//             return Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(item.indicator?.name ?? '',
//                       style: const TextStyle(fontWeight: FontWeight.w500)),
//                   const SizedBox(height: 8),
//                   VitalFieldEditor(
//                     indicator: item.indicator,
//                     value: current,
//                     unit: item.indicator?.unit,
//                     onChanged: (val) => context
//                         .read<VitalRecordDetailCubit>()
//                         .editValue(vitalValueId: vitalId, newValue: val),
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Ghi chú',
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8)),
//                     ),
//                     controller: noteController,
//                     minLines: 1,
//                     maxLines: 3,
//                     onChanged: (v) => context
//                         .read<VitalRecordDetailCubit>()
//                         .editNote(vitalValueId: vitalId, note: v),
//                   ),
//                 ],
//               ),
//             );
//           });
//         }).toList(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final color = Theme.of(context).colorScheme.primary;

//     return BlocListener<VitalRecordDetailCubit, VitalRecordDetailState>(
//       listener: (context, state) {
//         if (state.success) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: const Text('Cập nhật thành công!'),
//               backgroundColor: color,
//             ),
//           );
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Chi tiết bệnh án'),
//           backgroundColor: color,
//           foregroundColor: Colors.white,
//           bottom: TabBar(
//             controller: _tabController,
//             isScrollable: true,
//             tabAlignment: TabAlignment.start,
//             tabs: const [
//               Tab(text: 'Thông tin bệnh án'),
//               Tab(text: 'Chuẩn đoán'),
//               Tab(text: 'Xét nghiệm'),
//               Tab(text: 'Điều trị'),
//               Tab(text: 'Hẹn'),
//             ],
//           ),
//         ),
//         body: BlocBuilder<VitalRecordDetailCubit, VitalRecordDetailState>(
//           builder: (context, state) {
//             if (state.loading && state.groups.isEmpty) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (state.error != null) {
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text('Lỗi: ${state.error}'),
//                     const SizedBox(height: 12),
//                     FilledButton.icon(
//                       onPressed: () =>
//                           context.read<VitalRecordDetailCubit>().load(),
//                       icon: const Icon(Icons.refresh),
//                       label: const Text('Thử lại'),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             final all = List.of(state.groups);
//             final normal = _normalGroups(all);
//             final diagnosis = _filterGroups(all, _diagnosisIds);
//             final treatment = _filterGroups(all, _treatmentIds);
//             final followUp = _filterGroups(all, _followUpIds);

//             return TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildTabContent(normal, state,
//                     emptyText: 'Không có thông tin bệnh án'),
//                 _buildTabContent(diagnosis, state,
//                     emptyText: 'Chưa có chuẩn đoán'),
//                 _buildLabTab(state, all),
//                 _buildTabContent(treatment, state,
//                     emptyText: 'Chưa có điều trị'),
//                 _buildTabContent(followUp, state,
//                     emptyText: 'Chưa có lịch hẹn'),
//               ],
//             );
//           },
//         ),
//         bottomNavigationBar: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(12),
//             child: FilledButton.icon(
//               onPressed: () => context.read<VitalRecordDetailCubit>().saveAll(),
//               icon: const Icon(Icons.save_outlined),
//               label: const Text('Lưu tất cả thay đổi'),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dr_urticaria/medical_record_v2/widgets/vital_field_editor.dart';
import 'package:dr_urticaria/medical_record_v2/create_medical_record/model/vital_group.dart';

import 'package:dr_urticaria/cubits/vital_record_detail_cubit.dart';
import 'package:dr_urticaria/cubits/vital_record_detail_state.dart';

class VitalRecordDetailPage extends StatelessWidget {
  final int medicalRecordId;
  final int templateId;

  const VitalRecordDetailPage({
    super.key,
    required this.medicalRecordId,
    required this.templateId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VitalRecordDetailCubit(
        medicalRecordId: medicalRecordId,
        templateId: templateId,
      )..load(),
      child: const _VitalRecordDetailView(),
    );
  }
}

class _VitalRecordDetailView extends StatefulWidget {
  const _VitalRecordDetailView();

  @override
  State<_VitalRecordDetailView> createState() => _VitalRecordDetailViewState();
}

class _VitalRecordDetailViewState extends State<_VitalRecordDetailView>
    with TickerProviderStateMixin {
  static const Set<int> _diagnosisIds = {25, 35, 52};
  static const Set<int> _labIds = {23, 33, 43};
  static const Set<int> _treatmentIds = {26, 53};
  static const Set<int> _followUpIds = {49, 37, 54};

  late final TabController _tabController;

  final Map<int, TextEditingController> _noteControllers = {};

  TextEditingController _noteCtrl(int indicatorId, String initialText) {
    final exist = _noteControllers[indicatorId];
    if (exist != null) {
      if (exist.text != initialText) {
        exist.value = TextEditingValue(
          text: initialText,
          selection: TextSelection.collapsed(offset: initialText.length),
        );
      }
      return exist;
    }
    final c = TextEditingController(text: initialText);
    _noteControllers[indicatorId] = c;
    return c;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final c in _noteControllers.values) c.dispose();
    super.dispose();
  }

  List<VitalGroup> _filterGroups(List<VitalGroup> all, Set<int> ids) {
    return all.where((g) => ids.contains(g.id)).toList();
  }

  List<VitalGroup> _normalGroups(List<VitalGroup> all) {
    final special = {
      ..._diagnosisIds,
      ..._labIds,
      ..._treatmentIds,
      ..._followUpIds
    };
    return all.where((g) => !special.contains(g.id)).toList();
  }

  Widget _buildGroupCard(VitalGroup g, VitalRecordDetailState state) {
    final indicators = [...g.indicators];
    indicators.sort((a, b) => (a.code ?? '').compareTo(b.code ?? ''));

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ExpansionTile(
        title: Text(
          g.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: indicators.map((indicator) {
          final indicatorId = indicator.id;

          final current = state.editedValues.containsKey(indicatorId)
              ? state.editedValues[indicatorId]
              : (state.initialValues[indicatorId] ?? "");

          final noteText = state.editedNotes.containsKey(indicatorId)
              ? (state.editedNotes[indicatorId] ?? '')
              : (state.initialNotes[indicatorId] ?? '');

          final noteController = _noteCtrl(indicatorId, noteText);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        indicator.name ?? '',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (indicator.unit != null)
                      Text(indicator.unit!,
                          style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
                const SizedBox(height: 8),
                VitalFieldEditor(
                  indicator: indicator,
                  value: current,
                  unit: indicator.unit,
                  onChanged: (val) => context
                      .read<VitalRecordDetailCubit>()
                      .editValue(indicatorId: indicatorId, newValue: val),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Ghi chú',
                    prefixIcon: const Icon(Icons.note_alt_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  controller: noteController,
                  minLines: 1,
                  maxLines: 4,
                  onChanged: (v) => context
                      .read<VitalRecordDetailCubit>()
                      .editNote(indicatorId: indicatorId, note: v),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    indicator.code ?? '',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabContent(List<VitalGroup> groups, VitalRecordDetailState state,
      {String emptyText = 'Không có dữ liệu'}) {
    if (groups.isEmpty) {
      return Center(
          child: Text(emptyText, style: const TextStyle(fontSize: 16)));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: groups.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _buildGroupCard(groups[i], state),
    );
  }

  // Nếu template có group xét nghiệm thì vẫn render bình thường; không có thì mới báo rỗng.
  Widget _buildLabTab(VitalRecordDetailState state, List<VitalGroup> all) {
    final labGroups = _filterGroups(all, _labIds);
    if (labGroups.isEmpty) {
      return const Center(
          child: Text('Không có nhóm xét nghiệm trong template'));
    }

    // vẫn giữ UI section như bạn đang làm
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildLabSection('Xét nghiệm', labGroups, state),
          // _buildLabSection('Kết quả', labGroups, state),
          // _buildLabSection('Đính kèm', labGroups, state),
          // _buildLabSection('Hẹn', labGroups, state),
          // const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildLabSection(
      String title, List<VitalGroup> groups, VitalRecordDetailState state) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        children: groups.expand((g) {
          final indicators = [...g.indicators]
            ..sort((a, b) => (a.code ?? '').compareTo(b.code ?? ''));
          return indicators.map((indicator) {
            final id = indicator.id;

            final current = state.editedValues.containsKey(id)
                ? state.editedValues[id]
                : (state.initialValues[id] ?? "");

            final noteText = state.editedNotes.containsKey(id)
                ? (state.editedNotes[id] ?? '')
                : (state.initialNotes[id] ?? '');

            final noteController = _noteCtrl(id, noteText);

            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(indicator.name ?? '',
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  VitalFieldEditor(
                    indicator: indicator,
                    value: current,
                    unit: indicator.unit,
                    onChanged: (val) => context
                        .read<VitalRecordDetailCubit>()
                        .editValue(indicatorId: id, newValue: val),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Ghi chú',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    controller: noteController,
                    minLines: 1,
                    maxLines: 3,
                    onChanged: (v) => context
                        .read<VitalRecordDetailCubit>()
                        .editNote(indicatorId: id, note: v),
                  ),
                ],
              ),
            );
          });
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return BlocListener<VitalRecordDetailCubit, VitalRecordDetailState>(
      listener: (context, state) {
        if (state.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: const Text('Cập nhật thành công!'),
                backgroundColor: color),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chi tiết bệnh án'),
          backgroundColor: color,
          foregroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: const [
              Tab(text: 'Thông tin bệnh án'),
              Tab(text: 'Chuẩn đoán'),
              Tab(text: 'Xét nghiệm'),
              Tab(text: 'Điều trị'),
              Tab(text: 'Hẹn'),
            ],
          ),
        ),
        body: BlocBuilder<VitalRecordDetailCubit, VitalRecordDetailState>(
          builder: (context, state) {
            // ✅ chỉ block khi đang load form và chưa có groups để render
            if (state.loadingForm && state.groups.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            // nếu form đã có groups, vẫn render dù detail lỗi/không có data
            final all = [...state.groups];
            final normal = _normalGroups(all);
            final diagnosis = _filterGroups(all, _diagnosisIds);
            final treatment = _filterGroups(all, _treatmentIds);
            final followUp = _filterGroups(all, _followUpIds);

            return Stack(
              children: [
                TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTabContent(normal, state,
                        emptyText: 'Không có thông tin bệnh án'),
                    _buildTabContent(diagnosis, state,
                        emptyText: 'Không có nhóm chuẩn đoán trong template'),
                    _buildLabTab(state, all),
                    _buildTabContent(treatment, state,
                        emptyText: 'Không có nhóm điều trị trong template'),
                    _buildTabContent(followUp, state,
                        emptyText: 'Không có nhóm hẹn trong template'),
                  ],
                ),

                // ✅ detail đang load thì overlay nhẹ (không chặn UI)
                if (state.loadingDetail)
                  const Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: LinearProgressIndicator(minHeight: 2),
                  ),
              ],
            );
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: BlocBuilder<VitalRecordDetailCubit, VitalRecordDetailState>(
              builder: (context, state) {
                return FilledButton.icon(
                  onPressed: state.saving
                      ? null
                      : () => context.read<VitalRecordDetailCubit>().saveAll(),
                  icon: const Icon(Icons.save_outlined),
                  label: Text(
                      state.saving ? 'Đang lưu...' : 'Lưu tất cả thay đổi'),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
