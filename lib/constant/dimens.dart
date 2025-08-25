// Padding begin.
import 'package:flutter/cupertino.dart';
//import 'package:responsive_framework/responsive_framework.dart';

const double kDefaultPadding = 16.0;

const double kTextPadding = 4.0;
// Padding end.

// Screen width begin.
const double kScreenWidthSm = 576.0;

const double kScreenWidthMd = 768.0;

const double kScreenWidthLg = 992.0;

const double kScreenWidthXl = 1200.0;

const double kScreenWidthXxl = 1400.0;
// Screen width end.

// Dialog width begin.
const double kDialogWidth = 460.0;
// Dialog width end.

class Dimens {
  Dimens._privateConstructor();
  static final Dimens _instance = Dimens._privateConstructor();
  static Dimens get instance => _instance;

  final double _sidebarWidthMin = 70;
  final double _sidebarWidthMax = 280;

  double space1(BuildContext context) {
    return _value(context, 4, specialMobileValue: 2);
  }

  double space2(BuildContext context) {
    return _value(context, 8, specialMobileValue: 4);
  }

  /// spaceX => pixel = X * 4;
  double space3(BuildContext context) {
    return _value(context, 12, specialMobileValue: 6);
  }

  double space4(BuildContext context) {
    return _value(context, 16, specialMobileValue: 8);
  }

  /// spaceX => pixel = X * 4;
  double space5(BuildContext context) {
    return _value(context, 20, specialMobileValue: 10);
  }

  /// spaceX => pixel = X * 4;
  double space8(BuildContext context) {
    return _value(context, 32, specialMobileValue: 12);
  }

  /// Corner radius
  double roundedSM(BuildContext context) {
    return _value(context, 2);
  }

  double rounded(BuildContext context) {
    return _value(context, 4);
  }

  double roundedMD(BuildContext context) {
    return _value(context, 6);
  }

  double roundedLG(BuildContext context) {
    return _value(context, 8);
  }

  double roundedXL(BuildContext context) {
    return _value(context, 12);
  }

  double rounded2XL(BuildContext context) {
    return _value(context, 16);
  }

  double rounded3XL(BuildContext context) {
    return _value(context, 24);
  }

  double roundedFull(BuildContext context) {
    return _value(context, 999);
  }

  double _value(
    BuildContext context,
    double value, {
    double? specialMobileValue,
  }) {
    final margin = 16.0;

    return margin;
  }

  double sidebarWidth(bool isCollapse) {
    if (isCollapse) {
      return _sidebarWidthMin;
    }
    return _sidebarWidthMax;
  }
}
