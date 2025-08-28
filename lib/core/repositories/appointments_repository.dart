import 'package:dr_urticaria/core/base/base_response.dart';
import 'package:dr_urticaria/models/appointment/appointment_model.dart';
import 'package:dr_urticaria/models/appointment_request.dart';
import 'package:intl/intl.dart';
import '../services/appointments_service.dart';

abstract class AppointmentsRepository {
  Future<BaseListResponse<AppointmentModel>> fetchAppointments(
      AppointmentsQuery query);
}

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  final AppointmentsService _service;

  AppointmentsRepositoryImpl(this._service);

  static final _iso = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

  @override
  Future<BaseListResponse<AppointmentModel>> fetchAppointments(
      AppointmentsQuery q) {
    return _service.getAppointments(
      page: q.page,
      limit: q.limit,
      reason: q.reason,
      status: q.status?.serverKey,
      appointmentDateFrom: q.appointmentDateFrom != null
          ? _iso.format(q.appointmentDateFrom!.toUtc())
          : null,
      appointmentDateTo: q.appointmentDateTo != null
          ? _iso.format(q.appointmentDateTo!.toUtc())
          : null,
    );
  }
}
