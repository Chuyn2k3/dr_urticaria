part of 'appointment_update_status_cubit.dart';

abstract class AppointmentUpdateStatusState {}

class AppointmentUpdateStatusInitial extends AppointmentUpdateStatusState {}

class AppointmentUpdateStatusLoading extends AppointmentUpdateStatusState {}

class AppointmentUpdateStatusSuccess extends AppointmentUpdateStatusState {
  final AppointmentModel appointment;
  AppointmentUpdateStatusSuccess(this.appointment);
}

class AppointmentUpdateStatusFailure extends AppointmentUpdateStatusState {
  final String message;
  AppointmentUpdateStatusFailure(this.message);
}
