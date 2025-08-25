// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CurlInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      if (kDebugMode) {
        final Map<String, dynamic> qp = options.queryParameters;
        final Map<String, dynamic> h = options.headers;
        final dynamic d = options.data;
        final String curl =
            'curl -X ${options.method} \'${options.baseUrl}${options.path}' +
                (qp.isNotEmpty
                    ? qp.keys.fold(
                        '',
                        (String value, String key) =>
                            '$value${value.isEmpty ? '?' : '&'}$key=${qp[key]}\'')
                    : '\'') +
                h.keys.fold(
                    '',
                    (String value, String key) =>
                        '$value -H \'$key: ${h[key]}\'') +
                (d.length != 0 ? ' --data-binary \'${json.encode(d)}\'' : '') +
                ' --insecure';
        print('server_curl: $curl');
        print("options.headers ${options.headers}");
      }
    } catch (e) {
      print('CurlInterceptor error: $e');
    }

    super.onRequest(options, handler);
  }
}
