import 'package:dr_urticaria/core/base/base_response.dart';
import 'package:dr_urticaria/models/medical_record_list_item.dart';
import 'package:dr_urticaria/models/medical_record_query.dart';
import 'package:intl/intl.dart';

import '../services/medical_records_service.dart';

abstract class MedicalRecordsRepository {
  Future<BaseListResponse<MedicalRecordListItem>> fetchMedicalRecords(
      MedicalRecordQuery query);
}

class MedicalRecordsRepositoryImpl implements MedicalRecordsRepository {
  final MedicalRecordsService _service;

  MedicalRecordsRepositoryImpl(this._service);

  static final _iso = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

  @override
  Future<BaseListResponse<MedicalRecordListItem>> fetchMedicalRecords(
      MedicalRecordQuery q) {
    String? _f(DateTime? d) => d == null ? null : _iso.format(d.toUtc());

    return _service.getMedicalRecords(
      page: q.page,
      limit: q.limit,
      diagnosis: q.diagnosis,
      symptoms: q.symptoms,
      phone: q.phone,
      fullName: q.fullName,
      appointmentId: q.appointmentId,
      createdAtFrom: _f(q.createdAtFrom),
      createdAtTo: _f(q.createdAtTo),
      updatedAtFrom: _f(q.updatedAtFrom),
      updatedAtTo: _f(q.updatedAtTo),
    );
  }
}
