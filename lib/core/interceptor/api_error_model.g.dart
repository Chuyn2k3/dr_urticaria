// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

APIError _$APIErrorFromJson(Map<String, dynamic> json) => APIError(
      type: json['type'] as String?,
      title: json['title'] as String?,
      status: (json['status'] as num?)?.toInt(),
      detail: json['detail'] as String?,
      path: json['path'] as String?,
      message: json['message'] as String?,
      errorKey: json['errorKey'] as String?,
    );

Map<String, dynamic> _$APIErrorToJson(APIError instance) => <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'status': instance.status,
      'detail': instance.detail,
      'path': instance.path,
      'message': instance.message,
      'errorKey': instance.errorKey,
    };
