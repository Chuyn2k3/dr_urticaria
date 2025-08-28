import 'package:dr_urticaria/cubits/login/appointment/appointment_list_cubit.dart';
import 'package:dr_urticaria/cubits/login/appointment/appointment_list_state.dart';
import 'package:dr_urticaria/utils/enum/appointment_enum.dart';
import 'package:dr_urticaria/widget/appbar/custom_app_bar.dart';
import 'package:dr_urticaria/widget/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentsListScreen extends StatelessWidget {
  const AppointmentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppointmentListCubit()..fetch(page: 1, limit: 10),
      child: const AppointmentsListView(),
    );
  }
}

class AppointmentsListView extends StatefulWidget {
  const AppointmentsListView({super.key});

  @override
  State<AppointmentsListView> createState() => _AppointmentsListViewState();
}

class _AppointmentsListViewState extends State<AppointmentsListView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  AppointmentStatus _selectedStatus = AppointmentStatus.pending;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentListCubit>().fetch(
            page: 1,
            limit: 20,
            status: _selectedStatus,
          );
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<AppointmentListCubit>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CustomAppbar.basic(title: 'Danh sách lịch hẹn'),
      body: Column(
        children: [
          _buildTabs(),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<AppointmentListCubit, AppointmentListState>(
              builder: (context, state) {
                if (state is AppointmentListLoading &&
                    state is! AppointmentListSuccess) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AppointmentListFailure) {
                  return Center(child: Text('Lỗi: ${state.message}'));
                } else if (state is AppointmentListSuccess) {
                  final items = state.items.where((a) {
                    if (_selectedStatus == null) return true;
                    return a.status == _selectedStatus!.serverKey;
                  }).toList();

                  if (items.isEmpty) return _buildEmptyState();

                  return RefreshIndicator(
                    onRefresh: () async {
                      await context
                          .read<AppointmentListCubit>()
                          .refresh(limit: state.limit);
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: items.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= items.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final appointment = items[index];
                        return _buildAppointmentCard(appointment);
                      },
                    ),
                  );
                }
                return _buildEmptyState();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF3B82F6),
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade600,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        onTap: (index) {
          AppointmentStatus newStatus = AppointmentStatus.pending;
          switch (index) {
            case 0:
              newStatus = AppointmentStatus.pending; // All appointments
              break;
            case 1:
              newStatus = AppointmentStatus.confirmed;
              break;
            case 2:
              newStatus = AppointmentStatus.completed;
              break;
            case 3:
              newStatus = AppointmentStatus.cancelled;
              break;
          }

          setState(() {
            _selectedStatus = newStatus;
          });

          context.read<AppointmentListCubit>().fetch(
                page: 1,
                limit: 20,
                status: newStatus,
                isRefresh: true,
              );
        },
        tabs: const [
          Tab(text: 'Tất cả'),
          Tab(text: 'Chờ xử lý'),
          Tab(text: 'Đã xác nhận'),
          Tab(text: 'Hoàn thành'),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appointment.patient.fullname,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 4),
          Text(
            'SĐT: ${appointment.patient.phone}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                appointment.appointmentDate.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
              const Spacer(),
              _buildStatusChip(
                  AppointmentStatus.fromServerKey(appointment.status)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(AppointmentStatus status) {
    Color color;
    String text;
    switch (status) {
      case AppointmentStatus.pending:
        color = Colors.orange;
        text = 'Chờ xử lý';
        break;
      case AppointmentStatus.confirmed:
        color = Colors.blue;
        text = 'Đã xác nhận';
        break;
      case AppointmentStatus.completed:
        color = Colors.green;
        text = 'Hoàn thành';
        break;
      case AppointmentStatus.cancelled:
        color = Colors.red;
        text = 'Đã hủy';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Chưa có lịch hẹn nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
