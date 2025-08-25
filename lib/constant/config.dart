// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class AppConfig {
  AppConfig._();
  static const SL_USERNAME = "SL_USERNAME";
  static const SL_PASSWORD = "SL_PASSWORD";
  static const SL_REMEMBER_PASSWORD = "SL_REMEMBER_PASSWORD";
  static var accessTokenKey = "accessToken";
  static var idTokenKey = "idTokenKey";
  static var fcmDeviceTokenKey = "fcmDeviceTokenKey";
}

extension GetOrientation on BuildContext {
  Orientation get orientation => MediaQuery.of(this).orientation;
}

extension GetSize on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
}
