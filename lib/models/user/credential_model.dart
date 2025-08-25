import 'package:json_annotation/json_annotation.dart';

part 'credential_model.g.dart';

@JsonSerializable()
class CredentialModel {
  @JsonKey(name: "accessToken")
  final String token;

  const CredentialModel({
    required this.token,
  });

  factory CredentialModel.fromJson(Map<String, dynamic> json) =>
      _$CredentialModelFromJson(json);

  Map<String, dynamic> toJson() => _$CredentialModelToJson(this);
}
