// import 'package:dio/dio.dart';
// import 'package:urticaria/core/api_result.dart';
// import 'package:urticaria/core/data/model/api_response.dart';
// import 'package:urticaria/core/data/model/form_submission_response.dart';
// import 'package:urticaria/core/services/urticaria_api_service.dart';
// import 'package:urticaria/feature/medical_record_v2/models/acute_urticaria_record.dart';
// import 'package:urticaria/feature/medical_record_v2/models/chronic_urticaria_followup_record.dart';
// import 'package:urticaria/feature/medical_record_v2/models/chronic_urticaria_initial_record.dart';

// abstract class UrticariaRepository {
//   Future<ApiResult<FormSubmissionResponse>> submitAcuteForm(
//       AcuteUrticariaRecord record);
//   Future<ApiResult<FormSubmissionResponse>> submitChronicInitialForm(
//       ChronicUrticariaInitialRecord record);
//   Future<ApiResult<FormSubmissionResponse>> submitChronicFollowupForm(
//       ChronicUrticariaFollowupRecord record);

//   Future<ApiResult<AcuteUrticariaRecord>> getAcuteForm(String id);
//   Future<ApiResult<ChronicUrticariaInitialRecord>> getChronicInitialForm(
//       String id);
//   Future<ApiResult<ChronicUrticariaFollowupRecord>> getChronicFollowupForm(
//       String id);

//   Future<ApiResult<FormSubmissionResponse>> updateAcuteForm(
//       String id, AcuteUrticariaRecord record);
//   Future<ApiResult<FormSubmissionResponse>> updateChronicInitialForm(
//       String id, ChronicUrticariaInitialRecord record);
//   Future<ApiResult<FormSubmissionResponse>> updateChronicFollowupForm(
//       String id, ChronicUrticariaFollowupRecord record);

//   Future<ApiResult<List<FormSubmissionResponse>>> getPatientForms(
//       String patientId,
//       {String? formType,
//       String? status});
//   Future<ApiResult<List<String>>> uploadImages(
//       List<String> imagePaths, String fieldName,
//       {String? formId});
// }

// class UrticariaRepositoryImpl implements UrticariaRepository {
//   final UrticariaApiService _apiService;

//   UrticariaRepositoryImpl(this._apiService);

//   @override
//   Future<ApiResult<FormSubmissionResponse>> submitAcuteForm(
//       AcuteUrticariaRecord record) async {
//     try {
//       final response = await _apiService.submitAcuteForm(record);

//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   @override
//   Future<ApiResult<FormSubmissionResponse>> submitChronicInitialForm(
//       ChronicUrticariaInitialRecord record) async {
//     try {
//       final response = await _apiService.submitChronicInitialForm(record);

//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   @override
//   Future<ApiResult<FormSubmissionResponse>> submitChronicFollowupForm(
//       ChronicUrticariaFollowupRecord record) async {
//     try {
//       final response = await _apiService.submitChronicFollowupForm(record);

//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   @override
//   Future<ApiResult<AcuteUrticariaRecord>> getAcuteForm(String id) async {
//     try {
//       final response = await _apiService.getAcuteForm(id);

//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   @override
//   Future<ApiResult<ChronicUrticariaInitialRecord>> getChronicInitialForm(
//       String id) async {
//     try {
//       final response = await _apiService.getChronicInitialForm(id);

//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   @override
//   Future<ApiResult<ChronicUrticariaFollowupRecord>> getChronicFollowupForm(
//       String id) async {
//     try {
//       final response = await _apiService.getChronicFollowupForm(id);

//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   @override
//   Future<ApiResult<FormSubmissionResponse>> updateAcuteForm(
//       String id, AcuteUrticariaRecord record) async {
//     try {
//       final response = await _apiService.updateAcuteForm(id, record);

//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   @override
//   Future<ApiResult<FormSubmissionResponse>> updateChronicInitialForm(
//       String id, ChronicUrticariaInitialRecord record) async {
//     try {
//       final response = await _apiService.updateChronicInitialForm(id, record);

//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   @override
//   Future<ApiResult<FormSubmissionResponse>> updateChronicFollowupForm(
//       String id, ChronicUrticariaFollowupRecord record) async {
//     try {
//       final response = await _apiService.updateChronicFollowupForm(id, record);

//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   @override
//   Future<ApiResult<List<FormSubmissionResponse>>> getPatientForms(
//       String patientId,
//       {String? formType,
//       String? status}) async {
//     try {
//       final response = await _apiService.getPatientForms(
//           patientId, formType, status, null, null);

//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   @override
//   Future<ApiResult<List<String>>> uploadImages(
//       List<String> imagePaths, String fieldName,
//       {String? formId}) async {
//     try {
//       final multipartFiles = <MultipartFile>[];
//       for (final path in imagePaths) {
//         multipartFiles.add(await MultipartFile.fromFile(path));
//       }

//       final response =
//           await _apiService.uploadImages(multipartFiles, formId, fieldName);

//       return response;
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
