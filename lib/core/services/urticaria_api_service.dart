// import 'package:dio/dio.dart';
// import 'package:retrofit/retrofit.dart';
// import 'package:urticaria/core/api_result.dart';
// import 'package:urticaria/core/data/model/api_response.dart';
// import 'package:urticaria/core/data/model/form_submission_response.dart';
// import 'package:urticaria/feature/medical_record_v2/models/acute_urticaria_record.dart';
// import 'package:urticaria/feature/medical_record_v2/models/chronic_urticaria_followup_record.dart';
// import 'package:urticaria/feature/medical_record_v2/models/chronic_urticaria_initial_record.dart';

// part 'urticaria_api_service.g.dart';

// @RestApi()
// abstract class UrticariaApiService {
//   factory UrticariaApiService(Dio dio) = _UrticariaApiService;

//   // Acute Urticaria Form APIs
//   @POST('/forms/acute')
//   Future<ApiResult<FormSubmissionResponse>> submitAcuteForm(
//     @Body() AcuteUrticariaRecord record,
//   );

//   @GET('/forms/acute/{id}')
//   Future<ApiResult<AcuteUrticariaRecord>> getAcuteForm(
//     @Path('id') String id,
//   );

//   @PUT('/forms/acute/{id}')
//   Future<ApiResult<FormSubmissionResponse>> updateAcuteForm(
//     @Path('id') String id,
//     @Body() AcuteUrticariaRecord record,
//   );

//   // Chronic Initial Form APIs
//   @POST('/forms/chronic-initial')
//   Future<ApiResult<FormSubmissionResponse>> submitChronicInitialForm(
//     @Body() ChronicUrticariaInitialRecord record,
//   );

//   @GET('/forms/chronic-initial/{id}')
//   Future<ApiResult<ChronicUrticariaInitialRecord>> getChronicInitialForm(
//     @Path('id') String id,
//   );

//   @PUT('/forms/chronic-initial/{id}')
//   Future<ApiResult<FormSubmissionResponse>> updateChronicInitialForm(
//     @Path('id') String id,
//     @Body() ChronicUrticariaInitialRecord record,
//   );

//   // Chronic Followup Form APIs
//   @POST('/forms/chronic-followup')
//   Future<ApiResult<FormSubmissionResponse>> submitChronicFollowupForm(
//     @Body() ChronicUrticariaFollowupRecord record,
//   );

//   @GET('/forms/chronic-followup/{id}')
//   Future<ApiResult<ChronicUrticariaFollowupRecord>> getChronicFollowupForm(
//     @Path('id') String id,
//   );

//   @PUT('/forms/chronic-followup/{id}')
//   Future<ApiResult<FormSubmissionResponse>> updateChronicFollowupForm(
//     @Path('id') String id,
//     @Body() ChronicUrticariaFollowupRecord record,
//   );

//   // Patient Forms APIs
//   @GET('/patients/{patientId}/forms')
//   Future<ApiResult<List<FormSubmissionResponse>>> getPatientForms(
//     @Path('patientId') String patientId,
//     @Query('type') String? formType,
//     @Query('status') String? status,
//     @Query('page') int? page,
//     @Query('limit') int? limit,
//   );

//   // Image Upload APIs
//   @POST('/upload/images')
//   @MultiPart()
//   Future<ApiResult<List<String>>> uploadImages(
//     @Part() List<MultipartFile> images,
//     @Part(name: 'formId') String? formId,
//     @Part(name: 'fieldName') String fieldName,
//   );

//   // Statistics APIs
//   @GET('/statistics/forms')
//   Future<ApiResult<Map<String, dynamic>>> getFormStatistics(
//     @Query('startDate') String? startDate,
//     @Query('endDate') String? endDate,
//     @Query('formType') String? formType,
//   );
// }
