import 'package:dr_urticaria/core/base/base_response.dart';
import 'package:dr_urticaria/core/services/patient_service.dart';
import 'package:dr_urticaria/models/patient/patient_model.dart';

abstract class PatientRepository {
  Future<BaseListResponse<PatientModel>> getPatients({
    required int page,
    int limit,
    String? search,
    String? phone,
    String? identityNumber,
    String? sort,
  });
}

class PatientRepositoryImpl implements PatientRepository {
  final PatientServices patientServices;

  const PatientRepositoryImpl({required this.patientServices});

  @override
  Future<BaseListResponse<PatientModel>> getPatients({
    required int page,
    int limit = 10,
    String? search,
    String? phone,
    String? identityNumber,
    String? sort = 'createdAt:DESC',
  }) async {
    try {
      final result = await patientServices.getPatients(
        limit,
        page,
        search: search,
        phone: phone,
        identityNumber: identityNumber,
        sort: sort,
      );
      print(result.data);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
