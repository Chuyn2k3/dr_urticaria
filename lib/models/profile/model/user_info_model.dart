import 'package:json_annotation/json_annotation.dart';

part 'user_info_model.g.dart';

enum Gender { MALE, FEMALE, OTHER }

@JsonSerializable()
class UserInfoModel {
  final int id;
  final String? fullname;
  final String? phone;
  final String? email;
  final String? birthday;
  final Gender? gender;
  final String? address;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserInfoModel({
    required this.id,
    this.fullname,
    this.phone,
    this.email,
    this.birthday,
    this.gender,
    this.address,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);
}
