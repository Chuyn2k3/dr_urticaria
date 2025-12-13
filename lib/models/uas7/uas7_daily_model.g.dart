// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uas7_daily_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Uas7DailyModel _$Uas7DailyModelFromJson(Map<String, dynamic> json) =>
    Uas7DailyModel(
      id: (json['id'] as num).toInt(),
      patientId: (json['patientId'] as num).toInt(),
      itchLevel: (json['itchLevel'] as num).toInt(),
      whealLevel: (json['whealLevel'] as num).toInt(),
      recordDate: _dateFromJson(json['recordDate'] as String),
      note: json['note'] as String?,
      createdAt: _nullableDateFromJson(json['createdAt'] as String?),
      updatedAt: _nullableDateFromJson(json['updatedAt'] as String?),
    );

Map<String, dynamic> _$Uas7DailyModelToJson(Uas7DailyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'itchLevel': instance.itchLevel,
      'whealLevel': instance.whealLevel,
      'recordDate': _dateToJson(instance.recordDate),
      'note': instance.note,
      'createdAt': _nullableDateToJson(instance.createdAt),
      'updatedAt': _nullableDateToJson(instance.updatedAt),
    };
