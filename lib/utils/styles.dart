import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'colors.dart';
import 'constants.dart';
import 'icons.dart';

class Styles {
  static TextStyle titleApp = TextStyle(
      fontFamily: 'Inter',
      fontSize: 26.0,
      color: AppColors.primary,
      fontWeight: FontWeight.bold);

  static TextStyle titleAppbar = const TextStyle(
      fontFamily: 'Inter',
      fontSize: 18.0,
      color: AppColors.background,
      fontWeight: FontWeight.bold);

  static TextStyle titleItem = const TextStyle(
      fontFamily: 'Inter',
      fontSize: 16.0,
      color: AppColors.black,
      fontWeight: FontWeight.bold);

  static TextStyle content = const TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.0,
    color: AppColors.black,
  );

  static TextStyle titleButton = const TextStyle(
    fontFamily: 'Inter',
    fontSize: 14.0,
    color: AppColors.background,
    fontWeight: FontWeight.bold,
  );

  static TextStyle defaultTextStyle = const TextStyle(
    fontSize: 15.0,
  );

  static TextStyle heading = const TextStyle(
    fontFamily: 'InterBold',
  );

  // Use for: Feature introductions. top level headers.
  static TextStyle heading2 = heading.copyWith(
    height: 32 / 26,
    fontSize: 26.0,
    color: AppColors.primary,
  );

  // Use for: Headings that identify key functionality.
  static TextStyle heading4 = heading.copyWith(
    height: 24 / 18,
    fontSize: 16.0,
    color: AppColors.primary,
  );

  // Use for: Sub-section and field group headings.
  static TextStyle heading5 = heading.copyWith(
    height: 20 / 14,
    fontSize: 14.0,
    color: AppColors.primary,
  );

  //Use for: content, main typeface for App
  static TextStyle bodyRegular = defaultTextStyle.copyWith(
    height: 20 / 15,
    fontFamily: 'InterRegular',
  );

  static TextStyle desInsurance = defaultTextStyle.copyWith(
      height: 12 / 10, fontFamily: 'Inter', fontSize: 10);

  // Use for: Highligh content, main typeface
  static TextStyle bodyBold = defaultTextStyle.copyWith(
    height: 20 / 15,
    fontFamily: 'InterBold',
  );

  static TextStyle subtitleLarge = const TextStyle(
    fontSize: 13.0,
    height: 16 / 13,
    fontFamily: 'InterRegular',
  );

  static TextStyle descriptionNoti =
      TextStyle(height: 16 / 13, fontSize: 13.0, color: AppColors.primary);

  static TextStyle subtitleSmall = const TextStyle(
      fontSize: 12.0, fontFamily: 'InterRegular', height: 14.0 / 12.0);

  static TextStyle subtitleSmallest = const TextStyle(
      fontSize: 12.0, fontFamily: 'InterRegular', height: 13.0 / 11.0);

  //Use for: paragraph content
  static TextStyle paragraph = defaultTextStyle.copyWith(
    height: 24 / 15,
    fontFamily: 'InterRegular',
  );

  //
  static TextStyle typography = heading.copyWith(
    height: 24 / 12,
    fontSize: 12,
  );

  static TextStyle chartX = const TextStyle(
    fontSize: 8.0,
    fontFamily: 'Inter',
    height: 14.0 / 8.0,
    fontWeight: FontWeight.normal,
  );
  static TextStyle style15grey = TextStyle(
      color: AppColors.grey1,
      fontWeight: FontWeight.w900,
      fontSize: 15,
      fontFamily: 'Inter',
      decoration: TextDecoration.none);
  static TextStyle styleHintText = TextStyle(
      color: AppColors.grey1,
      fontWeight: FontWeight.w400,
      fontSize: 15,
      fontFamily: 'Inter',
      decoration: TextDecoration.none);

  // text button
  static TextStyle textButton = const TextStyle(
    fontFamily: 'InterBold',
  );

  static TextStyle buttonLargeUppercase =
      textButton.copyWith(height: 24 / 15, fontSize: 15.0);

  static TextStyle buttonLargeLowercase =
      textButton.copyWith(height: 24 / 15, fontSize: 15.0);

  static TextStyle buttonSmallUppercase =
      textButton.copyWith(height: 24 / 12, fontSize: 12.0);

  static TextStyle buttonSmallLowercase =
      textButton.copyWith(height: 24 / 12, fontSize: 12.0);

  static TextStyle profileTextStyle = TextStyle(
      height: 24 / 12, fontSize: 12.0, color: Colors.black.withOpacity(0.9));

  // Shadow
  static BoxDecoration deepBase = const BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: AppColors.deepBaseShadow,
        spreadRadius: 8,
        blurRadius: 8,
        offset: Offset(0, 8), // changes position of shadow
      ),
    ],
  );

  static BoxDecoration shadowBase = const BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: AppColors.deepBaseShadow,
        spreadRadius: 4,
        blurRadius: 4,
        offset: Offset(0, 4), // changes position of shadow
      ),
    ],
  );

  static BoxDecoration colored = const BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: AppColors.coloredShadow,
        spreadRadius: 8,
        blurRadius: 8,
        offset: Offset(0, 8), // changes position of shadow
      ),
    ],
  );

  static BoxDecoration topBarShadow = const BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: AppColors.topBarShadow,
        spreadRadius: 4,
        blurRadius: 4,
        offset: Offset(0, 4), // changes position of shadow
      ),
    ],
  );
  static BoxDecoration cardShadow = const BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: AppColors.cardShadow,
        spreadRadius: 4,
        blurRadius: 4,
        offset: Offset(0, 4), // changes position of shadow
      ),
    ],
  );

  static BoxDecoration notificationShadow = const BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: AppColors.notificationShadow,
        spreadRadius: 24,
        blurRadius: 24,
        offset: Offset(0, 24), // changes position of shadow
      ),
    ],
  );

  static BoxDecoration cardButtonShadow = const BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: AppColors.cardShadow,
        spreadRadius: 1,
        blurRadius: 0,
        offset: Offset(0, -2), // changes position of shadow
      ),
    ],
  );

  static Gradient textGradient = const LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [
      0.1,
      0.4,
      0.6,
      0.9,
    ],
    colors: [
      Color(0xffffffff),
      // Color(0xfffffa8a),
      // Color(0xffddac17),
      // Color(0xffffff95),
    ],
  );

  static LinearGradient backgroundGradient = const LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      stops: [
        0.1,
        0.4,
        0.6,
        0.9,
      ],
      colors: [
        Color(0xfff5c230),
        Color(0xfffffa8a),
        Color(0xffddac17),
        Color(0xffffff95),
      ]);

  static Shader defaultGradientShared = const LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    // stops: [
    //   0.1,
    //   0.4,
    //   0.6,
    //   0.9,
    // ],
    colors: [
      Color(0xffffffff),
      Color(0xffffffff),
    ],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  static Paint defaultGradientPaint = Paint()..shader = defaultGradientShared;

  static InputDecoration dobDecoration = InputDecoration(
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        child: SvgPicture.asset(IconEnums.cake,
            width: 10,
            height: 10,
            fit: BoxFit.contain,
            color: AppColors.grayLight),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(ViewConstants.defaultBorderRadiusTextInput),
        ),
        borderSide: BorderSide(color: AppColors.grayLight),
      ),
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.neutral300),
        borderRadius: BorderRadius.all(
          Radius.circular(ViewConstants.defaultBorderRadiusTextInput),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4.0),
        ),
        borderSide: BorderSide(color: AppColors.dodgerBlue),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4.0),
        ),
        borderSide: BorderSide(color: AppColors.error700),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4.0),
        ),
        borderSide: BorderSide(color: AppColors.error700),
      ));

  static TextStyle getStyleByIndex(bool bool) {
    if (bool) {
      return Styles.titleButton.copyWith(
        color: AppColors.background,
      );
    } else {
      return Styles.heading4.copyWith(
        color: AppColors.primary,
      );
    }
  }

  static EdgeInsets defaultPageMargin =
      const EdgeInsets.symmetric(horizontal: 16);
}
