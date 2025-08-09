import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/appointment_model.dart';

class AppointmentState {
  final List<AppointmentModel> appointments;
  final bool isLoading;
  final String? error;

  AppointmentState({
    this.appointments = const [],
    this.isLoading = false,
    this.error,
  });

  AppointmentState copyWith({
    List<AppointmentModel>? appointments,
    bool? isLoading,
    String? error,
  }) {
    return AppointmentState(
      appointments: appointments ?? this.appointments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AppointmentCubit extends Cubit<AppointmentState> {
  AppointmentCubit() : super(AppointmentState()) {
    _loadDemoData();
  }

  void _loadDemoData() {
    final demoAppointments = [
      AppointmentModel(
        id: 'apt1',
        patientId: 'patient1',
        patientName: 'Nguyễn Thị D',
        patientPhone: '0111222333',
        doctorId: 'doctor1',
        doctorName: 'BS. Nguyễn Văn A',
        roomNumber: 'P101',
        appointmentTime: DateTime.now().add(const Duration(hours: 1)),
        status: AppointmentStatus.waiting,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      AppointmentModel(
        id: 'apt2',
        patientId: 'patient2',
        patientName: 'Trần Văn E',
        patientPhone: '0444555666',
        doctorId: 'doctor1',
        doctorName: 'BS. Nguyễn Văn A',
        roomNumber: 'P101',
        appointmentTime: DateTime.now().add(const Duration(hours: 2)),
        status: AppointmentStatus.scheduled,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];

    emit(state.copyWith(appointments: demoAppointments));
  }

  List<AppointmentModel> getAppointmentsByDoctorId(String doctorId) {
    return state.appointments.where((a) => a.doctorId == doctorId).toList();
  }

  List<AppointmentModel> getTodayAppointments() {
    final today = DateTime.now();
    return state.appointments.where((a) {
      return a.appointmentTime.year == today.year &&
          a.appointmentTime.month == today.month &&
          a.appointmentTime.day == today.day;
    }).toList();
  }

  void updateAppointmentStatus(String appointmentId, AppointmentStatus status) {
    final updatedAppointments = state.appointments.map((a) {
      return a.id == appointmentId ? a.copyWith(status: status) : a;
    }).toList();
    emit(state.copyWith(appointments: updatedAppointments));
  }

  void updateAppointment(AppointmentModel updatedAppointment) {
    final updatedAppointments = state.appointments.map((a) {
      return a.id == updatedAppointment.id ? updatedAppointment : a;
    }).toList();
    emit(state.copyWith(appointments: updatedAppointments));
  }
}
