import 'package:dio/dio.dart';
import 'package:dr_urticaria/models/medical_record_list_item.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dr_urticaria/core/base/base_response.dart';

part 'medical_records_service.g.dart';

@RestApi()
abstract class MedicalRecordsService {
  factory MedicalRecordsService(Dio dio, {String baseUrl}) =
      _MedicalRecordsService;

  @GET('/api/staff/medical-records')
  Future<BaseListResponse<MedicalRecordListItem>> getMedicalRecords({
    @Query('page') required int page,
    @Query('limit') required int limit,
    @Query('diagnosis') String? diagnosis,
    @Query('symptoms') String? symptoms,
    @Query('phone') String? phone,
    @Query('fullName') String? fullName,
    @Query('appointmentId') int? appointmentId,
    @Query('createdAtFrom') String? createdAtFrom,
    @Query('createdAtTo') String? createdAtTo,
    @Query('updatedAtFrom') String? updatedAtFrom,
    @Query('updatedAtTo') String? updatedAtTo,
  });
}
