import 'package:design_system_sl/theme/colors.dart';
import 'package:design_system_sl/theme/components/button/enums.dart';
import 'package:design_system_sl/theme/components/button/extention.dart';
import 'package:design_system_sl/theme/components/button/ultis.dart';
import 'package:flutter/material.dart';

class SLButton extends StatelessWidget {
  final bool isRounded;
  final Color borderColor;
  final Color backgroundColor;
  final Color textColor;
  final bool isSolid;
  final bool isOuline;
  final bool isGhost;
  final SLSize size;
  final String label;
  final Widget? leading;
  final SLContentType contentType;
  final bool isLoading;
  final bool isSkeleton;
  final VoidCallback? onTap;
  final bool isMaxWidth;
  final EdgeInsetsGeometry padding;
  const SLButton({
    Key? key,
    required this.isRounded,
    required this.borderColor,
    required this.backgroundColor,
    required this.textColor,
    required this.isSolid,
    required this.isGhost,
    required this.isOuline,
    required this.size,
    required this.label,
    required this.contentType,
    required this.isLoading,
    required this.isSkeleton,
    this.leading,
    this.onTap,
    required this.isMaxWidth,
    required this.padding,
  }) : super(key: key);

  factory SLButton.brand(
      {Key? key,
      Widget? leading,
      VoidCallback? onTap,
      bool isRounded = false,
      Color borderColor = SLColor.blueLight,
      Color backgroundColor = SLColor.blueLight,
      Color textColor = SLColor.blueLight,
      bool isSolid = true,
      bool isGhost = false,
      bool isOuline = false,
      SLSize size = SLSize.medium,
      required String label,
      SLContentType contentType = SLContentType.leadingIcon,
      bool isLoading = false,
      bool isSkeleton = false,
      bool isMaxWidth = false,
      EdgeInsetsGeometry padding = EdgeInsets.zero}) {
    return SLButton(
      key: key,
      leading: leading,
      onTap: onTap,
      isRounded: isRounded,
      borderColor: borderColor,
      backgroundColor: backgroundColor,
      textColor: textColor,
      isSolid: isSolid,
      isGhost: isGhost,
      isOuline: isOuline,
      size: size,
      label: label,
      contentType: contentType,
      isLoading: isLoading,
      isSkeleton: isSkeleton,
      isMaxWidth: isMaxWidth,
      padding: padding,
    );
  }

  @override
  Widget build(BuildContext context) {
    double opacity = 1;
    Color showBgColor = backgroundColor;
    Color showTextColor = textColor;
    Color showBorderColor = borderColor;
    if (!isOuline) {
      showBgColor = backgroundColor;
      showTextColor = SLColor.whiteLight;
    } else {
      showBgColor = SLColor.whiteLight;
    }
    if (isGhost) {
      showBgColor = Colors.transparent;
      showTextColor = backgroundColor;
    }
    if (isSkeleton) {
      opacity = 0;
      showBgColor = Colors.grey.withOpacity(0.35);
    }
    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Container(
          padding: size.padding(),
          width: isMaxWidth ? double.maxFinite : null,
          decoration: BoxDecoration(
            color: showBgColor,
            border: boxBorder(
              borderColor: showBorderColor,
              isGhost: isGhost,
              isOuline: isOuline,
              isSolid: isSolid,
            ),
            borderRadius: BorderRadius.circular(isRounded ? 40 : 8),
          ),
          child: contentType.toWidget(
            isLoading
                ? SizedBox(
                    height: size.padding().vertical * 1.3,
                    width: size.padding().vertical * 1.3,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: showTextColor,
                      backgroundColor: showTextColor.withOpacity(0.4),
                    ),
                  )
                : leading,
            Text(
              label,
              style: size.textStyle().copyWith(
                    color: showTextColor.withOpacity(opacity),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
