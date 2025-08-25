import 'package:flutter/material.dart';

import 'enums.dart';

BoxBorder boxBorder({
  required bool isSolid,
  required bool isOuline,
  required bool isGhost,
  required Color borderColor,
}) {
  if (isOuline) {
    return Border.all(
      color: borderColor,
      width: 1,
      style: BorderStyle.solid,
    );
  } else if (isGhost) {
    return Border.all(
      color: borderColor,
      width: 1,
      style: BorderStyle.none,
    );
  } else {
    return Border.all(
      color: borderColor,
      width: 1,
      style: BorderStyle.none,
    );
  }
}

extension WidgetSetting on SLContentType {
  Widget toWidget(Widget? leading, Widget? labelText) {
    switch (this) {
      case SLContentType.textOnly:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [labelText ?? const SizedBox.shrink()],
        );
      case SLContentType.leadingIcon:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                leading != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          leading,
                          const SizedBox(
                            width: 8.0,
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
                labelText ?? const SizedBox.shrink(),
              ],
            )
          ],
        );
      case SLContentType.trailingIcon:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        labelText ?? const SizedBox.shrink(),
                        leading != null
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  leading,
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ],
                    )
                  ],
                )
              ],
            )
          ],
        );
      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [leading ?? const SizedBox.shrink()],
        );
    }
  }
}
