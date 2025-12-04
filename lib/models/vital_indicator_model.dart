import 'package:json_annotation/json_annotation.dart';
part 'vital_indicator_model.g.dart';

@JsonSerializable(explicitToJson: true)
class VitalIndicator {
  final int id;
  final String code;
  final String name;
  final String? unit;
  final String? description;
  final String valueType; // text, number, select, date, boolean
  /// valueOptions có thể là List<String>, Map<String,dynamic>, hoặc null
  @JsonKey(fromJson: _fromDynamic, toJson: _toDynamic)
  final dynamic valueOptions;
  final List<String>? visibility;
  final String? minValue;
  final String? maxValue;
  final bool isActive;
  final int? groupId;
  final VitalGroupInfo? group;
  final DateTime createdAt;
  final DateTime updatedAt;

  VitalIndicator({
    required this.id,
    required this.code,
    required this.name,
    this.unit,
    this.description,
    required this.valueType,
    this.valueOptions,
    this.visibility,
    this.minValue,
    this.maxValue,
    required this.isActive,
    this.groupId,
    this.group,
    required this.createdAt,
    required this.updatedAt,
  });
  bool get isVisibleToPatient => visibility != null
      ? (visibility!.contains('staff') || visibility!.isEmpty)
      : true;
  factory VitalIndicator.fromJson(Map<String, dynamic> json) =>
      _$VitalIndicatorFromJson(json);
  Map<String, dynamic> toJson() => _$VitalIndicatorToJson(this);

  /// Parse dynamic cho valueOptions
  static dynamic _fromDynamic(dynamic json) {
    if (json == null) return null;
    if (json is List) return List<String>.from(json.map((e) => e.toString()));
    if (json is Map<String, dynamic>) return json;
    return json.toString();
  }

  static dynamic _toDynamic(dynamic obj) => obj;
}

@JsonSerializable()
class VitalGroupInfo {
  final int id;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  VitalGroupInfo({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VitalGroupInfo.fromJson(Map<String, dynamic> json) =>
      _$VitalGroupInfoFromJson(json);

  Map<String, dynamic> toJson() => _$VitalGroupInfoToJson(this);
}
