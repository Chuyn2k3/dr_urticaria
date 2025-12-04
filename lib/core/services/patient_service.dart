import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dr_urticaria/core/base/base_response.dart';
import 'package:dr_urticaria/models/patient/patient_model.dart';

part 'patient_service.g.dart';

@RestApi()
abstract class PatientServices {
  factory PatientServices(Dio dio, {String baseUrl}) = _PatientServices;

  @GET("/api/v1/staff/patients")
  Future<BaseListResponse<PatientModel>> getPatients(
    @Query("limit") int limit,
    @Query("page") int page, {
    @Query("search") String? search,
    @Query("phone") String? phone,
    @Query("identityNumber") String? identityNumber,
    @Query("sort") String? sort,
  });
}
