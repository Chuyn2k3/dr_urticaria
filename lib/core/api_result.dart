import 'package:equatable/equatable.dart';

abstract class ApiResult<T> extends Equatable {
  const ApiResult();
}

class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  final String? message;

  const ApiSuccess(this.data, {this.message});

  @override
  List<Object?> get props => [data, message];
}

class ApiFailure<T> extends ApiResult<T> {
  final String message;
  final int? statusCode;
  final dynamic error;

  const ApiFailure(this.message, {this.statusCode, this.error});

  @override
  List<Object?> get props => [message, statusCode, error];
}

class ApiLoading<T> extends ApiResult<T> {
  const ApiLoading();

  @override
  List<Object?> get props => [];
}
