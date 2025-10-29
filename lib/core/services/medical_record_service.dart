import 'package:dr_urticaria/core/base/base_response.dart';
import 'package:dr_urticaria/models/vital_indicator_model.dart';
import 'package:dr_urticaria/models/vital_value_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../../medical_record_v2/create_medical_record/model/medical_record_template_model.dart';
import '../../medical_record_v2/create_medical_record/model/vital_group.dart';
import '../../medical_record_v2/create_medical_record/model/medical_record_request.dart';

part 'medical_record_service.g.dart';

@RestApi()
abstract class MedicalRecordService {
  factory MedicalRecordService(Dio dio, {String baseUrl}) =
      _MedicalRecordService;

  @GET('/api/staff/medical-records/{id}/vital-values')
  Future<BaseListResponse<VitalValueModel>> getVitalValues(
      @Path('id') int medicalRecordId);

  @GET('/api/v1/vitals/indicators/{id}')
  Future<BaseResponse<VitalIndicator>> getIndicator(
      @Path('id') int indicatorId);

  @PATCH('/api/staff/medical-records/{id}/vital-values')
  Future<BaseListResponse<VitalValueModel>> updateVitalValues(
    @Path('id') int medicalRecordId,
    @Body() Map<String, dynamic> body,
  );

  @GET("/api/staff/medical-record-templates/{id}")
  Future<BaseResponse<MedicalRecordTemplate>> getTemplate(@Path("id") int id);

  // Vitals group dùng chung v1 như hiện tại
  @GET("/api/v1/vitals/groups/{id}")
  Future<BaseResponse<VitalGroup>> getVitalGroup(@Path("id") int id);

  @POST("/api/staff/medical-records")
  Future<BaseResponse<dynamic>> createMedicalRecord(
    @Body() MedicalRecordRequest request,
  );
}
