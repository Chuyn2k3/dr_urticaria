import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:dr_urticaria/core/base/base_response.dart';
import 'package:dr_urticaria/models/uas7/uas7_daily_model.dart';

part 'uas7_service.g.dart';

@RestApi()
abstract class Uas7Service {
  factory Uas7Service(Dio dio, {String baseUrl}) = _Uas7Service;

  /// GET /api/v1/uas7-point-daily/staff/patient/{patientId}
  @GET('/api/v1/uas7-point-daily/staff/patient/{patientId}')
  Future<BaseResponse<List<Uas7DailyModel>>> getDailyByPatient(
    @Path('patientId') int patientId, {
    @Query('recordDateFrom') String? recordDateFrom,
    @Query('recordDateTo') String? recordDateTo,
  });

  /// PUT /api/v1/uas7-point-daily/staff/{id}
  @PUT('/api/v1/uas7-point-daily/staff/{id}')
  Future<BaseResponse<Uas7DailyModel>> updateDaily(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );
}
