import 'package:json_annotation/json_annotation.dart';

import '../../../models/vital_indicator_model.dart';

part 'vital_group.g.dart';

@JsonSerializable(explicitToJson: true)
class VitalGroup {
  final int id;
  final String name;
  final String? description;
  final List<VitalIndicator> indicators;
  final DateTime createdAt;
  final DateTime updatedAt;

  VitalGroup({
    required this.id,
    required this.name,
    this.description,
    required this.indicators,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VitalGroup.fromJson(Map<String, dynamic> json) =>
      _$VitalGroupFromJson(json);

  Map<String, dynamic> toJson() => _$VitalGroupToJson(this);
}
