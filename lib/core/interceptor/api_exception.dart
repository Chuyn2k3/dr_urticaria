import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_exception.freezed.dart';

@freezed
class ApiException with _$ApiException implements Exception {
  const factory ApiException.badRequest(String path, String? message,
      String? code, int? statusCode, String? errorKey) = BadRequest;

  const factory ApiException.unauthorized(String path, String? message,
      String? code, int? statusCode, String? errorKey) = Unauthorized;

  const factory ApiException.forbidden(String path, String? message,
      String? code, int? statusCode, String? errorKey) = Forbidden;

  const factory ApiException.notFound(String path, String? message,
      String? code, int? statusCode, String? errorKey) = NotFound;

  const factory ApiException.internalServerError(String path, String? message,
      String? code, int? statusCode, String? errorKey) = InternalServerError;

  const factory ApiException.noConnection(String path, String? message,
      String? code, int? statusCode, String? errorKey) = NoConnection;

  const factory ApiException.other(
      String? message, String? code, int? statusCode, String? errorKey) = Other;
}
