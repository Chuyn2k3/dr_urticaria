import 'package:dio/dio.dart';
import 'package:dr_urticaria/core/interceptor/api_exception.dart';

class GlobalErrorHandle {
  Object exception;

  GlobalErrorHandle(this.exception);

  String get errorCode {
    if (exception is DioError) {
      final error = (exception as DioError).error;
      if (error is ApiException) {
        final apiException = error;
        return apiException.code ?? "";
      }
      return (exception as DioError).response?.statusCode?.toString() ?? "";
    }
    return "";
  }

  String get errorKey {
    if (exception is DioError) {
      final error = (exception as DioError).error;
      if (error is ApiException) {
        final apiException = error;
        return apiException.errorKey ?? "";
      }
      return "";
    }
    return "";
  }

  String errorMessage() {
    if (exception is DioError) {
      final error = (exception as DioError).error;
      if (error is ApiException) {
        final apiException = error;
        return apiException.message ?? "";
      }
      return (exception as DioError).message;
    }
    return exception.toString();
  }
}
