// // // import 'package:dr_urticaria/cubits/appointment/appointment_list_cubit.dart';
// // // import 'package:dr_urticaria/cubits/appointment/appointment_list_state.dart';
// // // import 'package:dr_urticaria/medical_record_v2/screens/acute_urticaria_form_screen.dart';
// // // import 'package:dr_urticaria/medical_record_v2/screens/vital_record_detail_page.dart';
// // // import 'package:dr_urticaria/utils/enum/appointment_enum.dart';
// // // import 'package:dr_urticaria/utils/snack_bar.dart';
// // // import 'package:dr_urticaria/widget/appbar/custom_app_bar.dart';
// // // import 'package:dr_urticaria/widget/base_scaffold.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_bloc/flutter_bloc.dart';
// // //
// // // import '../../models/appointment/appointment_model.dart';
// // //
// // // class AppointmentsListScreen extends StatelessWidget {
// // //   const AppointmentsListScreen({super.key});
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return BlocProvider(
// // //       create: (_) => AppointmentListCubit(), // ❌ bỏ ..fetch(page:1,...)
// // //       child: const AppointmentsListView(),
// // //     );
// // //   }
// // // }
// // //
// // // class AppointmentsListView extends StatefulWidget {
// // //   const AppointmentsListView({super.key});
// // //
// // //   @override
// // //   State<AppointmentsListView> createState() => _AppointmentsListViewState();
// // // }
// // //
// // // class _AppointmentsListViewState extends State<AppointmentsListView>
// // //     with TickerProviderStateMixin {
// // //   late TabController _tabController;
// // //   AppointmentStatus _selectedStatus = AppointmentStatus.pending;
// // //   final ScrollController _scrollController = ScrollController();
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _tabController = TabController(length: 4, vsync: this);
// // //
// // //     WidgetsBinding.instance.addPostFrameCallback((_) {
// // //       context.read<AppointmentListCubit>().fetch(
// // //             page: 1,
// // //             limit: 20,
// // //             status: _selectedStatus,
// // //           );
// // //     });
// // //
// // //     _scrollController.addListener(() {
// // //       if (_scrollController.position.pixels >=
// // //           _scrollController.position.maxScrollExtent - 200) {
// // //         context
// // //             .read<AppointmentListCubit>()
// // //             .loadMore(status: _selectedStatus); // ✅ truyền status
// // //       }
// // //     });
// // //   }
// // //
// // //   @override
// // //   void dispose() {
// // //     _tabController.dispose();
// // //     _scrollController.dispose();
// // //     super.dispose();
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return BaseScaffold(
// // //       // appBar: CustomAppbar.basic(title: 'Danh sách lịch hẹn'),
// // //       body: Column(
// // //         children: [
// // //           _buildTabs(),
// // //           const SizedBox(height: 16),
// // //           Expanded(
// // //             child: BlocBuilder<AppointmentListCubit, AppointmentListState>(
// // //               builder: (context, state) {
// // //                 if (state is AppointmentListLoading &&
// // //                     state is! AppointmentListSuccess) {
// // //                   return const Center(child: CircularProgressIndicator());
// // //                 } else if (state is AppointmentListFailure) {
// // //                   return Center(child: Text('Lỗi: ${state.message}'));
// // //                 } else if (state is AppointmentListSuccess) {
// // //                   final items = state.items
// // //                       .where((a) => a.status == _selectedStatus)
// // //                       .toList();
// // //
// // //                   if (items.isEmpty) return _buildEmptyState();
// // //
// // //                   return RefreshIndicator(
// // //                     onRefresh: () async {
// // //                       await context.read<AppointmentListCubit>().refresh(
// // //                             limit: state.limit,
// // //                             status: _selectedStatus, // ✅ truyền status
// // //                           );
// // //                     },
// // //                     child: ListView.builder(
// // //                       controller: _scrollController,
// // //                       padding: const EdgeInsets.symmetric(horizontal: 16),
// // //                       itemCount: items.length + (state.hasMore ? 1 : 0),
// // //                       itemBuilder: (context, index) {
// // //                         if (index >= items.length) {
// // //                           return const Padding(
// // //                             padding: EdgeInsets.all(16),
// // //                             child: Center(child: CircularProgressIndicator()),
// // //                           );
// // //                         }
// // //                         final appointment = items[index];
// // //                         return _buildAppointmentCard(appointment);
// // //                       },
// // //                     ),
// // //                   );
// // //                 }
// // //                 return _buildEmptyState();
// // //               },
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildTabs() {
// // //     return Container(
// // //       margin: const EdgeInsets.symmetric(horizontal: 16),
// // //       decoration: BoxDecoration(
// // //         color: Colors.grey.shade100,
// // //         borderRadius: BorderRadius.circular(12),
// // //       ),
// // //       child: TabBar(
// // //         dividerColor: Colors.transparent,
// // //         controller: _tabController,
// // //         indicator: BoxDecoration(
// // //           color: const Color(0xFF3B82F6),
// // //           borderRadius: BorderRadius.circular(10),
// // //         ),
// // //         indicatorSize: TabBarIndicatorSize.tab,
// // //         labelColor: Colors.white,
// // //         unselectedLabelColor: Colors.grey.shade600,
// // //         labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
// // //         unselectedLabelStyle:
// // //             const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
// // //         onTap: (index) {
// // //           AppointmentStatus newStatus = AppointmentStatus.pending;
// // //           switch (index) {
// // //             case 0:
// // //               newStatus = AppointmentStatus.pending;
// // //               break;
// // //             case 1:
// // //               newStatus = AppointmentStatus.confirmed;
// // //               break;
// // //             case 2:
// // //               newStatus = AppointmentStatus.completed;
// // //               break;
// // //             case 3:
// // //               newStatus = AppointmentStatus.cancelled;
// // //               break;
// // //           }
// // //
// // //           setState(() => _selectedStatus = newStatus);
// // //
// // //           context.read<AppointmentListCubit>().fetch(
// // //                 page: 1,
// // //                 limit: 20,
// // //                 status: newStatus,
// // //                 isRefresh: true,
// // //               );
// // //         },
// // //         tabs: const [
// // //           Tab(text: 'Chờ xử lý'),
// // //           Tab(text: 'Đã xác nhận'),
// // //           Tab(text: 'Hoàn thànhn'),
// // //           Tab(text: 'Đã hủy'),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildAppointmentCard(AppointmentModel appointment) {
// // //     final id = (appointment.medicalRecords != null &&
// // //             appointment.medicalRecords!.isNotEmpty)
// // //         ? appointment.medicalRecords!.lastOrNull?.id
// // //         : null;
// // //
// // //     return InkWell(
// // //       onTap: id != null
// // //           ? () => Navigator.push(
// // //                 context,
// // //                 MaterialPageRoute(
// // //                   builder: (context) => VitalRecordDetailPage(
// // //                     appointmentId: appointment.id,
// // //                     medicalRecordId: id,
// // //                     selectedStatus: _selectedStatus,
// // //                   ),
// // //                 ),
// // //               )
// // //           : () {
// // //               context.showSnackBarFail(
// // //                 text: "Không có thông tin bệnh án",
// // //                 positionTop: true,
// // //               );
// // //             },
// // //       child: Container(
// // //         margin: const EdgeInsets.only(bottom: 12),
// // //         padding: const EdgeInsets.all(16),
// // //         decoration: BoxDecoration(
// // //           color: Colors.white,
// // //           borderRadius: BorderRadius.circular(16),
// // //           boxShadow: [
// // //             BoxShadow(
// // //               color: Colors.black.withOpacity(0.05),
// // //               blurRadius: 10,
// // //               offset: const Offset(0, 2),
// // //             ),
// // //           ],
// // //         ),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             Text(
// // //               appointment.patient.fullname,
// // //               style: const TextStyle(
// // //                 fontSize: 16,
// // //                 fontWeight: FontWeight.bold,
// // //                 color: Colors.black,
// // //               ),
// // //             ),
// // //             const SizedBox(height: 4),
// // //             Text(
// // //               'SĐT: ${appointment.patient.phone}',
// // //               style: TextStyle(
// // //                 fontSize: 13,
// // //                 color: Colors.grey.shade600,
// // //               ),
// // //             ),
// // //             const SizedBox(height: 8),
// // //             Row(
// // //               children: [
// // //                 const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
// // //                 const SizedBox(width: 4),
// // //                 Text(
// // //                   appointment.appointmentDate.toString(),
// // //                   style: TextStyle(
// // //                     fontSize: 12,
// // //                     color: Colors.grey.shade700,
// // //                   ),
// // //                 ),
// // //                 const Spacer(),
// // //                 _buildStatusChip(appointment.status),
// // //               ],
// // //             ),
// // //             Text(
// // //               'ID: ${appointment.id}',
// // //               style: TextStyle(
// // //                 fontSize: 13,
// // //                 color: Colors.grey.shade600,
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildStatusChip(AppointmentStatus status) {
// // //     Color color;
// // //     String text;
// // //     switch (status) {
// // //       case AppointmentStatus.pending:
// // //         color = Colors.orange;
// // //         text = 'Chờ xử lý';
// // //         break;
// // //       case AppointmentStatus.confirmed:
// // //         color = Colors.blue;
// // //         text = 'Đã xác nhận';
// // //         break;
// // //       case AppointmentStatus.completed:
// // //         color = Colors.green;
// // //         text = 'Hoàn thành';
// // //         break;
// // //       case AppointmentStatus.cancelled:
// // //         color = Colors.red;
// // //         text = 'Đã hủy';
// // //         break;
// // //     }
// // //     return Container(
// // //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
// // //       decoration: BoxDecoration(
// // //         color: color.withOpacity(0.1),
// // //         borderRadius: BorderRadius.circular(12),
// // //       ),
// // //       child: Text(
// // //         text,
// // //         style: TextStyle(
// // //           fontSize: 12,
// // //           fontWeight: FontWeight.w600,
// // //           color: color,
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildEmptyState() {
// // //     return Center(
// // //       child: Column(
// // //         mainAxisAlignment: MainAxisAlignment.center,
// // //         children: [
// // //           Icon(Icons.event_busy, size: 64, color: Colors.grey.shade400),
// // //           const SizedBox(height: 16),
// // //           Text(
// // //             'Chưa có lịch hẹn nào',
// // //             style: TextStyle(
// // //               fontSize: 18,
// // //               fontWeight: FontWeight.w600,
// // //               color: Colors.grey.shade600,
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// import 'dart:async';
// import 'package:dr_urticaria/cubits/appointment/appointment_list_cubit.dart';
// import 'package:dr_urticaria/cubits/appointment/appointment_list_state.dart';
// import 'package:dr_urticaria/medical_record_v2/screens/vital_record_detail_page.dart';
// import 'package:dr_urticaria/utils/enum/appointment_enum.dart';
// import 'package:dr_urticaria/utils/snack_bar.dart';
// import 'package:dr_urticaria/widget/base_scaffold.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../models/appointment/appointment_model.dart';

// class AppointmentsListScreen extends StatelessWidget {
//   const AppointmentsListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => AppointmentListCubit(),
//       child: const AppointmentsListView(),
//     );
//   }
// }

// class AppointmentsListView extends StatefulWidget {
//   const AppointmentsListView({super.key});

//   @override
//   State<AppointmentsListView> createState() => _AppointmentsListViewState();
// }

// class _AppointmentsListViewState extends State<AppointmentsListView>
//     with TickerProviderStateMixin {
//   late TabController _tabController;
//   AppointmentStatus _selectedStatus = AppointmentStatus.pending;
//   final ScrollController _scrollController = ScrollController();
//   final TextEditingController _searchController = TextEditingController();
//   Timer? _searchDebounce;
//   String _orderBy = 'appointmentDate';
//   String _orderDirection = 'DESC';
//   DateTime? _appointmentDateFrom;
//   DateTime? _appointmentDateTo;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mounted) {
//         print('Fetching appointments with status: $_selectedStatus');
//         context.read<AppointmentListCubit>().fetch(
//               page: 1,
//               limit: 20,
//               status: _selectedStatus,
//               orderBy: _orderBy,
//               orderDirection: _orderDirection,
//               from: _appointmentDateFrom,
//               to: _appointmentDateTo,
//             );
//       } else {
//         print('Widget not mounted, skipping fetch');
//       }
//     });

//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >=
//           _scrollController.position.maxScrollExtent - 200) {
//         if (mounted) {
//           context.read<AppointmentListCubit>().loadMore(
//                 status: _selectedStatus,
//                 searchQuery: _searchController.text,
//                 orderBy: _orderBy,
//                 orderDirection: _orderDirection,
//                 appointmentDateFrom: _appointmentDateFrom,
//                 appointmentDateTo: _appointmentDateTo,
//               );
//         }
//       }
//     });

//     _searchController.addListener(() {
//       if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
//       _searchDebounce = Timer(const Duration(milliseconds: 500), () {
//         if (mounted) {
//           context.read<AppointmentListCubit>().fetch(
//                 page: 1,
//                 limit: 100,
//                 status: _selectedStatus,
//                 fullName: _searchController.text.isEmpty
//                     ? null
//                     : _searchController.text,
//                 phone: _searchController.text.isEmpty
//                     ? null
//                     : _searchController.text,
//                 orderBy: _orderBy,
//                 orderDirection: _orderDirection,
//                 from: _appointmentDateFrom,
//                 to: _appointmentDateTo,
//                 isRefresh: true,
//               );
//         }
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _scrollController.dispose();
//     _searchController.dispose();
//     _searchDebounce?.cancel();
//     super.dispose();
//   }

//   void _showFilterDialog() {
//     String tempOrderBy = _orderBy;
//     String tempOrderDirection = _orderDirection;
//     DateTime? tempAppointmentDateFrom = _appointmentDateFrom;
//     DateTime? tempAppointmentDateTo = _appointmentDateTo;

//     // Lưu reference đến cubit trước khi show dialog
//     final appointmentCubit = context.read<AppointmentListCubit>();

//     showDialog(
//       context: context,
//       builder: (dialogContext) => AlertDialog(
//         // Đổi tên context để rõ ràng
//         title: const Text('Bộ lọc & Sắp xếp'),
//         content: StatefulBuilder(
//           builder: (context, setDialogState) => SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('Sắp xếp theo:'),
//                 DropdownButton<String>(
//                   value: tempOrderBy,
//                   isExpanded: true,
//                   items: const [
//                     DropdownMenuItem(
//                         value: 'appointmentDate', child: Text('Ngày hẹn')),
//                     // DropdownMenuItem(
//                     //     value: 'fullname', child: Text('Tên bệnh nhân')),
//                     // DropdownMenuItem(
//                     //     value: 'phone', child: Text('Số điện thoại')),
//                   ],
//                   onChanged: (value) {
//                     if (value != null) {
//                       setDialogState(() => tempOrderBy = value);
//                     }
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 const Text('Hướng sắp xếp:'),
//                 RadioListTile<String>(
//                   title: const Text(
//                     'Tăng dần',
//                   ),
//                   value: 'ASC',
//                   groupValue: tempOrderDirection,
//                   onChanged: (value) {
//                     if (value != null) {
//                       setDialogState(() => tempOrderDirection = value);
//                     }
//                   },
//                 ),
//                 RadioListTile<String>(
//                   title: const Text(
//                     'Giảm dần',
//                   ),
//                   value: 'DESC',
//                   groupValue: tempOrderDirection,
//                   onChanged: (value) {
//                     if (value != null) {
//                       setDialogState(() => tempOrderDirection = value);
//                     }
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 const Text('Từ ngày:'),
//                 TextButton(
//                   onPressed: () async {
//                     final selectedDate = await showDatePicker(
//                       context: dialogContext, // Sử dụng dialogContext
//                       initialDate: tempAppointmentDateFrom ?? DateTime.now(),
//                       firstDate: DateTime(2000),
//                       lastDate: DateTime(2100),
//                     );
//                     if (selectedDate != null) {
//                       setDialogState(
//                           () => tempAppointmentDateFrom = selectedDate);
//                     }
//                   },
//                   child: Text(
//                     tempAppointmentDateFrom?.toString().split(' ')[0] ??
//                         'Chọn ngày',
//                     style: TextStyle(color: Colors.blue.shade600),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text('Đến ngày:'),
//                 TextButton(
//                   onPressed: () async {
//                     final selectedDate = await showDatePicker(
//                       context: dialogContext, // Sử dụng dialogContext
//                       initialDate: tempAppointmentDateTo ?? DateTime.now(),
//                       firstDate: DateTime(2000),
//                       lastDate: DateTime(2100),
//                     );
//                     if (selectedDate != null) {
//                       setDialogState(
//                           () => tempAppointmentDateTo = selectedDate);
//                     }
//                   },
//                   child: Text(
//                     tempAppointmentDateTo?.toString().split(' ')[0] ??
//                         'Chọn ngày',
//                     style: TextStyle(color: Colors.blue.shade600),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () =>
//                 Navigator.pop(dialogContext), // Sử dụng dialogContext
//             child: const Text('Hủy'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (tempAppointmentDateFrom != null &&
//                   tempAppointmentDateTo != null) {
//                 if (tempAppointmentDateFrom!.isAfter(tempAppointmentDateTo!)) {
//                   // Sử dụng context của widget chính cho snackbar
//                   if (mounted) {
//                     context.showSnackBarFail(
//                       text: 'Ngày bắt đầu phải trước ngày kết thúc',
//                       positionTop: true,
//                     );
//                   }
//                   return;
//                 }
//               }
//               setState(() {
//                 _orderBy = tempOrderBy;
//                 _orderDirection = tempOrderDirection;
//                 _appointmentDateFrom = tempAppointmentDateFrom;
//                 _appointmentDateTo = tempAppointmentDateTo;
//               });

//               // Sử dụng appointmentCubit đã lưu trước đó
//               appointmentCubit.fetch(
//                 page: 1,
//                 limit: 100,
//                 status: _selectedStatus,
//                 fullName: _searchController.text.isEmpty
//                     ? null
//                     : _searchController.text,
//                 phone: _searchController.text.isEmpty
//                     ? null
//                     : _searchController.text,
//                 orderBy: _orderBy,
//                 orderDirection: _orderDirection,
//                 from: _appointmentDateFrom,
//                 to: _appointmentDateTo,
//                 isRefresh: true,
//               );
//               Navigator.pop(dialogContext); // Sử dụng dialogContext
//             },
//             child: const Text('Áp dụng'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BaseScaffold(
//       body: Column(
//         children: [
//           _buildSearchBar(),
//           const SizedBox(height: 16),
//           _buildTabs(),
//           const SizedBox(height: 16),
//           Expanded(
//             child: BlocBuilder<AppointmentListCubit, AppointmentListState>(
//               builder: (context, state) {
//                 if (state is AppointmentListLoading &&
//                     state is! AppointmentListSuccess) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (state is AppointmentListFailure) {
//                   return Center(child: Text('Lỗi: ${state.message}'));
//                 } else if (state is AppointmentListSuccess) {
//                   final items = state.items
//                       .where((a) => a.status == _selectedStatus)
//                       .toList();

//                   if (items.isEmpty) return _buildEmptyState();

//                   return RefreshIndicator(
//                     onRefresh: () async {
//                       await context.read<AppointmentListCubit>().refresh(
//                             limit: state.limit,
//                             status: _selectedStatus,
//                             fullName: _searchController.text.isEmpty
//                                 ? null
//                                 : _searchController.text,
//                             phone: _searchController.text.isEmpty
//                                 ? null
//                                 : _searchController.text,
//                             orderBy: _orderBy,
//                             orderDirection: _orderDirection,
//                             appointmentDateFrom: _appointmentDateFrom,
//                             appointmentDateTo: _appointmentDateTo,
//                           );
//                     },
//                     child: ListView.builder(
//                       controller: _scrollController,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       itemCount: items.length + (state.hasMore ? 1 : 0),
//                       itemBuilder: (context, index) {
//                         if (index >= items.length) {
//                           return const Padding(
//                             padding: EdgeInsets.all(16),
//                             child: Center(child: CircularProgressIndicator()),
//                           );
//                         }
//                         final appointment = items[index];
//                         return _buildAppointmentCard(appointment);
//                       },
//                     ),
//                   );
//                 }
//                 return _buildEmptyState();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: TextField(
//                 controller: _searchController,
//                 decoration: InputDecoration(
//                   hintText: 'Tìm kiếm theo tên hoặc số điện thoại...',
//                   hintStyle:
//                       TextStyle(color: Colors.grey.shade500, fontSize: 14),
//                   prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
//                   border: InputBorder.none,
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 8,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: IconButton(
//               icon: Icon(Icons.filter_list, color: Colors.grey.shade500),
//               onPressed: _showFilterDialog,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabs() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: TabBar(
//         dividerColor: Colors.transparent,
//         controller: _tabController,
//         indicator: BoxDecoration(
//           color: const Color(0xFF3B82F6),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         indicatorSize: TabBarIndicatorSize.tab,
//         labelColor: Colors.white,
//         unselectedLabelColor: Colors.grey.shade600,
//         labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
//         unselectedLabelStyle:
//             const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
//         onTap: (index) {
//           AppointmentStatus newStatus = AppointmentStatus.pending;
//           switch (index) {
//             case 0:
//               newStatus = AppointmentStatus.pending;
//               break;
//             case 1:
//               newStatus = AppointmentStatus.confirmed;
//               break;
//             case 2:
//               newStatus = AppointmentStatus.completed;
//               break;
//             case 3:
//               newStatus = AppointmentStatus.cancelled;
//               break;
//           }

//           setState(() => _selectedStatus = newStatus);

//           context.read<AppointmentListCubit>().fetch(
//                 page: 1,
//                 limit: 20,
//                 status: newStatus,
//                 fullName: _searchController.text.isEmpty
//                     ? null
//                     : _searchController.text,
//                 phone: _searchController.text.isEmpty
//                     ? null
//                     : _searchController.text,
//                 orderBy: _orderBy,
//                 orderDirection: _orderDirection,
//                 from: _appointmentDateFrom,
//                 to: _appointmentDateTo,
//                 isRefresh: true,
//               );
//         },
//         tabs: const [
//           Tab(text: 'Chờ xử lý'),
//           Tab(text: 'Đã xác nhận'),
//           Tab(text: 'Hoàn thành'),
//           Tab(text: 'Đã hủy'),
//         ],
//       ),
//     );
//   }

//   Widget _buildAppointmentCard(AppointmentModel appointment) {
//     final id = (appointment.medicalRecords != null &&
//             appointment.medicalRecords!.isNotEmpty)
//         ? appointment.medicalRecords!.lastOrNull?.id
//         : null;

//     return InkWell(
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => VitalRecordDetailPage(
//             appointmentId: 20,
//             medicalRecordId: 561,
//             selectedStatus: _selectedStatus,
//           ),
//         ),
//       ),
//       // id != null
//       //     ? () => Navigator.push(
//       //           context,
//       //           MaterialPageRoute(
//       //             builder: (context) => VitalRecordDetailPage(
//       //               appointmentId: appointment.id,
//       //               medicalRecordId: id,
//       //               selectedStatus: _selectedStatus,
//       //             ),
//       //           ),
//       //         )
//       //     : () {
//       //         context.showSnackBarFail(
//       //           text: "Không có thông tin bệnh án",
//       //           positionTop: true,
//       //         );
//       //       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               appointment.patient.fullname,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               'SĐT: ${appointment.patient.phone}',
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
//                 const SizedBox(width: 4),
//                 Text(
//                   appointment.appointmentDate.toString(),
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey.shade700,
//                   ),
//                 ),
//                 const Spacer(),
//                 _buildStatusChip(appointment.status),
//               ],
//             ),
//             Text(
//               'ID: ${appointment.id}',
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusChip(AppointmentStatus status) {
//     Color color;
//     String text;
//     switch (status) {
//       case AppointmentStatus.pending:
//         color = Colors.orange;
//         text = 'Chờ xử lý';
//         break;
//       case AppointmentStatus.confirmed:
//         color = Colors.blue;
//         text = 'Đã xác nhận';
//         break;
//       case AppointmentStatus.completed:
//         color = Colors.green;
//         text = 'Hoàn thành';
//         break;
//       case AppointmentStatus.cancelled:
//         color = Colors.red;
//         text = 'Đã hủy';
//         break;
//     }
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w600,
//           color: color,
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.event_busy, size: 64, color: Colors.grey.shade400),
//           const SizedBox(height: 16),
//           Text(
//             'Chưa có lịch hẹn nào',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey.shade600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
