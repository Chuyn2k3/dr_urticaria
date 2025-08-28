import 'package:dr_urticaria/core/base/base_response.dart';
import 'package:dr_urticaria/models/appointment/appointment_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'appointments_service.g.dart';

@RestApi()
abstract class AppointmentsService {
  factory AppointmentsService(Dio dio, {String baseUrl}) = _AppointmentsService;

  @GET('/api/v1/staff/appointments')
  Future<BaseListResponse<AppointmentModel>> getAppointments({
    @Query('page') required int page,
    @Query('limit') required int limit,
    @Query('reason') String? reason,
    @Query('status') String? status,
    @Query('appointmentDateFrom') String? appointmentDateFrom,
    @Query('appointmentDateTo') String? appointmentDateTo,
  });
}
