import 'package:json_annotation/json_annotation.dart';

part 'vital_value_model.g.dart';
@JsonSerializable(explicitToJson: true)
class VitalValueModel {
final int id;
final int medicalRecordId;
final int vitalIndicatorId;
final VitalValueWrapper? value;
final String? note;
final DateTime createdAt;
final DateTime updatedAt;


VitalValueModel({
required this.id,
required this.medicalRecordId,
required this.vitalIndicatorId,
required this.value,
this.note,
required this.createdAt,
required this.updatedAt,
});


factory VitalValueModel.fromJson(Map<String, dynamic> json) => _$VitalValueModelFromJson(json);
Map<String, dynamic> toJson() => _$VitalValueModelToJson(this);
}


@JsonSerializable()
class VitalValueWrapper {
/// API shape: { "value": dynamic }
final dynamic value;


VitalValueWrapper({this.value});


factory VitalValueWrapper.fromJson(Map<String, dynamic> json) => _$VitalValueWrapperFromJson(json);
Map<String, dynamic> toJson() => _$VitalValueWrapperToJson(this);
}