// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_records_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _MedicalRecordsService implements MedicalRecordsService {
  _MedicalRecordsService(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<BaseListResponse<MedicalRecordListItem>> getMedicalRecords({
    required page,
    required limit,
    diagnosis,
    symptoms,
    phone,
    fullName,
    appointmentId,
    createdAtFrom,
    createdAtTo,
    updatedAtFrom,
    updatedAtTo,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': page,
      r'limit': limit,
      r'diagnosis': diagnosis,
      r'symptoms': symptoms,
      r'phone': phone,
      r'fullName': fullName,
      r'appointmentId': appointmentId,
      r'createdAtFrom': createdAtFrom,
      r'createdAtTo': createdAtTo,
      r'updatedAtFrom': updatedAtFrom,
      r'updatedAtTo': updatedAtTo,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseListResponse<MedicalRecordListItem>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/staff/medical-records',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseListResponse<MedicalRecordListItem>.fromJson(
      _result.data!,
      (json) => MedicalRecordListItem.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
