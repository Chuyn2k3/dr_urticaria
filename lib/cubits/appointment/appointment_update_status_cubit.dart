import 'package:dr_urticaria/di/locator.dart';
import 'package:dr_urticaria/utils/enum/appointment_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dr_urticaria/models/appointment/appointment_model.dart';
import 'package:dr_urticaria/core/base/base_response.dart';
import 'package:dr_urticaria/core/repositories/appointments_repository.dart';


part 'appointment_update_status_state.dart';

class AppointmentUpdateStatusCubit extends Cubit<AppointmentUpdateStatusState> {
  final  _repository=serviceLocator<AppointmentsRepository>();

  AppointmentUpdateStatusCubit()
      : super(AppointmentUpdateStatusInitial());

  Future<void> updateStatus(int appointmentId, AppointmentStatus status) async {
    emit(AppointmentUpdateStatusLoading());
    try {
      final response =
          await _repository.changeAppointmentStatus(appointmentId, status.serverKey);
      emit(AppointmentUpdateStatusSuccess(response.data!));
    } catch (e) {
      emit(AppointmentUpdateStatusFailure(e.toString()));
    }
  }
}
