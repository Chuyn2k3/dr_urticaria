import 'package:dio/dio.dart';
import 'package:dr_urticaria/core/interceptor/auth_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class HttpService {
  final String baseUrl;
  final bool isAuthenticate;
  final String contentType;
  final InterceptorsWrapper tokenInterceptorsWrapper;
  final InterceptorsWrapper? curlInterceptor;
  final InterceptorsWrapper? logInterceptor;

  HttpService({
    required this.baseUrl,
    required this.tokenInterceptorsWrapper,
    this.contentType = Headers.jsonContentType,
    this.isAuthenticate = true,
    this.curlInterceptor,
    this.logInterceptor,
  });

  Dio build() {
    final options = BaseOptions(
      connectTimeout: 120000,
      receiveTimeout: 120000,
      responseType: ResponseType.json,
      baseUrl: baseUrl,
    );
    final Dio dio = Dio(options);

    dio.options.headers[Headers.contentTypeHeader] = contentType;

    if (kDebugMode) {
      // dio.interceptors.add(
      //   curlInterceptor ?? CurlInterceptor(),
      // );
      dio.interceptors.add(
        logInterceptor ??
            PrettyDioLogger(
              requestHeader: true,
              requestBody: true,
              responseBody:
                  false, // Có 1 API response bị lỗi hiện thị nên bị crash response nên disable đi.
            ),
      );
    }
    if (isAuthenticate) {
      dio.interceptors.add(tokenInterceptorsWrapper);
    }
    return dio;
  }
}

Future<Dio> setupDio({
  required String baseUrl,
  required bool isHaveToken,
}) async {
  final dioBuilder = HttpService(
    baseUrl: baseUrl,
    isAuthenticate: isHaveToken,
    tokenInterceptorsWrapper: TokenInterceptor(),
  );
  return dioBuilder.build();
}
