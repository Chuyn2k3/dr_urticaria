import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/helper.dart';
import '../utils/icons.dart';
import '../utils/styles.dart';

class AppButtonOutline extends StatelessWidget {
  final String text;
  final String? iconLeft;
  final String? iconRight;
  final Function()? onClick;
  final Color? color;
  final String? phoneNumber;
  final TextStyle? labelStyle;
  final double? iconSize;
  final double? buttonSize;
  final BorderRadiusGeometry? borderRadius;
  const AppButtonOutline(
      {Key? key,
      required this.text,
      this.iconLeft,
      this.iconRight,
      this.onClick,
      this.color,
      this.phoneNumber,
      this.labelStyle,
      this.iconSize = 24,
      this.buttonSize,
      this.borderRadius})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widthConvert(context, 375),
      height: phoneNumber != null
          ? Constants.buttonHeightSmall
          : buttonSize ?? Constants.buttonHeight,
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColors.transparent),
          side: MaterialStateProperty.all(
            BorderSide(
                color: phoneNumber != null
                    ? AppColors.error700
                    : color ?? AppColors.primary),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: borderRadius != null
                  ? borderRadius!
                  : BorderRadius.circular(
                      heightConvert(context, 24),
                    ),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            iconLeft != null || phoneNumber != null
                ? Padding(
                    padding: EdgeInsets.only(
                      right: widthConvert(context, 12),
                    ),
                    child: iconLeft != null
                        ? buildIconLeft(context, iconSize!)
                        : buildCallOut(context, iconSize!),
                  )
                : const SizedBox(),
            Text(
              phoneNumber != null ? '$text $phoneNumber' : text,
              style: labelStyle ??
                  Styles.typography.copyWith(
                      color: phoneNumber != null ? AppColors.error900 : color,
                      height: 1),
            ),
            iconRight != null
                ? Padding(
                    padding: EdgeInsets.only(
                      left: widthConvert(context, 12),
                    ),
                    child: buildIconRight(context, iconSize!),
                  )
                : const SizedBox(),
          ],
        ),
        onPressed: () async {
          if (onClick != null) {
            await onClick!();
          }
          if (phoneNumber != null) {
            await launchUrlString("tel://$phoneNumber");
          }
        },
      ),
    );
  }

  Widget buildIconLeft(BuildContext context, double iconSize) {
    if (iconLeft != null) {
      return SvgPicture.asset(
        iconLeft!,
        width: widthConvert(context, iconSize),
        height: heightConvert(context, iconSize),
        fit: BoxFit.fill,
        color: color,
      );
    }
    return const SizedBox();
  }

  Widget buildCallOut(BuildContext context, double iconSize) {
    if (phoneNumber != null) {
      return SvgPicture.asset(
        IconEnums.phone_call,
        width: widthConvert(context, iconSize),
        height: heightConvert(context, iconSize),
        fit: BoxFit.fill,
        color: AppColors.error900,
      );
    }
    return const SizedBox();
  }

  Widget buildIconRight(BuildContext context, double iconSize) {
    if (iconRight != null) {
      return SvgPicture.asset(
        iconRight!,
        width: widthConvert(context, iconSize),
        height: heightConvert(context, iconSize),
        fit: BoxFit.fill,
        color: phoneNumber != null ? AppColors.error900 : color,
      );
    }
    return const SizedBox();
  }
}
