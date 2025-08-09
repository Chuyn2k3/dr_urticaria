import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/appointment_cubit.dart';
import '../../models/appointment_model.dart';

class AppointmentManagementScreen extends StatefulWidget {
  const AppointmentManagementScreen({super.key});

  @override
  State<AppointmentManagementScreen> createState() => _AppointmentManagementScreenState();
}

class _AppointmentManagementScreenState extends State<AppointmentManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
        title: const Text('Quản lý lịch hẹn'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Tất cả'),
            Tab(text: 'Đã đặt'),
            Tab(text: 'Chờ khám'),
            Tab(text: 'Đang khám'),
            Tab(text: 'Hoàn thành'),
          ],
        ),
      ),
      body: BlocBuilder<AppointmentCubit, AppointmentState>(
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildAppointmentList(state.appointments),
              _buildAppointmentList(state.appointments
                  .where((a) => a.status == AppointmentStatus.scheduled)
                  .toList()),
              _buildAppointmentList(state.appointments
                  .where((a) => a.status == AppointmentStatus.waiting)
                  .toList()),
              _buildAppointmentList(state.appointments
                  .where((a) => a.status == AppointmentStatus.inProgress)
                  .toList()),
              _buildAppointmentList(state.appointments
                  .where((a) => a.status == AppointmentStatus.completed)
                  .toList()),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/new-appointment');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAppointmentList(List<AppointmentModel> appointments) {
    if (appointments.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Không có lịch hẹn',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    // Group appointments by date
    final groupedAppointments = <String, List<AppointmentModel>>{};
    for (final appointment in appointments) {
      final dateKey = _formatDateKey(appointment.appointmentDate);
      groupedAppointments.putIfAbsent(dateKey, () => []).add(appointment);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedAppointments.length,
      itemBuilder: (context, index) {
        final dateKey = groupedAppointments.keys.elementAt(index);
        final dayAppointments = groupedAppointments[dateKey]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                dateKey,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            ...dayAppointments.map((appointment) => _buildAppointmentCard(appointment)),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildAppointmentCard(AppointmentModel appointment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: appointment.statusColor,
          child: Icon(
            _getStatusIcon(appointment.status),
            color: Colors.white,
          ),
        ),
        title: Text(appointment.patientName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('BS. ${appointment.doctorName}'),
            Text('Phòng: ${appointment.roomNumber}'),
            Text('Thời gian: ${_formatTime(appointment.appointmentTime)}'),
          ],
        ),
        trailing: _buildAppointmentAction(appointment),
        onTap: () => _viewAppointmentDetails(appointment),
      ),
    );
  }

  Widget _buildAppointmentAction(AppointmentModel appointment) {
    switch (appointment.status) {
      case AppointmentStatus.scheduled:
        return ElevatedButton(
          onPressed: () => _checkInAppointment(appointment),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            minimumSize: const Size(80, 32),
          ),
          child: const Text('Check-in'),
        );
      case AppointmentStatus.waiting:
        return ElevatedButton(
          onPressed: () => _startExamination(appointment),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            minimumSize: const Size(80, 32),
          ),
          child: const Text('Bắt đầu'),
        );
      case AppointmentStatus.inProgress:
        return OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(80, 32),
          ),
          child: const Text('Đang khám'),
        );
      case AppointmentStatus.completed:
        return OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(80, 32),
          ),
          child: const Text('Hoàn thành'),
        );
      case AppointmentStatus.cancelled:
        return OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(80, 32),
          ),
          child: const Text('Đã hủy'),
        );
    }
  }

  void _checkInAppointment(AppointmentModel appointment) {
    final updatedAppointment = appointment.copyWith(
      status: AppointmentStatus.waiting,
      updatedAt: DateTime.now(),
    );
    context.read<AppointmentCubit>().updateAppointment(updatedAppointment);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã check-in bệnh nhân ${appointment.patientName}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _startExamination(AppointmentModel appointment) {
    final updatedAppointment = appointment.copyWith(
      status: AppointmentStatus.inProgress,
      updatedAt: DateTime.now(),
    );
    context.read<AppointmentCubit>().updateAppointment(updatedAppointment);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã bắt đầu khám bệnh nhân ${appointment.patientName}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _viewAppointmentDetails(AppointmentModel appointment) {
    Navigator.pushNamed(
      context,
      '/appointment-detail',
      arguments: appointment,
    );
  }

  IconData _getStatusIcon(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return Icons.calendar_today;
      case AppointmentStatus.waiting:
        return Icons.schedule;
      case AppointmentStatus.inProgress:
        return Icons.medical_services;
      case AppointmentStatus.completed:
        return Icons.check_circle;
      case AppointmentStatus.cancelled:
        return Icons.cancel;
    }
  }

  String _formatDateKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final appointmentDate = DateTime(date.year, date.month, date.day);
    
    if (appointmentDate == today) {
      return 'Hôm nay - ${date.day}/${date.month}/${date.year}';
    } else if (appointmentDate == today.add(const Duration(days: 1))) {
      return 'Ngày mai - ${date.day}/${date.month}/${date.year}';
    } else if (appointmentDate == today.subtract(const Duration(days: 1))) {
      return 'Hôm qua - ${date.day}/${date.month}/${date.year}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
