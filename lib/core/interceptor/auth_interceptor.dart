import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dr_urticaria/constant/config.dart';
import 'package:dr_urticaria/core/logs.dart';
import 'package:dr_urticaria/utils/shared_preferences_manager.dart';
import 'package:get_it/get_it.dart';
import 'api_error_model.dart';
import 'api_exception.dart';

class TokenInterceptor extends InterceptorsWrapper {
  String? getAccessToken() {
    final accessToken = GetIt.instance
        .get<SharedPreferencesManager>()
        .getString(AppConfig.accessTokenKey);
    return accessToken;
  }

  bool isShowDialogAlert = false;

  Future<String> _getAppLanguage() async {
    try {
      var appLang = "vi";
      return appLang;
    } catch (e) {
      return "vi";
    }
  }

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = getAccessToken();
    if (accessToken == null) {
      return super.onRequest(options, handler);
    }
    options.headers["Authorization"] = "Bearer $accessToken";
    options.headers["Accept-Language"] = await _getAppLanguage();
    return super.onRequest(options, handler);
  }

  @override
  onError(DioError err, ErrorInterceptorHandler handler) async {
    try {
      final isLogin = err.response?.requestOptions.uri.path
              .contains("openid-connect/token") ??
          false;
      if (err.response?.statusCode == 401 && !isLogin) {
        if (!isShowDialogAlert) {
          isShowDialogAlert = true;
          //show dialog login
          // showAlertDialogLogout(onLogout: () {
          //   isShowDialogAlert = false;
          // });
        }
        handler.reject(err);
      } else {
        final apiException = await err.toApiException();
        err.error = apiException;
        handler.next(err);
      }
    } catch (e) {
      Log.e(e);
      handler.next(err);
    }
  }
}

extension on DioError {
  Future<ApiException> toApiException() async {
    final errorCode = response?.statusCode ?? 0;
    final path = response?.requestOptions.uri.path ?? '';

    dynamic responseData = response?.data;
    if (responseData is String) {
      try {
        responseData = jsonDecode(responseData);
      } catch (e) {
        Log.e(e);
      }
    }

    late APIError apiError;
    final String? error = responseData["error"] as String?;
    final String? errorDesc = responseData["error_description"] as String?;
    final isKeyCloakError = error != null && error.isNotEmpty;

    if (isKeyCloakError) {
      apiError = APIError(
        errorKey: error,
        message: errorDesc,
        path: path,
        status: errorCode,
      );
    } else {
      apiError = APIError.fromJson(responseData);
    }
    switch (errorCode) {
      case 400:
        return ApiException.badRequest(path, apiError.message,
            apiError.status.toString(), errorCode, apiError.errorKey);
      case 401:
        return ApiException.unauthorized(path, apiError.message,
            apiError.status.toString(), errorCode, apiError.errorKey);
      case 403:
        return ApiException.forbidden(path, apiError.message,
            apiError.status.toString(), errorCode, apiError.errorKey);
      case 404:
        return ApiException.notFound(path, apiError.message,
            apiError.status.toString(), errorCode, apiError.errorKey);
      case 500:
        return ApiException.internalServerError(path, apiError.message,
            apiError.status.toString(), errorCode, apiError.errorKey);
      default:
        final connectivity = await Connectivity().checkConnectivity();

        if (connectivity == ConnectivityResult.none) {
          return ApiException.noConnection(
              path, "Không có kết nối Internet", '', 0, '');
        }
        return ApiException.noConnection(
            path, "Không có kết nối Internet", '', 0, '');
    }
  }
}

class IDTokenInterceptor extends TokenInterceptor {
  @override
  String? getAccessToken() {
    final idTokenKey = GetIt.instance
        .get<SharedPreferencesManager>()
        .getString(AppConfig.idTokenKey);
    return idTokenKey;
  }
}
