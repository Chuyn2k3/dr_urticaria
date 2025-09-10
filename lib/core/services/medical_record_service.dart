import 'package:dr_urticaria/core/base/base_response.dart';
import 'package:dr_urticaria/models/vital_indicator_model.dart';
import 'package:dr_urticaria/models/vital_value_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'medical_record_service.g.dart';

@RestApi()
abstract class MedicalRecordService {
  factory MedicalRecordService(Dio dio, {String baseUrl}) =
      _MedicalRecordService;

  @GET('/api/staff/medical-records/{id}/vital-values')
  Future<BaseListResponse<VitalValueModel>> getVitalValues(
      @Path('id') int medicalRecordId);

  @GET('/api/v1/vitals/indicators/{id}')
  Future<BaseResponse<VitalIndicatorModel>> getIndicator(
      @Path('id') int indicatorId);

  @PATCH('/api/staff/medical-records/{id}/vital-values')
  Future<BaseListResponse<VitalValueModel>> updateVitalValues(
    @Path('id') int medicalRecordId,
    @Body() Map<String, dynamic> body,
  );
}
