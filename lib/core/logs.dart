import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

var _logger = Logger();

class Log {
  Log._();

  static void logPrint(dynamic message) {
    if (kDebugMode) {
      print(message);
    }
  }

  static void d(dynamic message) {
    if (kDebugMode) {
      _logger.d(message);
    }
  }

  static void e(dynamic message) {
    if (kDebugMode) {
      _logger.e(message);
    }
  }
}
