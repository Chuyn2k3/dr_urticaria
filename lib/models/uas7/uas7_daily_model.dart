import 'package:json_annotation/json_annotation.dart';

part 'uas7_daily_model.g.dart';

DateTime _dateFromJson(String v) => DateTime.parse(v);
String _dateToJson(DateTime d) => d.toIso8601String().split('T').first;

DateTime? _nullableDateFromJson(String? v) =>
    v == null ? null : DateTime.parse(v);
String? _nullableDateToJson(DateTime? d) => d?.toIso8601String();

@JsonSerializable()
class Uas7DailyModel {
  final int id;
  final int patientId;
  final int itchLevel;
  final int whealLevel;

  /// backend trả `"2025-12-12"`
  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime recordDate;

  final String? note;

  @JsonKey(fromJson: _nullableDateFromJson, toJson: _nullableDateToJson)
  final DateTime? createdAt;

  @JsonKey(fromJson: _nullableDateFromJson, toJson: _nullableDateToJson)
  final DateTime? updatedAt;

  const Uas7DailyModel({
    required this.id,
    required this.patientId,
    required this.itchLevel,
    required this.whealLevel,
    required this.recordDate,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  int get dailyScore => itchLevel + whealLevel;

  factory Uas7DailyModel.fromJson(Map<String, dynamic> json) =>
      _$Uas7DailyModelFromJson(json);

  Map<String, dynamic> toJson() => _$Uas7DailyModelToJson(this);
}
