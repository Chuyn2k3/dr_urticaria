// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientModel _$PatientModelFromJson(Map<String, dynamic> json) => PatientModel(
      id: (json['id'] as num).toInt(),
      fullname: json['fullname'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      identityNumber: json['identityNumber'] as String?,
    );

Map<String, dynamic> _$PatientModelToJson(PatientModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullname,
      'phone': instance.phone,
      'email': instance.email,
      'birthday': instance.birthday?.toIso8601String(),
      'gender': instance.gender,
      'address': instance.address,
      'identityNumber': instance.identityNumber,
    };
