// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_record_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalRecordRequest _$MedicalRecordRequestFromJson(
        Map<String, dynamic> json) =>
    MedicalRecordRequest(
      templateId: (json['templateId'] as num).toInt(),
      patientId: (json['patientId'] as num).toInt(),
      vitalValues: (json['vitalValues'] as List<dynamic>)
          .map((e) => VitalValueRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      doctorId: (json['doctorId'] as num?)?.toInt(),
      appointmentId: (json['appointmentId'] as num?)?.toInt(),
      diagnosis: json['diagnosis'] as String?,
      symptoms: json['symptoms'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$MedicalRecordRequestToJson(
    MedicalRecordRequest instance) {
  final val = <String, dynamic>{
    'templateId': instance.templateId,
    'patientId': instance.patientId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('doctorId', instance.doctorId);
  writeNotNull('appointmentId', instance.appointmentId);
  writeNotNull('diagnosis', instance.diagnosis);
  writeNotNull('symptoms', instance.symptoms);
  writeNotNull('notes', instance.notes);
  val['vitalValues'] = instance.vitalValues.map((e) => e.toJson()).toList();
  return val;
}

VitalValueRequest _$VitalValueRequestFromJson(Map<String, dynamic> json) =>
    VitalValueRequest(
      vitalIndicatorId: (json['vitalIndicatorId'] as num).toInt(),
      groupId: (json['groupId'] as num).toInt(),
      value: json['value'],
      note: json['note'] as String?,
    );

Map<String, dynamic> _$VitalValueRequestToJson(VitalValueRequest instance) =>
    <String, dynamic>{
      'vitalIndicatorId': instance.vitalIndicatorId,
      'groupId': instance.groupId,
      'value': instance.value,
      'note': instance.note,
    };
