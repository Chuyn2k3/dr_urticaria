import 'package:design_system_sl/theme/components/button/enums.dart';
import 'package:design_system_sl/typography/typography.dart';
import 'package:flutter/material.dart';

extension ExtenstionSize on SLSize {
  EdgeInsetsGeometry padding() {
    switch (this) {
      case SLSize.small:
        return const EdgeInsets.symmetric(vertical: 3, horizontal: 12)
            .copyWith(top: 2);
      case SLSize.medium:
        return const EdgeInsets.symmetric(vertical: 5.5, horizontal: 12)
            .copyWith(top: 4.5);
      default:
        return const EdgeInsets.symmetric(vertical: 8, horizontal: 12)
            .copyWith(top: 10, bottom: 10);
    }
  }

  TextStyle textStyle() {
    switch (this) {
      case SLSize.small:
        return SLStyle.t12M;
      case SLSize.medium:
        return SLStyle.t14B;
      default:
        return SLStyle.t16R;
    }
  }
}
