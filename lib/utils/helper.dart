import 'package:flutter/material.dart';

double widthConvert(BuildContext context, double width) {
  Size size = MediaQuery.of(context).size;
  return size.width * width / 375;
}

double heightConvert(BuildContext context, double height) {
  Size size = MediaQuery.of(context).size;
  return size.height * height / 812;
}

bool isNotEmptyNullString(String? value) {
  return value != null && value.isNotEmpty;
}

/// +84123456789 -> 0123456789
/// 84123456789 -> 0123456789
String replacePhoneCode(String phone) {
  if (phone.startsWith('84')) {
    return phone.replaceFirst('84', '0');
  }
  return phone.replaceAll('+84', '0');
}

enum UserStatus { Checking, Signed, NoData }
