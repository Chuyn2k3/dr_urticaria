import 'package:json_annotation/json_annotation.dart';

part 'api_error_model.g.dart';

@JsonSerializable()
class APIError {
  APIError({
    this.type,
    this.title,
    this.status,
    this.detail,
    this.path,
    this.message,
    this.errorKey,
  });

  String? type;

  String? title;

  int? status;

  String? detail;

  String? path;

  String? message;

  String? errorKey;
  factory APIError.fromJson(Map<String, dynamic> json) =>
      _$APIErrorFromJson(json);

  Map<String, dynamic> toJson() => _$APIErrorToJson(this);
}
